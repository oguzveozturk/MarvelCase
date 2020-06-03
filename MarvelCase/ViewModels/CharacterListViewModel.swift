//
//  CharacterListViewModel.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation

final class CharacterListViewModel: NSObject {
    
    var characterData = [CharacterResults]()
    
    
    func fetchChracters(offSet: String, complete: @escaping (_ sucsess: Bool)->() ){
        
        APIManager.shared.requestForCharacterList(offset: offSet) { (response, responseEmtpy) in
            if let data = response?.data.results {
                self.characterData += data
                complete(true)
            }
        }
    }
}

