//
//  MTGCard.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

struct MTGCard: Decodable, Identifiable {
    let id: UUID
    let name: String
    let lang: String
    let layout: String
    let cmc: Double
    let typeLine: String
    let oracleText: String?
    let manaCost: String?
    let colors: [String]?
    let colorIdentity: [String]
    let keywords: [String]
    let rarity: String
    let setCode: String
    let setName: String
    let collectorNumber: String
    let digital: Bool
    let flavorText: String?
    let artist: String?
    let imageUris: ImageUris?
    let cardFaces: [CardFace]?
    let prices: Prices?
    let power: String?
    let toughness: String?
    let loyalty: String?
    let releasedAt: String
    let scryfallUri: URL
    let uri: URL

    // "set" is a reserved word in Swift, so we remap it here.
    // Note: CodingKeys must enumerate all properties because defining
    // the enum disables automatic synthesis for the rest.
    enum CodingKeys: String, CodingKey {
        case id, name, lang, layout, cmc, rarity, digital, artist
        case power, toughness, loyalty
        case typeLine, oracleText, manaCost
        case colors, colorIdentity, keywords
        case flavorText, imageUris, cardFaces, prices
        case setName, collectorNumber, releasedAt, scryfallUri, uri
        case setCode = "set"
    }
}

struct ImageUris: Decodable {
    let small: URL
    let normal: URL
    let large: URL
    let png: URL
    let artCrop: URL
    let borderCrop: URL
}

struct CardFace: Decodable {
    let name: String
    let typeLine: String?
    let oracleText: String?
    let manaCost: String?
    let colors: [String]?
    let imageUris: ImageUris?
    let power: String?
    let toughness: String?
    let loyalty: String?
    let flavorText: String?
    let artist: String?
}

struct Prices: Decodable {
    let usd: String?
    let usdFoil: String?
    let eur: String?
    let eurFoil: String?
    let tix: String?
}
