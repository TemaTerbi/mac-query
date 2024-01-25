//
//  TreeFolderItem.swift
//  MacQuery
//
//  Created by Артем Соловьев on 24.01.2024.
//

import Foundation

struct TreeFolderItem: Identifiable, Hashable {
    let id = UUID()
    
    var title: String
    let createdAt: Date
    let icon: String
    let description: String
    let isWorkspace: Bool
    let isFolder: Bool
    let isRequest: Bool
    var isExpanded: Bool = false
    var isSelected: Bool = false
    var folders: [TreeFolderItem]?
    var requests: [TreeFolderItem]?
    
    init(title: String, description: String = "", createdAt: Date = Date.now, icon: String = "airplayaudio", folders: [TreeFolderItem] = [], requests: [TreeFolderItem] = [], isWorkspace: Bool = true, isFolder: Bool = false, isRequest: Bool = false) {
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.icon = icon
        self.folders = folders
        self.requests = requests
        self.isWorkspace = isWorkspace
        self.isFolder = isFolder
        self.isRequest = isRequest
    }
    
    static func createDummyData() -> [TreeFolderItem] {
        return [
            TreeFolderItem(title: "Test workspace", folders: [TreeFolderItem(title: "AHAHHAHA", icon: "folder.fill", requests: [TreeFolderItem(title: "192.168.1.22", description: "Получение игроков", icon: "shift.fill", isRequest: true), TreeFolderItem(title: "New Request", description: "Получение data", icon: "shift.fill", isRequest: true)], isWorkspace: false, isFolder: true)]),
        ]
    }
    
    static func createNewFolder() -> TreeFolderItem {
        TreeFolderItem(title: "New Workspace")
    }
    
    mutating func createNewFolder() {
        self.folders?.append(TreeFolderItem(title: "New Folder", icon: "folder.fill", isWorkspace: false, isFolder: true))
    }
    
    mutating func createNewRequest() {
        self.requests?.append(TreeFolderItem(title: "New Request", icon: "shift.fill", isRequest: true))
    }
    
    mutating func chnageName(newName name: String) {
        self.title = name
    }
}
