//
//  TreeFolderItem.swift
//  MacQuery
//
//  Created by Артем Соловьев on 24.01.2024.
//

import Foundation

/// Main class item. Using recursive
struct TreeFolderItem: Identifiable, Hashable {
    let id = UUID()
    
    //MARK: - Base shared class field
    var title: String
    let createdAt: Date
    let icon: String
    let description: String
    
    //MARK: - Request fields
    let requestUrl: String
    
    //MARK: - Flag field
    let isWorkspace: Bool
    let isFolder: Bool
    let isRequest: Bool
    
    //MARK: - State item field
    var isExpanded: Bool = false
    var isSelected: Bool = false
    
    //MARK: - Type of method (GET,POST,PUT,DELETE)
    let requestTypeMethod: RequestTypeMethod
    
    //MARK: - Children of item (Folder/Requests)
    var folders: [TreeFolderItem]?
    var requests: [TreeFolderItem]?
    
    //MARK: - Default init
    init(title: String, description: String = "", createdAt: Date = Date.now, icon: String = "airplayaudio", folders: [TreeFolderItem] = [], requests: [TreeFolderItem] = [], isWorkspace: Bool = true, isFolder: Bool = false, isRequest: Bool = false, requestTypeMethod: RequestTypeMethod = .GET, requestUrl: String = "") {
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.icon = icon
        self.folders = folders
        self.requests = requests
        self.isWorkspace = isWorkspace
        self.isFolder = isFolder
        self.isRequest = isRequest
        self.requestTypeMethod = requestTypeMethod
        self.requestUrl = requestUrl
    }
    
    //MARK: - Helper actions
    static func createDummyData() -> [TreeFolderItem] {
        return [
            TreeFolderItem(title: "Test workspace", folders: [TreeFolderItem(title: "AHAHHAHA", icon: "folder.fill", requests: [TreeFolderItem(title: "192.168.1.22", description: "Получение игроков", icon: "shift.fill", isRequest: true), TreeFolderItem(title: "New Request", description: "Получение data", icon: "shift.fill", isRequest: true)], isWorkspace: false, isFolder: true)]),
        ]
    }
    
    static func createNewFolder() -> TreeFolderItem {
        TreeFolderItem(title: "New Workspace")
    }
    
    mutating func createNewFolder() {
        self.folders?.append(TreeFolderItem(title: "New Folder", icon: "folder.fill", requests: [], isWorkspace: false, isFolder: true))
    }
    
    mutating func createNewRequest() {
        self.requests?.append(TreeFolderItem(title: "New Request", icon: "shift.fill", isRequest: true))
    }
    
    mutating func createNewRequest(withName name: String, description description: String = "", methodType type: RequestTypeMethod, andUrl url: String) {
        self.requests?.append(TreeFolderItem(title: name, description: description, icon: "shift.fill", isRequest: true, requestTypeMethod: type, requestUrl: url))
    }
    
    mutating func chnageName(newName name: String) {
        self.title = name
    }
}
