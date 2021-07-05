//
//  File.swift
//  
//
//  Created by Diego Trevisan Lara on 28.03.21.
//

public struct HTTPMethod: Hashable {
    public static let get = HTTPMethod(value: "GET")
    public static let post = HTTPMethod(value: "POST")
    public static let put = HTTPMethod(value: "PUT")
    public static let delete = HTTPMethod(value: "DELETE")

    public let value: String
}
