//
//  CharacterDetailBuilder.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit
class CharacterDetailBuilder {
    
    func build(viewController: UIViewController?,characterData: CharacterResults,isFav: Bool) -> UIViewController {
        let vc = CharacterDetailViewController(result: characterData, isFav: isFav)
        vc.delegate = viewController as? CharacterDetailViewControllerDelegate
        return vc
    }
}
