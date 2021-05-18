import Foundation
import Combine

protocol IExampleFetcher {
    func fetchExamples() -> AnyPublisher<[ExampleModel], ApiError>
}
class ExampleFetcher {
    private let fetcher: IApiFetcher
    private let decoder: JSONDecoder

    init(fetcher: IApiFetcher) {
        self.fetcher = fetcher
        decoder = .init()
    }

    func fetchExamples() throws -> AnyPublisher<[ExampleModel], ApiError> {
        let timeStamp = NSDate().timeIntervalSince1970

            return fetcher.request(
                    type: ApiRequestType.get,
                    url: ExampleApiUrlBuilder.getHeroesUrl(),
                    headers: [:],
                    queryParams: [
                        "apikey": ExampleApiKeys.publicKey,
                        "ts": "\(timeStamp)",
                        "hash": "\(timeStamp)\(ExampleApiKeys.privateKey)\(ExampleApiKeys.publicKey)"
                                .md5()
                    ]
            )
                    .decode(type: ExampleApiResponse.self, decoder: decoder)
                    .map { $0.data.results }
                    .mapError { error in
                        if let error = error as? ApiError {
                            return error
                        } else {
                            // handle parse error
                            return ApiError(
                                    sender: self,
                                    url: "",
                                    responseCode: 0,
                                    message: "Couldn't parse ExampleApiResponse from json",
                                    headers: [:],
                                    params: [:]
                            )
                        }
                    }
                    .eraseToAnyPublisher()
    }
}
