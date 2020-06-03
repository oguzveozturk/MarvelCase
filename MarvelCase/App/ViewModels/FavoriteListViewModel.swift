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
    
    func fetchChracters(inset:Int, complete: @escaping (_ sucsess: Bool)->() ){
        var limit = inset + 30
        
        if localData.fetch(Character.self).count < limit {
            limit = localData.fetch(Character.self).count
        }
        if inset < limit {
            var newData = localData.fetch(Character.self)
            newData.reverse()
            favCharacters += newData[inset..<limit]
            complete(true)
        } else {
            complete(false)
        }
    }
    
    func deleteLocalStorage(_ ID: Int) {
        let index = favCharacters.firstIndex{ Int($0.id) == ID}
        if let index = index {
            favCharacters.remove(at: index)
            print("removed")
        }
        
        localData.fetch(Character.self).forEach {
            if $0.id == Int64(ID) {
                localData.context.delete($0)
            }
        }
        localData.saveContext()
    }
    
    func addByID(character: CharacterResults) {
        let newCharacter = Character(context: localData.context)
        newCharacter.name = character.name
        newCharacter.desc = character.description
        newCharacter.imageURL = character.thumbnail?.path
        newCharacter.imageExt = character.thumbnail?.extension
        guard let int = character.id else { return }
        newCharacter.id = Int64(int)
        localData.saveContext()
        
        favCharacters.insert(newCharacter, at: 0)
        print("added")
    }
}

