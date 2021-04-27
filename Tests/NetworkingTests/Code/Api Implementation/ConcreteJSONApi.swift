//
//  ConcreteApi.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Networking
import Combine

struct ConcreteApi: Api, NetworkingService {

    let network: NetworkingClient = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")

    func fetchPost() -> AnyPublisher<Post, Error> {
        get("/posts/1")
    }

    func fetchPosts() -> AnyPublisher<[Post], Error> {
        get("/posts")
    }
    
    func fetchThings() -> AnyPublisher<Data, Error> {
        
        struct Thing: Encodable {
            let name: String
        }
        
        return get("/users", params: Thing(name: "hello"))
    }
}
