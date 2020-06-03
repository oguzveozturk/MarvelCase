//
//  ChracterListBuilder.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

class CharacterListBuilder {
    
    func buildWithNavigation(fav:FavoriteListViewModel, data: CharacterListViewModel?) -> UINavigationController {
        let vc = CharacterListViewController(data: data, favorites: fav)
        return UINavigationController(rootViewController:vc)
    }
    
    func build(fav: FavoriteListViewModel) -> UIViewController {
        return CharacterListViewController(data: nil, favorites: fav)
    }
}
