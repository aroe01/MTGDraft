//
//  MTGSet.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import Foundation

struct MTGSet: Decodable, Identifiable {
    let id: UUID
    let code: String
    let name: String
    let setType: String
    let releasedAt: String?
    let cardCount: Int
    let digital: Bool
    let iconSvgUri: URL
}
