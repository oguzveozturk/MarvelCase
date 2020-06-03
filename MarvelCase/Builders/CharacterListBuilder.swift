//
//  ChracterListBuilder.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

class CharacterListBuilder {
    
    func buildWithNavigation(data: CharacterListViewModel?) -> UINavigationController {
        let vc = CharacterListViewController(data: data, favorites: nil)
        return UINavigationController(rootViewController:vc)
    }
    
    func build(data: FavoriteListViewModel?) -> UIViewController {
        return CharacterListViewController(data: nil, favorites: data)
    }
}
