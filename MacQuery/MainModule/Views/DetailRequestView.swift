//
//  DetailRequestView.swift
//  MacQuery
//
//  Created by Артем Соловьев on 26.01.2024.
//

import SwiftUI
import SplitView
import AppKit

struct DetailRequestView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    @State private var lowerPanelHeight: CGFloat = 200.0
    @State private var selectedRequestTypeMethod: RequestTypeMethod = .GET
    @State private var requestTextFieldUrl: String = "https://bugz.su:8443/core/api/dictionaries/enums"
    @State private var isShowLoader: Bool = false
    
    private var requestTypeMethod: [RequestTypeMethod] = [
        .GET,
        .POST,
        .PUT,
        .DELETE
    ]
    
    var body: some View {
        VStack {
            VSplit {
                VStack {
                    HStack {
                        Text(viewModel.selectedRequest?.description ?? "")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            Picker("", selection: $selectedRequestTypeMethod) {
                                ForEach(requestTypeMethod, id: \.self) { method in
                                    Text(method.getName())
                                }
                            }
                            .pickerStyle(.radioGroup)
                            
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                TextField("Request url", text: $requestTextFieldUrl)
                                    .padding(10)
                                    .textFieldStyle(.plain)
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            Spacer()
                        }
                    }
                    .frame(height: 80)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 25)
            } bottom: {
                JsonTextView(attributedString: highlightJsonSyntax(jsonString: viewModel.consoleText))
                    .frame(maxWidth: .infinity)
            }
            .constraints(minPFraction: 0.2, minSFraction: 0.2, dragToHideS: true)
        }
        .onChange(of: viewModel.selectedRequest, { oldValue, newValue in
            selectedRequestTypeMethod = viewModel.selectedRequest?.requestTypeMethod ?? .GET
            requestTextFieldUrl = viewModel.selectedRequest?.requestUrl ?? ""
        })
        .toolbar {
            ToolbarItem {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        switch selectedRequestTypeMethod {
                        case .GET:
                            Task(priority: .medium) {
                                await viewModel.sendRequest(withUrl: requestTextFieldUrl, typeOfMethod: .get)
                            }
                        case .POST:
                            Task(priority: .medium) {
                                await viewModel.sendRequest(withUrl: requestTextFieldUrl, typeOfMethod: .post)
                            }
                        case .PUT:
                            Task(priority: .medium) {
                                await viewModel.sendRequest(withUrl: requestTextFieldUrl, typeOfMethod: .put)
                            }
                        case .DELETE:
                            Task(priority: .medium) {
                                await viewModel.sendRequest(withUrl: requestTextFieldUrl, typeOfMethod: .delete)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "play")
                        .padding(10)
                }
            }
        }
        .overlay {
            if isShowLoader {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        ActivityIndicator()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.pink)
                        
                        Text("Sending your request...")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
        .onChange(of: viewModel.isHowLoader) { oldValue, newValue in
            isShowLoader = viewModel.isHowLoader
        }
    }
}

#Preview {
    DetailRequestView()
        .environmentObject(MainViewModel())
}
