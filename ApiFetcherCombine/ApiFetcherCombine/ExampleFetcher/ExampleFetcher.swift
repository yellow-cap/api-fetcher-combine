import Foundation
import Combine

class ExampleFetcher {
    private let fetcher: IApiFetcher
    private let decoder: JSONDecoder
    private var dataTaskPublishers = Set<AnyCancellable>()

    init(fetcher: IApiFetcher) {
        self.fetcher = fetcher
        decoder = .init()
    }

    func fetchExample() throws -> AnyPublisher<ExampleApiResponse, ApiError> {
        let timeStamp = NSDate().timeIntervalSince1970

            return try fetcher.request(
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
                    .mapError { error in
                        ApiError(
                                sender: self,
                                url: "",
                                responseCode: 0,
                                message: "Couldn't parse ExampleApiResponse from json",
                                headers: [:],
                                params: [:]
                        )
                    }
                    .eraseToAnyPublisher()
    }
}
