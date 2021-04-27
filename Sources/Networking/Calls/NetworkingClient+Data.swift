//
//  NetworkingClient+Data.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.get, route, params: params).publisher(urlSession: self.session)
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.post, route, params: params).publisher(urlSession: self.session)
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.put, route, params: params).publisher(urlSession: self.session)
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.patch, route, params: params).publisher(urlSession: self.session)
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.delete, route, params: params).publisher(urlSession: self.session)
    }
}

public extension NetworkingClient {
    
    func get<T: Encodable>(_ route: String, params: T) -> AnyPublisher<Data, Error> {
        requestPublisher(.get, route: route, params: params)
    }
    
    func post<T: Encodable>(_ route: String, params: T) -> AnyPublisher<Data, Error> {
        requestPublisher(.post, route: route, params: params)
    }
    
    func put<T: Encodable>(_ route: String, params: T) -> AnyPublisher<Data, Error> {
        requestPublisher(.put, route: route, params: params)
    }

    func patch<T: Encodable>(_ route: String, params: T) -> AnyPublisher<Data, Error> {
        requestPublisher(.patch, route: route, params: params)
    }

    func delete<T: Encodable>(_ route: String, params: T) -> AnyPublisher<Data, Error> {
        requestPublisher(.delete, route: route, params: params)
    }
    
    private func requestPublisher<T: Encodable>(_ httpVerb: HTTPVerb, route: String, params: T) -> AnyPublisher<Data, Error> {
        do {
            let request = try request(httpVerb, route, params: params)
            return request.publisher(urlSession: self.session)
        }
        catch {
            return Fail(outputType: Data.self, failure: error).eraseToAnyPublisher()
        }
    }
}
