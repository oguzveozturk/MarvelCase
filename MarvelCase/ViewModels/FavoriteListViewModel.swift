//
//  FavoriteListViewModela.swift
//  MarvelCase
//
//  Created by Oguz on 3.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation

final class FavoriteListViewModel: NSObject {
    
    var favCharacters = [Character]()
    
    private lazy var localData = PersistantManager.shared
    
    
    func fetchChracters(complete: @escaping (_ sucsess: Bool)->() ){
        favCharacters = localData.fetch(Character.self)
        complete(true)
    }
}

