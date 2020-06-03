//
//  CharacterListResponseModel.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//
import Foundation

struct CharacterListResponseModel: Codable {
    let status: String
    let data: CharacterData
}

struct CharacterData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CharacterResults]
}

struct CharacterResults: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    let path : String?
    let `extension`: String?
}

struct CharacterListResponseError: Codable {
    let errorCode: Int?
    let errorDescription: String?
    let success: Bool?
}
