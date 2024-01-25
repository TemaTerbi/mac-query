//
//  CreateNewRequestPopUpView.swift
//  MacQuery
//
//  Created by Артем Соловьев on 26.01.2024.
//

import SwiftUI

struct CreateNewRequestPopUpView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    @FocusState private var focusOnNewNameTextField: Bool
    
    @State var isInvalid = false
    @State private var newRequestName = ""
    @State private var newRequestDescription = ""
    @State private var requestTypeMethod: RequestTypeMethod = .GET
    private var requestTypeMethods: [RequestTypeMethod] = [.GET, .POST, .PUT, .DELETE]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.01).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Create new request")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                HStack {
                    if isInvalid {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                    }
                    
                    TextField("Name of new request", text: $newRequestName)
                        .focused($focusOnNewNameTextField)
                }
                
                TextField("Description of new request", text: $newRequestDescription)
                
                Picker("Pick the request method type", selection: $requestTypeMethod) {
                    ForEach(requestTypeMethods, id: \.self) { method in
                        Text(method.getName())
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .onTapGesture {
                                viewModel.newRequestTypeMethod = method
                            }
                    }
                }
                .pickerStyle(.segmented)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Name of request is required field")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(isInvalid ? Color.red : Color.secondary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Description of request is optional field")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.secondary)
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Text("Submit")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.teal)
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.2)) {
                        if newRequestName != "" {
                            viewModel.isShowAddNewRequest = false
                            viewModel.newRequestTypeMethod = requestTypeMethod
                            focusOnNewNameTextField = false
                            viewModel.newRequestName = newRequestName
                            viewModel.newRequestDescription = newRequestDescription
                            viewModel.isCreateNewRequest = true
                        } else {
                            isInvalid = true
                        }
                        
                    }
                }
            }
            .padding(20)
            .frame(width: 400, height: 350)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.pink.opacity(0.2) ,radius: 100)
            .onSubmit {
                withAnimation(.smooth(duration: 0.2)) {
                    if newRequestName != "" {
                        viewModel.isShowAddNewRequest = false
                        viewModel.newRequestTypeMethod = requestTypeMethod
                        focusOnNewNameTextField = false
                        viewModel.newRequestName = newRequestName
                        viewModel.newRequestDescription = newRequestDescription
                        viewModel.isCreateNewRequest = true
                    } else {
                        isInvalid = true
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            newRequestName = ""
            newRequestDescription = ""
            focusOnNewNameTextField = true
        }
        .onTapGesture {
            withAnimation(.smooth(duration: 0.2)) {
                viewModel.isShowAddNewRequest = false
                focusOnNewNameTextField = false
            }
        }
    }
}

#Preview {
    CreateNewRequestPopUpView()
}
