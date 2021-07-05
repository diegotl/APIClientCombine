//
//  File.swift
//  
//
//  Created by Diego Trevisan Lara on 28.03.21.
//

import Foundation

public struct HTTPRequest {
    private var urlComponents = URLComponents()
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = EmptyBody()

    public init() {
        urlComponents.scheme = "https"
    }
}

public extension HTTPRequest {

    var scheme: String {
        urlComponents.scheme ?? "https"
    }

    var url: URL? {
        return urlComponents.url
    }

    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }

    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }

}
