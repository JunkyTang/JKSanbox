//
//  PathType.swift
//  JKSanbox
//
//  Created by Junky on 2022/9/22.
//

import Foundation


protocol FileType {
    var path: String { get }
}


/// 计算属性
extension FileType {
    
    var attribute: [FileAttributeKey: Any] {
        guard let value = try? FileManager.default.attributesOfItem(atPath: self.path) else { return [:] }
        return value
    }
    
    var subList: [FileType] {
        
        if let list = try? FileManager.default.contentsOfDirectory(atPath: self.path) {
            
            let value = list.map { ele in
                return self.path + "/" + ele
            }
            return value
        }
        return []
    }
    
    var name: String {
        return FileManager.default.displayName(atPath: path)
    }
    
    
    var isHide: Bool {
        guard let value = attribute[.extensionHidden] as? Bool else { return false }
        return value
    }
    
    var fileSize: Float {
        guard let value = attribute[.size] as? Float else { return 0 }
        return value
    }
    
    var createDate: String {
        guard let value = attribute[.creationDate] as? String else { return "未知" }
        return value
    }
    
    var modificationDate: String {
        guard let value = attribute[.modificationDate] as? String else { return "未知" }
        return value
    }
    
    var isDirectory: Bool {
        
        var value: ObjCBool = ObjCBool(false)
        let unsafeBool: UnsafeMutablePointer<ObjCBool> = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        unsafeBool.initialize(from: &value, count: 1)
        FileManager.default.fileExists(atPath: path, isDirectory: unsafeBool)
        return unsafeBool.pointee.boolValue
    }
    
    
}

/// 编辑
extension FileType {
    
    func createFile(_ name: String) -> Bool {
        let subPath = self.path + "/" + name
        return FileManager.default.createFile(atPath: subPath, contents: nil)
    }
    
    func createFolder(_ name: String) -> Bool {
        
        let subPath = self.path + "/" + name
        do {
            try FileManager.default.createDirectory(atPath: subPath, withIntermediateDirectories: true)
            return true
        } catch {
            return false
        }
    }
    
    func remove() -> Bool {
        
        do {
            try FileManager.default.removeItem(atPath: self.path)
            return true
        } catch {
            return false
        }
    }
    
}



extension String: FileType {
    
    public var path: String {
        return self
    }
    
}



