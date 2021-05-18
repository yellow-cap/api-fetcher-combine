import Foundation

protocol IError: Error {
    var message: String { get }
    var callStack: [String] { get }
    var sender: Mirror { get }
    var error: Error? { get }

    func toString() -> String
    func data() -> [String: String]
}

struct ApiError: IError {
    let sender: Mirror
    let message: String
    let callStack: [String]
    let error: Error?
    let url: String
    let responseCode: Int
    let headers: [HeaderKey: HeaderValue]
    let params: [ParamKey: ParamValue]

    init(
            sender: Any,
            url: String,
            responseCode: Int,
            message: String = "",
            error: Error? = nil,
            headers: [HeaderKey: HeaderValue],
            params: [ParamKey: ParamValue]
    ) {
        self.sender = Mirror(reflecting: sender)
        self.url = url
        self.responseCode = responseCode
        self.message = message
        callStack = Thread.callStackSymbols
        self.headers = headers
        self.params = params
        self.error = error
    }

    func toString() -> String {
        data().map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }

    func data() -> [String: String] {
        [
            "sender": "\(sender.subjectType)",
            "url": url,
            "headers": "\(headers)",
            "params": "\(params)",
            "responseCode": "\(responseCode)",
            "message": message,
            "cause": error?.localizedDescription ?? "",
            "callStack": "\n\(callStack.joined(separator: "\n"))"
        ]
    }
}