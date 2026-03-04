//
//  DraftViewModel.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

@MainActor
@Observable
class DraftViewModel {
    let set: MTGSet

    private var cards: [MTGCard] = []
    var drawnCard: MTGCard?
    var isLoading = false
    var error: Error?

    init(set: MTGSet) {
        self.set = set
    }

    func loadCards() async {
        isLoading = true
        defer { isLoading = false }
        do {
            cards = try await ScryfallService.shared.fetchAllCards(inSet: set.code)
            draw()
        } catch {
            self.error = error
        }
    }

    func draw() {
        drawnCard = cards.randomElement()
    }
}
