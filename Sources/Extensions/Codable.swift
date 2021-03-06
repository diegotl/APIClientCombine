//
//  Codability.swift
//  APIClient
//
//  Created by Diego Trevisan Lara on 18/01/18.
//  Copyright © 2018 Diego Trevisan Lara. All rights reserved.
//

import Foundation

extension Decodable {
    
    typealias T = Self
    
    static func decode(data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let error {
            throw error
        }
    }
    
}

extension Encodable {
    
    func data() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    func json() throws -> [String: Any] {
        let json = try JSONSerialization.jsonObject(with: data(), options: [])
        return json as! [String: Any]
    }
    
}
