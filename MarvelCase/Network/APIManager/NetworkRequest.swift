//
//  NetworkRequest.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class NetworkRequest<ReqM: Codable, RM: Codable>: Request {
    
    var endpoint: String = ""
    var path: String = ""
    var paramaters: [String: Any] = [:]
    var checkInternet = false
    let ts = "0"
    let privateAPIKEY = "a308d8c47113aadca2923e3df0525c9f32598634"
    let publicAPIKEY = "8feb47f57f41b55f6923b33d67fcc8eb"

    lazy var md5Hex =  MD5(string: ts+privateAPIKEY+publicAPIKEY).map { String(format: "%02hhx", $0) }.joined()
    
    func send(httpMethod: String, reqM: ReqM, completion: @escaping (RM?, (Error?, String?)?, ResponseEmpty?) -> Void) {
        
        if checkInternet {
            guard hasInternet() else { return }
        }
        
        paramaters = reqM.dictionary
        
        createURLString()
        
        if let encoded = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
       //     request.setValue(token, forHTTPHeaderField: "Authorization")
            //
            print(request)
            let session = URLSession(configuration: .default)
            var task: URLSessionDataTask?
            task?.cancel()
            task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, (error, nil), nil)
                }
                if let safeData = data {
                    do {
                        let response = try JSONDecoder().decode(RM.self, from: safeData)
                        completion(response, nil, nil)
                    } catch {
                        print(error)
                        do {
                            let theJSONData = try JSONSerialization.data(withJSONObject: safeData as Any, options: [])
                            let empty = try JSONDecoder().decode(ResponseEmpty.self, from: theJSONData)
                            completion(nil, nil, empty)
                        }
                        catch {
                            print(error)
                            completion(nil, nil, nil)
                        }
                    }
                }
            }
            task?.resume()
        }
    }
    
    func hasInternet() -> Bool {
        //        if !(NetworkReachabilityManager()?.networkReachabilityStatus != .notReachable && NetworkReachabilityManager()?.networkReachabilityStatus != .unknown) {
        //            // NotificationCenter.default.post(name: Notification.Name(Constants().obs_noInternetConnection), object: nil)
        //            return false
        //        }
        return true
    }
    
    func createURLString() {
        let baseUrl = URL(string: "https://gateway.marvel.com/v1/public")!
        path = baseUrl.relativeString + endpoint + "&ts=\(ts)&" + "apikey=\(publicAPIKEY)&" + "hash=\(md5Hex)"
    }
}

func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

protocol Request: class {
    var endpoint: String { get }
    var paramaters: [String: Any] { get }
    var checkInternet: Bool { get }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var data: Data {
        return try! JSONEncoder().encode(self)
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
    }
}

