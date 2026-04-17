//
//  ActivityTabView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI
import SwiftData

struct ActivityTabView: View {
    // MARK: Data in
    @Environment(\.modelContext) var context
    // MARK: Data I Own
    @State private var vm = ActivityViewModel()

    @Query var runs: [RunDetails]

    init() {
        _runs = Query(sort: \RunDetails.date, order: .reverse)
    }

    var body: some View {
        @Bindable var vm = vm

        NavigationStack {
            ActivityScrollView(vm: vm, runs: runs)
                .background(.tertiary.opacity(0.1))
                .navigationTitle("Activity")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "plus") {
                            withAnimation { vm.showAddRun = true }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            withAnimation { vm.showSettings = true }
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .fullScreenCover(isPresented: $vm.showAddRun) { AddEditRunView() }
                .fullScreenCover(isPresented: $vm.showSettings) { ProfileView() }
                .navigationDestination(isPresented: Binding(
                    get: { vm.selectedRun != nil },
                    set: { if !$0 { vm.selectedRun = nil; vm.selectedStat = nil; vm.chartSelectedDate = nil } }
                )) {
                    if let run = vm.selectedRun { FinishedRunView(runDetails: run) }
                }
                .navigationDestination(isPresented: $vm.showAllActivity) {
                    AllActivityView(runs: runs) { run in vm.selectedRun = run }
                }
                .sheet(isPresented: $vm.showSelectedFilter) {
                    DateFilterPickerView(selectedFilter: vm.selectedFilter, selectedDate: $vm.selectedDate)
                        .presentationDetents([.height(260)])
                }
                .onChange(of: vm.selectedFilter) { vm.chartSelectedDate = nil }
                .onChange(of: runs) { vm.invalidateCache() }
                .onChange(of: vm.selectedDate) { vm.invalidateCache() }
        }
    }
}

#Preview(traits: .swiftData) {
    ActivityTabView()
        .withAppEnvironment()
}
