//
//  ComicListViewModel.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation

final class ComicListViewModel: NSObject {
    
    var orderedComicData = [ComicResults]()
    
    private var comicData = [ComicResults]()
    
    func fetchChracters(characterID: String, complete: @escaping (_ sucsess: Bool)->() ){
        APIManager.shared.requestForComicList(characterID: characterID) { (response, _) in
            if let data = response?.data.results {
                self.orderedComicData = self.listOrder(comicData: data)
                complete(true)
            }
        }
    }
    
    private func listOrder(comicData: [ComicResults]) -> [ComicResults] {
        let startingDate = "2005-01-01T00:00:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:startingDate)!

        
        comicData.forEach {
            orderedComicData.append(ComicResults(id: $0.id, title: $0.title, thumbnail: $0.thumbnail, dates: nil, orderedDate: dateFormatter.date(from:$0.dates?[0].date ?? "")!))
        }
        
        let restrictedArray = orderedComicData.filter { ($0.orderedDate ?? Date()) > date }
        
        let orderedArray = restrictedArray.sorted { (lhs: ComicResults, rhs: ComicResults) -> Bool in
            guard let lhs = lhs.orderedDate, let rhs = rhs.orderedDate else { return false }
            return (lhs.compare(rhs)) == .orderedDescending
        }
        return orderedArray
    }
}
