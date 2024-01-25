//
//  TreeItemView.swift
//  MacQuery
//
//  Created by Артем Соловьев on 25.01.2024.
//

import SwiftUI
import Combine

struct TreeItemView: View {
    
    @EnvironmentObject private var viewModel: MainViewModel
    
    @State var cancellables: Set<AnyCancellable> = []
    
    @State var item: TreeFolderItem
    @State private var hoverColor = Color.clear
    @State private var changeNameText = "Test"
    @State private var hoverColorForInsideObject = Color.clear
    @State private var selectedColor = Color.orange.opacity(0.4)
    @State private var isShowRequestDescription: Bool = false
    @State private var isNameChange: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if item.isRequest {
            VStack(spacing: 2) {
                HStack {
                    switch item.requestTypeMethod {
                    case .GET:
                        Text(item.requestTypeMethod.getName())
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .padding(3)
                            .background(Color.teal.opacity(0.4))
                            .cornerRadius(4)
                    case .POST:
                        Text(item.requestTypeMethod.getName())
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .padding(3)
                            .background(Color.orange.opacity(0.4))
                            .cornerRadius(4)
                    case .PUT:
                        Text(item.requestTypeMethod.getName())
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .padding(3)
                            .background(Color.indigo.opacity(0.4))
                            .cornerRadius(4)
                    case .DELETE:
                        Text(item.requestTypeMethod.getName())
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .padding(3)
                            .background(Color.red.opacity(0.4))
                            .cornerRadius(4)
                    }
                    
                    if isNameChange {
                        TextField("Text Field change name", text: $changeNameText)
                            .focused($isFocused)
                            .onSubmit {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    item.chnageName(newName: changeNameText)
                                    isNameChange = false
                                    isFocused = false
                                    viewModel.selectedRequest = item
                                }
                            }
                    } else {
                        Text(item.title)
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .onTapGesture(count: 2) {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isNameChange = true
                                    isFocused = true
                                    viewModel.selectedRequest = item
                                }
                            }
                    }
                    
                    Spacer()
                }
                
                if isShowRequestDescription || item == viewModel.selectedRequest {
                    HStack {
                        Text(item.description)
                            .font(.system(size: 10, weight: .light, design: .rounded))
                            .foregroundStyle(Color.secondary)
                        
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("  ")
                            .font(.system(size: 10, weight: .light, design: .rounded))
                            .foregroundStyle(Color.secondary)
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
            .padding(.horizontal, 5)
            .background(item == viewModel.selectedRequest ? selectedColor : hoverColor)
            .cornerRadius(8)
            .onHover { bool in
                withAnimation(.easeIn(duration: 0.1)) {
                    hoverColor = bool ? Color.pink.opacity(0.2) : Color.clear
                    isShowRequestDescription = bool
                }
            }
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)) {
                    viewModel.selectedRequest = item
                }
            }
            .onAppear {
                changeNameText = item.title
            }
        } else {
            DisclosureGroup(
                isExpanded: $item.isExpanded,
                content: {
                    if !(item.folders?.isEmpty ?? false) {
                        ForEach(item.folders ?? []) { folders in
                            TreeItemView(item: folders)
                        }
                    }
                    
                    if !(item.requests?.isEmpty ?? false) {
                        ForEach(item.requests ?? []) { requests in
                            TreeItemView(item: requests)
                        }
                    }
                },
                label: {
                    HStack {
                        HStack {
                            Image(systemName: item.icon)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                            
                            if isNameChange {
                                TextField("Text Field change name", text: $changeNameText)
                                    .focused($isFocused)
                                    .onSubmit {
                                        withAnimation(.easeOut(duration: 0.1)) {
                                            item.chnageName(newName: changeNameText)
                                            isNameChange = false
                                            isFocused = false
                                        }
                                    }
                            } else {
                                Text(item.title)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .onTapGesture(count: 2) {
                                        withAnimation(.easeOut(duration: 0.1)) {
                                            isNameChange = true
                                            isFocused = true
                                        }
                                    }
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Image(systemName: "plus.viewfinder")
                            .padding(5)
                            .background(hoverColorForInsideObject)
                            .cornerRadius(8)
                            .onHover { bool in
                                withAnimation(.easeIn(duration: 0.1)) {
                                    hoverColorForInsideObject = bool ? Color.secondary.opacity(0.2) : Color.clear
                                }
                            }
                            .onTapGesture {
                                if item.isWorkspace {
                                    withAnimation {
                                        item.createNewFolder()
                                    }
                                } else if item.isFolder {
                                    withAnimation(.smooth(duration: 0.2))  {
                                        viewModel.isShowAddNewRequest = true
                                        viewModel.selectedFolderForCretingNewRequestFromPopUp = item
                                    }
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
                    .background(hoverColor)
                    .cornerRadius(8)
                    .onHover { bool in
                        withAnimation(.easeIn(duration: 0.1)) {
                            hoverColor = bool ? Color.pink.opacity(0.2) : Color.clear
                        }
                    }
                }
            )
            .onTapGesture {
                if !item.isRequest {
                    withAnimation {
                        item.isExpanded.toggle()
                    }
                }
            }
            .onAppear {
                changeNameText = item.title
                viewModel.$isCreateNewRequest.sink { bool in
                    if bool {
                        if item == viewModel.selectedFolderForCretingNewRequestFromPopUp {
                            if item.isFolder {
                                item.createNewRequest(withName: viewModel.newRequestName, andDescription: viewModel.newRequestDescription, methodType: viewModel.newRequestTypeMethod)
                            }
                        }
                    }
                }
                .store(in: &cancellables)
            }
        }
    }
}

#Preview {
    TreeItemView(item: TreeFolderItem(title: "Test workspace", folders: [TreeFolderItem(title: "AHAHHAHA", icon: "folder.fill", requests: [TreeFolderItem(title: "192.168.1.22", description: "Получение игроков", icon: "shift.fill", isRequest: true)], isWorkspace: false, isFolder: true)]))
}
