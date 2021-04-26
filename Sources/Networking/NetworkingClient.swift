import Foundation
import Combine

public class NetworkingClient: NSObject {

    /**
        Instead of using the same keypath for every call eg: "collection",
        this enables to use a default keypath for parsing collections.
        This is overidden by the per-request keypath if present.
     
     */
    
    let baseURL: String
    let requestEncoder: JSONEncoder
    let responseDecoder: JSONDecoder
    
    lazy var session: URLSession = {
        customSession ?? URLSession.shared
    }()
    
    public var defaultCollectionParsingKeyPath: String?
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.urlEncoded

    private let customSession: URLSession?
    
    /**
        Prints network calls to the console.
        Values Available are .None, Calls and CallsAndResponses.
        Default is None
    */
    public var logLevels: NetworkingLogLevel {
        get { return logger.logLevels }
        set { logger.logLevels = newValue }
    }

    private let logger = NetworkingLogger()

    public init(baseURL: String, requestEncoder: JSONEncoder = .init(), responseDecoder: JSONDecoder = .init(), session: URLSession? = nil) {
        self.baseURL = baseURL
        self.customSession = session
        self.requestEncoder = requestEncoder
        self.responseDecoder = responseDecoder
    }
}

