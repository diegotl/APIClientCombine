//
//  File.swift
//  
//
//  Created by Diego Trevisan Lara on 28.03.21.
//

import Foundation

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

public struct HTTPError: Error {

    public enum Code {
        case invalidRequest     // the HTTPRequest could not be turned into a URLRequest
        case cannotConnect      // some sort of connectivity problem
        case cancelled          // the user cancelled the request
        case insecureConnection // couldn't establish a secure connection to the server
        case invalidResponse    // the system did not receive a valid HTTP response
        case unknown            // we have no idea what the problem is
    }

    /// The high-level classification of this error
    public let code: Code

    /// The HTTPRequest that resulted in this error
    public let request: HTTPRequest

    /// Any HTTPResponse (partial or otherwise) that we might have
    public let response: HTTPResponse?

    /// If we have more information about the error that caused this, stash it here
    public let underlyingError: Error?
}

extension HTTPResult {
    
    public var request: HTTPRequest {
        switch self {
            case .success(let response): return response.request
            case .failure(let error): return error.request
        }
    }
    
    public var response: HTTPResponse? {
        switch self {
            case .success(let response): return response
            case .failure(let error): return error.response
        }
    }

    init(request: HTTPRequest, responseData: Data?, response: URLResponse?, error: Error?) {
        var httpResponse: HTTPResponse?
        if let r = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, response: r, body: responseData ?? Data())
        }

        if let e = error as? URLError {
            let code: HTTPError.Code
            #warning("Improve")
            switch e.code {
                case .badURL: code = .invalidRequest
                // case .unsupportedURL: code = ...
                // case .cannotFindHost: code = ...
                default: code = .unknown
            }
            self = .failure(HTTPError(code: code, request: request, response: httpResponse, underlyingError: e))
        } else if let someError = error {
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: someError))
        } else if let httpResponse = httpResponse {
            self = .success(httpResponse)
        } else {
            self = .failure(HTTPError(code: .invalidResponse, request: request, response: nil, underlyingError: error))
        }
    }

}
