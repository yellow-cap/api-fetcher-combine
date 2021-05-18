import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel(
            exampleFetcher: ExampleFetcher(
                    fetcher: ApiFetcher()
            )
    )

    var body: some View {
        Text(viewModel.examples.isEmpty ? "Loading..." : "Loaded")
                .onAppear {
                    viewModel.fetchExamples()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
