//
//  File.swift
//  
//
//  Created by Ephraim Russo on 4/25/21.
//

import Foundation
import Combine

public final class NetworkingSessionDelegate: NSObject {
    
    typealias ProgressPublisher = PassthroughSubject<Progress, Error>
    
    private let queue = DispatchQueue(label: "com.networking.progress.publisher.map", qos: .utility, attributes: .concurrent)
    
    private var progressPublisherMap = [Int : ProgressPublisher]()
    
    func publisher(for taskIdentifier: Int) -> ProgressPublisher? {
        
        var publisher: ProgressPublisher?
        queue.sync {
            publisher = self.progressPublisherMap[taskIdentifier]
        }
        return publisher
    }
    
    func set(publisher: ProgressPublisher, for taskIdentifier: Int) {
        
        queue.async(flags: .barrier) {
            self.progressPublisherMap[taskIdentifier] = publisher
        }
    }
}

extension NetworkingSessionDelegate: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didSendBodyData bytesSent: Int64,
                           totalBytesSent: Int64,
                           totalBytesExpectedToSend: Int64) {
        let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
        progress.completedUnitCount = totalBytesSent
        publisher(for: task.taskIdentifier)?.send(progress)
    }
}
