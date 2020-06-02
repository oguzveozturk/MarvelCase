//
//  CharacterDetailBuilder.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit
class CharacterDetailBuilder {
    
    func build(result: Results) -> UIViewController {
        let vc = CharacterDetailViewController(result: result)
        return vc
    }
}
