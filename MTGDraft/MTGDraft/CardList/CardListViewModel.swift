//
//  CardListViewModel.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

@MainActor
@Observable
class CardListViewModel {
    let set: MTGSet

    var cards: [MTGCard] = []
    var searchQuery = ""
    var isLoading = false
    var error: Error?
    var hasMore = false
    private var nextPage: URL?

    var filteredCards: [MTGCard] {
        guard !searchQuery.isEmpty else { return cards }
        return cards.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            $0.typeLine.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    init(set: MTGSet) {
        self.set = set
    }

    func loadCards() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await ScryfallService.shared.fetchCards(inSet: set.code)
            cards = result.data
            hasMore = result.hasMore
            nextPage = result.nextPage
        } catch {
            self.error = error
        }
    }

    func loadNextPage() async {
        guard hasMore, let url = nextPage, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let result: ScryfallList<MTGCard> = try await ScryfallService.shared.request(url: url)
            cards.append(contentsOf: result.data)
            hasMore = result.hasMore
            nextPage = result.nextPage
        } catch {
            self.error = error
        }
    }
}
