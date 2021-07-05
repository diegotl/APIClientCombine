//
//  File.swift
//  
//
//  Created by Diego Trevisan Lara on 28.03.21.
//

import Foundation

public struct HTTPResponse {
    public let request: HTTPRequest
    public let response: HTTPURLResponse
    public let body: Data?

    public var status: HTTPStatus {
        HTTPStatus(value: response.statusCode)
    }

    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var headers: [AnyHashable: Any] {
        response.allHeaderFields
    }
}
