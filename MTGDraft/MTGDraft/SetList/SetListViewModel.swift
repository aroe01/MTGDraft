//
//  SetListViewModel.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

@MainActor
@Observable
class SetListViewModel {
    var sets: [MTGSet] = []
    var searchQuery = ""
    var isLoading = false
    var error: Error?

    var filteredSets: [MTGSet] {
        guard !searchQuery.isEmpty else { return sets }
        return sets.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            $0.code.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    func loadSets() async {
        isLoading = true
        defer { isLoading = false }
        do {
            sets = try await ScryfallService.shared.fetchSets()
        } catch {
            self.error = error
        }
    }
}
