//
//  DraftViewModel.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

@MainActor
@Observable
class DraftSetListViewModel {

    // Add set codes here to make them available for drafting.
    static let draftSets: [DraftConfig] = [
        LorwynEclipsedConfig()
    ]

    var sets: [MTGSet] = []
    var isLoading = false
    var error: Error?

    func loadSets() async {
        isLoading = true
        defer { isLoading = false }
        do {
            sets = try await withThrowingTaskGroup(of: MTGSet.self) { group in
                for config in Self.draftSets {
                    group.addTask { try await ScryfallService.shared.fetchSet(code: config.setId) }
                }
                var result: [MTGSet] = []
                for try await set in group {
                    result.append(set)
                    print(set.iconSvgUri)
                }
                return result
            }
        } catch {
            self.error = error
        }
    }
}
