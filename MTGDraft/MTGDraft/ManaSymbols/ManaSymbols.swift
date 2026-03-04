//
//  ManaSymbols.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//
//  Maps Scryfall mana notation (e.g. "{W}", "{2/U}") to asset catalog image names.
//  Asset names correspond to imagesets under Assets.xcassets/ManaSymbols/.
//  Symbols and asset names are sourced from https://api.scryfall.com/symbology.
//

import SwiftUI

enum ManaSymbols {

    // MARK: - Notation → asset name

    static let imageNameByNotation: [String: String] = [
        "{T}": "mana-T",
        "{Q}": "mana-Q",
        "{E}": "mana-E",
        "{P}": "mana-P",
        "{PW}": "mana-PW",
        "{CHAOS}": "mana-CHAOS",
        "{A}": "mana-A",
        "{TK}": "mana-TK",
        "{X}": "mana-X",
        "{Y}": "mana-Y",
        "{Z}": "mana-Z",
        "{0}": "mana-0",
        "{½}": "mana-HALF",
        "{1}": "mana-1",
        "{2}": "mana-2",
        "{3}": "mana-3",
        "{4}": "mana-4",
        "{5}": "mana-5",
        "{6}": "mana-6",
        "{7}": "mana-7",
        "{8}": "mana-8",
        "{9}": "mana-9",
        "{10}": "mana-10",
        "{11}": "mana-11",
        "{12}": "mana-12",
        "{13}": "mana-13",
        "{14}": "mana-14",
        "{15}": "mana-15",
        "{16}": "mana-16",
        "{17}": "mana-17",
        "{18}": "mana-18",
        "{19}": "mana-19",
        "{20}": "mana-20",
        "{100}": "mana-100",
        "{1000000}": "mana-1000000",
        "{∞}": "mana-INFINITY",
        "{W/U}": "mana-WU",
        "{W/B}": "mana-WB",
        "{B/R}": "mana-BR",
        "{B/G}": "mana-BG",
        "{U/B}": "mana-UB",
        "{U/R}": "mana-UR",
        "{R/G}": "mana-RG",
        "{R/W}": "mana-RW",
        "{G/W}": "mana-GW",
        "{G/U}": "mana-GU",
        "{B/G/P}": "mana-BGP",
        "{B/R/P}": "mana-BRP",
        "{G/U/P}": "mana-GUP",
        "{G/W/P}": "mana-GWP",
        "{R/G/P}": "mana-RGP",
        "{R/W/P}": "mana-RWP",
        "{U/B/P}": "mana-UBP",
        "{U/R/P}": "mana-URP",
        "{W/B/P}": "mana-WBP",
        "{W/U/P}": "mana-WUP",
        "{C/W}": "mana-CW",
        "{C/U}": "mana-CU",
        "{C/B}": "mana-CB",
        "{C/R}": "mana-CR",
        "{C/G}": "mana-CG",
        "{2/W}": "mana-2W",
        "{2/U}": "mana-2U",
        "{2/B}": "mana-2B",
        "{2/R}": "mana-2R",
        "{2/G}": "mana-2G",
        "{H}": "mana-H",
        "{W/P}": "mana-WP",
        "{U/P}": "mana-UP",
        "{B/P}": "mana-BP",
        "{R/P}": "mana-RP",
        "{G/P}": "mana-GP",
        "{C/P}": "mana-CP",
        "{HW}": "mana-HW",
        "{HR}": "mana-HR",
        "{W}": "mana-W",
        "{U}": "mana-U",
        "{B}": "mana-B",
        "{R}": "mana-R",
        "{G}": "mana-G",
        "{C}": "mana-C",
        "{S}": "mana-S",
        "{L}": "mana-L",
        "{D}": "mana-D"
    ]

    // MARK: - Parsing

    /// Parses a Scryfall mana cost string (e.g. "{2}{W}{U}") into
    /// an ordered list of asset names ready for use with Image(_:).
    static func parse(_ cost: String) -> [String] {
        cost.matches(of: /\{[^}]+\}/)
            .compactMap { imageNameByNotation[String($0.output)] }
    }
}

// MARK: - ManaCostView

/// Renders a Scryfall mana cost string as a row of symbol images.
///
///     ManaCostView(cost: "{2}{W}{U}")
///
struct ManaCostView: View {
    let cost: String
    var size: CGFloat = 16

    var body: some View {
        let symbols = ManaSymbols.parse(cost)
        if !symbols.isEmpty {
            HStack(spacing: 2) {
                ForEach(symbols.enumerated(), id: \.0) { index, name in
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                }
            }
        }
    }
}
