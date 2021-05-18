import Foundation

class ExampleFetcher {
    private let fetcher: IApiFetcher
    private let decoder: JSONDecoder

    init(fetcher: IApiFetcher) {
        self.fetcher = fetcher
        decoder = .init()
    }

    func fetchExample() {
        let timeStamp = NSDate().timeIntervalSince1970

        let result = fetcher.request(
                type: ApiRequestType.get,
                url: ExapmleApiUrlBuilder.getHeroesUrl(),
                headers: [:],
                queryParams: [
                    "apikey": ExampleApiKeys.publicKey,
                    "ts": "\(timeStamp)",
                    "hash": "\(timeStamp)\(ExampleApiKeys.privateKey)\(ExampleApiKeys.publicKey)"
                            .md5(),
                    "offset": "\(0)",
                    "limit": "\(20)"
                ]
        )
    }
}
