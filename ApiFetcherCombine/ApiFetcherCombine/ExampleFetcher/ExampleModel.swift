struct ExampleApiResponse: Decodable {
    let data: ExampleApiResponseData
}

struct ExampleApiResponseData: Decodable {
    let results: [ExampleModel]
}

struct ExampleModel: Decodable {
    let id: Int
    let name: String
}