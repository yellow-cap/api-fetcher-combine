//
//  ContentView.swift
//  ApiFetcherCombine
//
//  Created by Artem on 18.05.2021.
//

import SwiftUI

struct ContentView: View {
    let fetcher = ExampleFetcher(fetcher: ApiFetcher())

    var body: some View {
        Text("Hello, world!")
            .padding()
                .onAppear {
                    fetcher.fetchExample()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
