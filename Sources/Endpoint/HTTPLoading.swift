//
//  File.swift
//  
//
//  Created by Diego Trevisan Lara on 28.03.21.
//

import Foundation

public protocol HTTPLoading {
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
}

extension URLSession: HTTPLoading {

    public func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        guard let url = request.url else {
            #warning("Improve")
            completion(.failure(HTTPError(code: .unknown, request: request, response: nil, underlyingError: nil)))
            return
        }

        // construct the URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.value

        // copy over any custom HTTP headers
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }

        if request.body.isEmpty == false {
            // if our body defines additional headers, add them
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }

            // attempt to retrieve the body data
            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                // something went wrong creating the body; stop and report back
                #warning("Improve")
                completion(.failure(HTTPError(code: .unknown, request: request, response: nil, underlyingError: nil)))
                return
            }
        }

        let task = dataTask(with: urlRequest) { (data, response, error) in
            // construct a Result<HTTPResponse, HTTPError> out of the triplet of data, url response, and url error
            let result = HTTPResult(request: request, responseData: data, response: response, error: error)
            completion(result)
        }

        // off we go!
        task.resume()
    }

}
