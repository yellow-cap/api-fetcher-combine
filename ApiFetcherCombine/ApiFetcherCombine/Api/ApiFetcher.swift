import Foundation
import Combine

typealias HeaderKey = String
typealias HeaderValue = String
typealias ParamKey = String
typealias ParamValue = String

protocol IApiFetcher {
    func request(
            type: ApiRequestType,
            url: String,
            headers: [String: String],
            queryParams: [String: String]
    ) -> AnyPublisher<Data, ApiError>
}

class ApiFetcher: IApiFetcher {
    private let session: URLSession = URLSession.shared

    func request(
            type: ApiRequestType,
            url: String,
            headers: [String: String],
            queryParams: [String: String]) -> AnyPublisher<Data, ApiError> {

        guard let url = buildRequestUrl(url: url, queryParams: queryParams) else {
            return Fail(error: ApiError(
                    sender: self,
                    url: url,
                    responseCode: 0,
                    message: "Couldn't build url",
                    headers: headers,
                    params: queryParams
            ))
                    .eraseToAnyPublisher()
        }

        let request = buildRequest(url: url, type: type, headers: headers)

        return session.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else {
                        throw ApiError(
                                sender: self,
                                url: url.absoluteString,
                                responseCode: 0,
                                message: "Response is not HTTPURLResponse",
                                headers: headers,
                                params: queryParams
                        )
                    }

                    if response.statusCode != 200 {
                        throw ApiError(
                                sender: self,
                                url: url.absoluteString,
                                responseCode: response.statusCode,
                                message: "Bad request",
                                headers: headers,
                                params: queryParams
                        )
                    }
                    
                    return data
                }
                .mapError { error in
                    // handle specific errors

                    if let error = error as? ApiError {
                        return error
                    } else {
                        return ApiError(
                                sender: self,
                                url: url.absoluteString,
                                responseCode: 0,
                                message: "Unknown error occurred \(error.localizedDescription)",
                                headers: headers,
                                params: queryParams
                        )
                    }
                }
                .eraseToAnyPublisher()
    }

    private func buildRequestUrl(url: String, queryParams: [ParamKey: ParamValue]) -> URL? {
        guard let encodedPath = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        guard var urlComponents = URLComponents(string: encodedPath) else {
            return nil
        }

        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        urlComponents.queryItems = queryParams.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        return urlComponents.url
    }

    private func buildRequest(url: URL, type: ApiRequestType, headers: [HeaderKey: HeaderValue]) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = type.rawValue

        if !headers.isEmpty {
            headers.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
        }

        return request
    }
}

