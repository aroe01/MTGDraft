//
//  CardListView.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI

struct CardListView: View {
    @State private var model: CardListViewModel

    init(set: MTGSet) {
        _model = State(initialValue: CardListViewModel(set: set))
    }

    var body: some View {
        Group {
            if model.isLoading && model.cards.isEmpty {
                ProgressView()
            } else {
                List {
                    ForEach(model.filteredCards) { card in
                        NavigationLink(destination: CardDetailView(card: card)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(card.name)
                                    .font(.headline)
                                HStack(spacing: 4) {
                                    Text(card.typeLine)
                                    if let cost = card.manaCost, !cost.isEmpty {
                                        Text("·")
                                        ManaCostView(cost: cost)
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }

                    if model.hasMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                Task { await model.loadNextPage() }
                            }
                    }
                }
            }
        }
        .navigationTitle(model.set.name)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $model.searchQuery, prompt: "Search by name or type")
        .task {
            await model.loadCards()
        }
        .alert("Error", isPresented: Binding(
            get: { model.error != nil },
            set: { if !$0 { model.error = nil } }
        )) {
            Button("OK") { model.error = nil }
        } message: {
            Text(model.error?.localizedDescription ?? "")
        }
    }
}
