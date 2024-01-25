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
            Text(viewModel.selectedRequest?.title ?? "")
        }
        .environmentObject(viewModel)
        .disabled(viewModel.isShowAddNewRequest)
        .overlay {
            if viewModel.isShowAddNewRequest {
                CreateNewRequestPopUpView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
