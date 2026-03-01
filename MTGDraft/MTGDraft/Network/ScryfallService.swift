//
//  ScryfallService.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

struct ScryfallService {
    static let shared = ScryfallService()

    private let baseURL = URL(string: "https://api.scryfall.com")!

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": "MTGDraft/1.0",
            "Accept": "application/json"
        ]
        return URLSession(configuration: config)
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    // MARK: - Core request

    /// Fetch a full URL directly. Used for paginated `next_page` URLs.
    func request<T: Decodable>(url: URL) async throws -> T {
        print("[Scryfall] → GET \(url)")

        let start = Date()
        let (data, response) = try await session.data(from: url)
        let elapsed = Date().timeIntervalSince(start)

        guard let http = response as? HTTPURLResponse else {
            print("[Scryfall] ✘ Non-HTTP response for \(url)")
            throw ScryfallError.invalidResponse(0)
        }

        print("[Scryfall] ← \(http.statusCode) \(url) (\(data.count) bytes, \(String(format: "%.2f", elapsed))s)")

        guard (200..<300).contains(http.statusCode) else {
            let apiError = try? decoder.decode(ScryfallAPIError.self, from: data)
            let message = apiError?.details ?? "HTTP \(http.statusCode)"
            print("[Scryfall] ✘ Error: \(message)")
            throw ScryfallError.apiError(message)
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            print("[Scryfall] ✔ Decoded \(T.self) from \(url)")
            return decoded
        } catch {
            print("[Scryfall] ✘ Decode failed for \(T.self): \(error)")
            throw error
        }
    }

    private func get<T: Decodable>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw ScryfallError.invalidURL(path)
        }
        return try await request(url: url)
    }

    // MARK: - Sets

    func fetchSets() async throws -> [MTGSet] {
        let list: ScryfallList<MTGSet> = try await get("sets")
        return list.data
    }

    func fetchSet(code: String) async throws -> MTGSet {
        try await get("sets/\(code)")
    }

    func fetchSet(id: UUID) async throws -> MTGSet {
        try await get("sets/\(id.uuidString.lowercased())")
    }

    // MARK: - Cards

    func searchCards(query: String) async throws -> ScryfallList<MTGCard> {
        try await get("cards/search", queryItems: [URLQueryItem(name: "q", value: query)])
    }

    func fetchCards(inSet setCode: String) async throws -> ScryfallList<MTGCard> {
        try await searchCards(query: "set:\(setCode)")
    }

    func fetchCard(id: UUID) async throws -> MTGCard {
        try await get("cards/\(id.uuidString.lowercased())")
    }

    func fetchCard(named name: String) async throws -> MTGCard {
        try await get("cards/named", queryItems: [URLQueryItem(name: "exact", value: name)])
    }

    func fetchRandomCard() async throws -> MTGCard {
        try await get("cards/random")
    }

    func autocomplete(query: String) async throws -> [String] {
        let catalog: ScryfallCatalog = try await get("cards/autocomplete", queryItems: [URLQueryItem(name: "q", value: query)])
        return catalog.data
    }
}

// MARK: - Errors

enum ScryfallError: LocalizedError {
    case invalidURL(String)
    case invalidResponse(Int)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let path): return "Could not construct URL for path: \(path)"
        case .invalidResponse(let code): return "Invalid response (HTTP \(code))"
        case .apiError(let message): return message
        }
    }
}

// MARK: - Response types

struct ScryfallList<T: Decodable>: Decodable {
    let data: [T]
    let hasMore: Bool
    let nextPage: URL?
    let totalCards: Int?
}

struct ScryfallCatalog: Decodable {
    let totalValues: Int
    let data: [String]
}

private struct ScryfallAPIError: Decodable {
    let details: String
}
