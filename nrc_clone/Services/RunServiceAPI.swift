//
//  RunService.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import Foundation

struct RunResponse: Codable {
    var runs: [RunDetailsDTO]
}

enum RunServiceError: LocalizedError {
    case unauthorized
    case notFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .unauthorized:       return "Session expired. Please sign in again."
        case .notFound:           return "Not Found"
        case .unknown:            return "Something went wrong. Please try again."
        }
    }
}

struct ErrorResponse: Codable {
    var error: String
}

let dev = false

class RunServiceAPI{
    static let shared = RunServiceAPI()
    
    private let url = dev ? "http://localhost:8080" : "https://stride-rc.wm.r.appspot.com"
    
    func fetchAllRuns(token: String, since lastSyncedDate: Date? = nil) async throws -> [RunDetailsDTO] {
        if token.isEmpty{
            throw URLError(.userAuthenticationRequired)
        }
        
        var urlString = "\(url)/api/runs"
        if let lastSyncedDate {
            urlString += "?after=\(lastSyncedDate.ISO8601Format())"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else { throw RunServiceError.unknown }
        switch http.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let runData = try decoder.decode(RunResponse.self, from: data).runs
            return runData
        case 401:
            throw RunServiceError.unauthorized
        default:
            throw RunServiceError.unknown
        }
    }
    
    func createRun(token: String, run: RunDetails) async throws {
        if token.isEmpty{
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(url)/api/runs") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        request.httpBody = try encoder.encode(run.toDTO())
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RunServiceError.unknown }

        switch http.statusCode {
        case 201: return
        case 401: throw RunServiceError.unauthorized
        default: throw RunServiceError.unknown
        }
    }
    
    func updateRun(token: String, run: RunDetails) async throws{
        if token.isEmpty{
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(url)/api/runs/\(run.id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(run.toDTO())

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RunServiceError.unknown }

        switch http.statusCode {
        case 200: return
        case 401: throw RunServiceError.unauthorized
        case 404: throw RunServiceError.notFound
        default: throw RunServiceError.unknown
        }
    }
    
    func deleteRun(token: String, id: UUID) async throws{
        if token.isEmpty{
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(url)/api/runs/\(id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RunServiceError.unknown }

        switch http.statusCode {
        case 200: return
        case 401: throw RunServiceError.unauthorized
        case 404: throw RunServiceError.notFound
        default: throw RunServiceError.unknown
        }
    }
}
