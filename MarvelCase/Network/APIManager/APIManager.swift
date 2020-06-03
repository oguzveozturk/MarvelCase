//
//  APIManager.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation

final class APIManager: NSObject {
    static let shared = APIManager()
    
    func errorHandling(errorCode: Int? = 0, errorDescription: String? = NSLocalizedString("DefaultErrorDescription", comment: "")) {
        if errorCode == 403 {
            
        }
        else if errorCode == 401 {
            
        }
        else {
            
        }
    }
    
    func requestForCharacterList(offset:String, complete: @escaping (_ chracterList: CharacterListResponseModel?,_ empty: ResponseEmpty?)->() ){
        
        let reqM = CharacterRequestModel()
        let req = CharacterListRequest()
        
        req.endpoint = req.endpoint + (offset)
        
        req.send(httpMethod: "GET", reqM: reqM) { (model, errorTuple, empty) in
            do {
                if let response = model {
                    let data = try JSONDecoder().decode(CharacterListResponseModel.self, from: response.data)
                    complete(data,nil)
                }
                else if errorTuple != nil {
                    let error = errorTuple?.0
                    
                    guard error == nil else {
                        let errResponse = errorTuple?.1
                        if let data = errResponse?.data(using: String.Encoding.utf8) {
                            let errorResult = try JSONDecoder().decode(CharacterListResponseError.self, from: data)
                            self.errorHandling(errorCode: errorResult.errorCode, errorDescription: errorResult.errorDescription)
                        }
                        return
                    }
                    self.errorHandling()
                }
                else if let empty = empty {
                    let data = try JSONDecoder().decode(ResponseEmpty.self, from: empty.data)
                    //       _ = sender?.perform(selector, with: data)
                    complete(nil,data)
                }
                else {
                    self.errorHandling()
                }
            }
            catch {
                self.errorHandling()
            }
        }
    }
    
    func requestForComicList(characterID:String, complete: @escaping (_ chracterList: ComicListResponseModel?,_ empty: ResponseEmpty?)->() ){
        
        let reqM = ComicRequestModel()
        let req = ComicListRequest()
        
        req.endpoint = req.endpoint + "\(characterID)/comics?&limit=10&offset=0"
        
        req.send(httpMethod: "GET", reqM: reqM) { (model, errorTuple, empty) in
            do {
                if let response = model {
                    let data = try JSONDecoder().decode(ComicListResponseModel.self, from: response.data)
                    complete(data,nil)
                    
                }
                else if errorTuple != nil {
                    let error = errorTuple?.0
                    
                    guard error == nil else {
                        let errResponse = errorTuple?.1
                        if let data = errResponse?.data(using: String.Encoding.utf8) {
                            let errorResult = try JSONDecoder().decode(ComicListResponseError.self, from: data)
                            self.errorHandling(errorCode: errorResult.errorCode, errorDescription: errorResult.errorDescription)
                        }
                        return
                    }
                    self.errorHandling()
                }
                else if let empty = empty {
                    let data = try JSONDecoder().decode(ResponseEmpty.self, from: empty.data)
                    complete(nil,data)
                    
                }
                else {
                    self.errorHandling()
                }
            }
            catch {
                self.errorHandling()
            }
        }
    }
}
