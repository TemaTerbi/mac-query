//
//  ContentView.swift
//  MacQuery
//
//  Created by Артем Соловьев on 24.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(viewModel)
        } detail: {
           
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
