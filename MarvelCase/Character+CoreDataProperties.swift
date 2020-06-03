//
//  Character+CoreDataProperties.swift
//  MarvelCase
//
//  Created by Oguz on 3.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var imageExt: String?

}
