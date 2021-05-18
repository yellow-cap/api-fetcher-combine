import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var examples: [ExampleModel] = []

    private var cancellableSet = Set<AnyCancellable>()
    private let fetcher: ExampleFetcher

    init(exampleFetcher: ExampleFetcher) {
        fetcher = exampleFetcher
    }

    func fetchExamples() {
        do {
            try fetcher.fetchExamples()
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.main)
                    .sink(
                            receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    print("<<<DEV>>> Publisher completion finished")
                                case .failure(let error):
                                    // handle error on UI
                                    print("<<<DEV>>> Publisher completion failure \(error.toString())")
                                }
                            },
                            receiveValue: { [unowned self] result in
                                print("<<<DEV>>> Publisher receiveValue \(result)")
                                examples = result
                            }
                    )
                    .store(in: &cancellableSet)
        } catch {
            print("Error occurred \(error.localizedDescription)")
        }
    }
}
