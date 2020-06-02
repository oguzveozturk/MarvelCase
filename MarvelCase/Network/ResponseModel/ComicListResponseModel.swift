//
//  ComicListResponseModel.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation

struct ComicListResponseModel: Codable {
    let status: String
    let data: ComicData
}

struct ComicData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [ComicResults]
}

struct ComicResults: Codable {
    let id: Int?
    let title: String?
    let thumbnail: Thumbnail?
    let dates: [ComicDates]?
    let orderedDate: Date?
}

struct ComicDates: Codable {
    let type: String?
    let date: String?
}

struct ComicListResponseError: Codable {
    let errorCode: Int?
    let errorDescription: String?
    let success: Bool?
}
