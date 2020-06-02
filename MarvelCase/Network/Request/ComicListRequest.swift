//
//  ComicListRequest.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation

class ComicListRequest: NetworkRequest<ComicRequestModel, ComicListResponseModel> {
    
    override init() {
        super.init()
        endpoint = "/characters/"
        checkInternet = true
    }
}
