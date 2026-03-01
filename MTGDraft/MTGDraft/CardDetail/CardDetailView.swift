//
//  CardDetailView.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI

struct CardDetailView: View {
    let card: MTGCard

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                cardImage
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(card.name)
                            .font(.title2.bold())
                        Spacer()
                        if let cost = card.manaCost {
                            ManaCostView(cost: cost)
                        }
                    }

                    Text(card.typeLine)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Divider()

                    if let text = card.oracleText {
                        Text(text)
                            .font(.body)
                    }

                    if let flavor = card.flavorText {
                        Text(flavor)
                            .font(.footnote)
                            .italic()
                            .foregroundStyle(.secondary)
                    }

                    if card.power != nil || card.toughness != nil || card.loyalty != nil {
                        Divider()
                        statsRow
                    }

                    Divider()
                    metaRow
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var cardImage: some View {
        if let faces = card.cardFaces, let first = faces.first, let uris = first.imageUris {
            // Double-faced card: show front face image
            AsyncImage(url: uris.normal) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                imagePlaceholder
            }
        } else if let uris = card.imageUris {
            AsyncImage(url: uris.normal) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                imagePlaceholder
            }
        } else {
            imagePlaceholder
        }
    }

    private var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.secondary.opacity(0.2))
            .aspectRatio(0.716, contentMode: .fit)
            .padding(.horizontal)
    }

    private var statsRow: some View {
        HStack(spacing: 16) {
            if let power = card.power, let toughness = card.toughness {
                Label("\(power)/\(toughness)", systemImage: "shield")
            }
            if let loyalty = card.loyalty {
                Label(loyalty, systemImage: "star")
            }
        }
        .font(.subheadline)
    }

    private var metaRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(card.setName)
                Text("·")
                Text("#\(card.collectorNumber)")
                Text("·")
                Text(card.rarity.capitalized)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if let artist = card.artist {
                Text("Illustrated by \(artist)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let prices = card.prices {
                HStack(spacing: 12) {
                    if let usd = prices.usd { Text("$\(usd)") }
                    if let usdFoil = prices.usdFoil { Text("$\(usdFoil) foil") }
                    if let eur = prices.eur { Text("€\(eur)") }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}
