class ExampleApiUrlBuilder {
    private static let apiBaseUrl = "https://gateway.marvel.com:443/v1/public"

    public static func getHeroesUrl() -> String {
        "\(apiBaseUrl)/characters"
    }
}