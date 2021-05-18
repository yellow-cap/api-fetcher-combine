# api-fetcher-combine
1. Api layer
  * ApiFetcher
    * builds request with headers, query parameters, request type
    * returns publisher AnyPublisher<Data, ApiError>
    * handles api errors
  * ApiRequestType
    * GET - implemented & tested
    * POST - not implemented
    * DELETE - not implemented
  * ApiError - api error class
  * ExampleFetcher
    * uses ApiFetcher
    * receives AnyPublisher<Data, ApiError> from ApiFetcher
    * parses data from JSON to ExampleApiResponse
    * extracts data results from ExampleApiResponse
    * return AnyPublisher<[ExampleModel], ApiError>
    * forwards api errors from ApiFetcher
    * handles parsing errors
2. Presentation layer
  * ContentViewModel
    * create publisher AnyPublisher<[ExampleModel], ApiError>
    * subscribes on publisher
    * handles publisher value changes
      * value [ExampleModel] - stores in examples variable
      * error ApiError (showing on UI not implemented)
  * ContentView
    * uses ContentViewModel
    * show "Loading..."
    * shows list of ExampleModels     
