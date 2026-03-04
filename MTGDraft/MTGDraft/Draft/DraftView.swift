//
//  DraftView.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI

struct DraftView: View {
    @State private var model: DraftViewModel

    init(set: MTGSet) {
        _model = State(initialValue: DraftViewModel(set: set))
    }

    var body: some View {
        Group {
            if model.isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading \(model.set.name)…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else if let card = model.drawnCard {
                ScrollView {
                    VStack(spacing: 16) {
                        cardImage(for: card)
                            .frame(maxWidth: .infinity)

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(card.name)
                                    .font(.title2.bold())
                                Spacer()
                                ManaCostView(cost: card.manaCost ?? "")
                            }
                            Text(card.typeLine)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let text = card.oracleText {
                                Divider()
                                Text(text)
                                    .font(.body)
                            }
                        }
                        .padding(.horizontal)

                        Button(action: { model.draw() }) {
                            Label("Draw Again", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
        .navigationTitle(model.set.name)
        .navigationBarTitleDisplayMode(.inline)
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

    @ViewBuilder
    private func cardImage(for card: MTGCard) -> some View {
        if let faces = card.cardFaces, let first = faces.first, let uris = first.imageUris {
            AsyncImage(url: uris.normal) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                cardPlaceholder
            }
        } else if let uris = card.imageUris {
            AsyncImage(url: uris.normal) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                cardPlaceholder
            }
        } else {
            cardPlaceholder
        }
    }

    private var cardPlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.secondary.opacity(0.2))
            .aspectRatio(0.716, contentMode: .fit)
            .padding(.horizontal)
    }
}
