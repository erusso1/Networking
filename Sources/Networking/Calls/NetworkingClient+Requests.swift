//
//  NetworkingClient+Requests.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.get, route, params: params)
    }

    func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.post, route, params: params)
    }

    func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.put, route, params: params)
    }
    
    func patchRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.patch, route, params: params)
    }

    func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.delete, route, params: params)
    }

    internal func request(_ httpVerb: HTTPVerb, _ route: String, params: Params = Params()) -> NetworkingRequest {
        let req = NetworkingRequest()
        req.baseURL = baseURL
        req.logLevels = logLevels
        req.headers = headers
        req.httpVerb = httpVerb
        req.route = route
        req.params = params
        req.parameterEncoding = parameterEncoding
        return req
    }
    
    internal func request<T: Encodable>(_ httpVerb: HTTPVerb, _ route: String, params: T) throws -> NetworkingRequest {
        let req = NetworkingRequest()
        req.baseURL = baseURL
        req.logLevels = logLevels
        req.headers = headers
        req.httpVerb = httpVerb
        req.route = route
        req.params = try encodableToParams(params)
        req.parameterEncoding = parameterEncoding
        return req
    }
    
    private func encodableToParams<T: Encodable>(_ input: T) throws -> Params {
        
        let data = try requestEncoder.encode(input)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Params else {
            throw EncodingError.invalidValue("Encodable", EncodingError.Context(codingPath: [], debugDescription: "Could not cast JSON content to Params", underlyingError: nil))
        }
        return dictionary
    }
}
