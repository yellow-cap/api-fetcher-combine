import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel(
            exampleFetcher: ExampleFetcher(
                    fetcher: ApiFetcher()
            )
    )

    var body: some View {
        VStack {
            if viewModel.examples.isEmpty {
                Text("Loading...")
            } else {
                List {
                    ForEach(viewModel.examples, id:\.self) { example in
                        Text(example.name)
                    }
                }
            }
        }
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
