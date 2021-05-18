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
                    do {
                        try fetcher.fetchExample()
                    } catch {
                        print("Error on view: \(error)")
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
