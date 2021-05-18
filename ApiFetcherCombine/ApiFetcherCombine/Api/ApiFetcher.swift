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
    ) -> Future<Data, Error>
}

class ApiFetcher: IApiFetcher {
    private let session: URLSession = URLSession.shared

    func request(
            type: ApiRequestType,
            url: String,
            headers: [String: String],
            queryParams: [String: String]) -> Future<Data, Error> {

            return Future<Data, Error> { [weak self] promise in
                guard let self = self,
                      let url = self.buildRequestUrl(url: url, queryParams: queryParams) else {

                    promise(.failure(ApiError(
                            sender: self,
                            url: url,
                            responseCode: 0,
                            headers: headers,
                            params: queryParams))
                    )

                    return
                }

                let request = self.buildRequest(url: url, type: type, headers: headers)

                let _ = self.session.dataTaskPublisher(for: request)
                        .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        print("<<<DEV>>> Api fetcher: receiveCompletion error \(error)")
                                        promise(.failure(error))
                                    }
                                },
                                receiveValue: { value in
                                    print("<<<DEV>>> Api fetcher: receiveValue value data \(value.data)")
                                    print("<<<DEV>>> Api fetcher: receiveValue value response \(value.response)")

                                    promise(.success(value.data))
                                }
                        )
            }
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

