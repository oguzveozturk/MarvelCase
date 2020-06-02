//
//  ChracterListBuilder.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

class ChracterListBuilder {
    
    func build() -> UINavigationController {
        let vc = CharacterListViewController()
        return UINavigationController(rootViewController:vc)
    }
}
