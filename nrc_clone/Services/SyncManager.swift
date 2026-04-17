//
//  SyncManager.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import Foundation
import SwiftData
import Network

@Observable
class SyncManager {
    // Monitoring offline/online
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "network.monitor")
    var isConnected = false
    private var hasInitialized = false

    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    func startMonitoring(token: String, context: ModelContext) {
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self else { return }
                let connected = path.status == .satisfied
                
                DispatchQueue.main.async {
                    let wasOffline = !self.isConnected
                    self.isConnected = connected
                    
                    if !self.hasInitialized {
                        self.hasInitialized = true
                        return
                    }
                    
                    if connected && wasOffline {

                        Task {
                            try await self.pushPending(token: token, context: context)
                            try await self.pullDelta(token: token, context: context)
                        }
                    }
                }
            }
            monitor.start(queue: queue)
        }
        
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func pushPending(token: String, context: ModelContext) async throws {
        let pending = try context.fetch(FetchDescriptor<RunDetails>(
            predicate: #Predicate {$0.syncStatus == "pending"}
        ))
        
        for run in pending{
            do{
                try await RunServiceAPI.shared.createRun(token: token, run: run)
                run.syncStatus = "synced"
            } catch{
                run.syncStatus = "failed"
            }
        }   
        
        try context.save()
        
    }
    
    func pullDelta(token: String, context: ModelContext) async throws {

        let lastSyncedAt = UserDefaults.standard.object(forKey: "lastSyncedAt") as? Date

        let existing = try context.fetch(FetchDescriptor<RunDetails>())
        let newRuns = try await RunServiceAPI.shared.fetchAllRuns(token: token, since: lastSyncedAt)
 
        for newRun in newRuns{
            if let existingRun = existing.first(where: {$0.id == newRun.id}) {
                if newRun.isDeleted {
                    context.delete(existingRun)
                } else if newRun.updatedAt > existingRun.updatedAt{
                    context.delete(existingRun)
                    context.insert(newRun.toModel())
                }
            } else if !newRun.isDeleted{
                context.insert(newRun.toModel())
            }
        }

        UserDefaults.standard.set(Date(), forKey: "lastSyncedAt")
    }
    
    func pullFreshRuns(token:String, context: ModelContext) async {

        isLoading = true
        errorMessage = nil

        do{
            let runs = try await RunServiceAPI.shared.fetchAllRuns(token: token)
            let existing = try context.fetch(FetchDescriptor<RunDetails>())
            let existingIDs = Set(existing.map { $0.id })

            for run in runs {
                if !existingIDs.contains(run.id) && !run.isDeleted{
                    context.insert(run.toModel())
                }
            }
            UserDefaults.standard.set(Date(), forKey: "lastSyncedAt")

        } catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func clearLocalData(context: ModelContext) {
        do {
            try context.delete(model: RunDetails.self)
            UserDefaults.standard.removeObject(forKey: "lastSyncedAt")
        } catch {
            print("Failed to clear local data: \(error)")
        }
    }
    
}

