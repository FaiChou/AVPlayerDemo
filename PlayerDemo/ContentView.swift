//
//  ContentView.swift
//  PlayerDemo
//
//  Created by 周辉 on 2024/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showFileImporter = false
    @State private var urls: [URL] = []
    @State private var url: String = ""
    var body: some View {
        NavigationStack(path: $urls) {
            Form {
#if os(iOS)
                Button("Choose a video") {
                    showFileImporter = true
                }
                .fileImporter(
                    isPresented: $showFileImporter,
                    allowedContentTypes: [.item],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let files):
                        files.forEach { file in
                            // gain access to the directory
                            let gotAccess = file.startAccessingSecurityScopedResource()
                            if !gotAccess { return }
                            urls = [file]
                        }
                    case .failure(let error):
                        // handle error
                        print(error)
                    }
                }
#endif
                TextField("http://", text: $url)
                .onSubmit {
                    let u = URL(string: url)!
                    urls = [u]
                }
                .submitLabel(.go)
            }
            .navigationTitle("PlayerDemo")
            .navigationDestination(for: URL.self) { url in
                Player(url: url)
            }
            .onOpenURL(perform: { url in
                print(url)
                if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                    let params = components.queryItems, let urlString = params.first(where: { $0.name == "url" })?.value {
                    urls = [URL(string: urlString)!]
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
