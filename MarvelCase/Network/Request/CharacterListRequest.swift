//
//  CharacterListRequest.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//
import Foundation

class CharacterListRequest: NetworkRequest<CharacterRequestModel, CharacterListResponseModel> {
    
    override init() {
        super.init()
        endpoint = "/characters?&limit=30&offset="
        checkInternet = true
    }
}
