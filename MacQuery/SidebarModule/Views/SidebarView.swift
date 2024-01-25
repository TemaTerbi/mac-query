//
//  SidebarView.swift
//  MacQuery
//
//  Created by Артем Соловьев on 24.01.2024.
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject private var viewModel: MainViewModel
    
    @State private var workspaces = TreeFolderItem.createDummyData()
    @State var selectedWorkspace: TreeFolderItem? = nil
    
    var body: some View {
        Section {
            List {
                ForEach(workspaces) { workspace in
                    TreeItemView(item: workspace)
                        .environmentObject(viewModel)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationSplitViewColumnWidth(min: 190, ideal: 250)
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation(.bouncy) {
                            workspaces.append(TreeFolderItem.createNewFolder())
                        }
                    } label: {
                        Image(systemName: "plus.square.on.square")
                    }
                    
                }
            }
        } header: {
            HStack {
                Text("Your workspaces:")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.gray)
                
                Spacer()
            }
            .padding(.leading, 15)
        }
    }
}

#Preview {
    SidebarView()
}
