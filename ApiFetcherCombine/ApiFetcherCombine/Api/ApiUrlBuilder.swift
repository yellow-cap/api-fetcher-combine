class ApiUrlBuilder {
    private static let apiBaseUrl = "https://gateway.marvel.com:443/v1/public"

    public static func getHeroesUrl() -> String {
        "\(apiBaseUrl)/characters"
    }
}