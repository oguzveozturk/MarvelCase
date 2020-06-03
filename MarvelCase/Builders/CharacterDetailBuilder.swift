//
//  CharacterDetailBuilder.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit
class CharacterDetailBuilder {
    
    func build(characterData: CharacterResults,_ persistenceManager: PersistantManager) -> UIViewController {
        let vc = CharacterDetailViewController(result: characterData, persistenceManager: persistenceManager)
        return vc
    }
}
