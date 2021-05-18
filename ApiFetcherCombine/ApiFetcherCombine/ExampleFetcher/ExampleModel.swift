struct ExampleApiResponse: Decodable {
    let data: ExampleApiResponseData
}

struct ExampleApiResponseData: Decodable {
    let results: [ExampleModel]
}

struct ExampleModel: Decodable, Hashable {
    let id: Int
    let name: String
}