//
//  MyFileFunctions.swift
//  FileSystemDemo
//
//  Created by Jacob Westerback (RIT Student) on 4/5/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
extension FileManager {
    // Taken from my File Manager HW
    
    static var documentsDirectory:URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
    }
    
    static var casheDirectory:URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    }
    
    static var tempDirectory:String {
        return NSTemporaryDirectory()
    }
    
    static func filePathInDocumentsDirectory(fileName:String)->URL{
        return FileManager.documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func fileExistsInDocumentsDirectory(fileName:String)->Bool {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func deleteFileInDocumentsDirectory(fileName:String) {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        do {
            try FileManager.default.removeItem(atPath: path)
            print("FILE: \(path) was deleted")
            
        } catch {
            print("ERROR: \(error) - FOR FILE: \(path)")
        }
    }
    
    static func contentsOfDir(url:URL)->[String]{
        do {
            if let paths = try FileManager.default.contentsOfDirectory(atPath: url.path) as [String]? {
                return paths
            } else {
                print("none found")
                return [String]()
            }
        } catch {
            print("ERROR: \(error)")
            return [String]()
        }
    }
    
    static func clearDocumentsFolder() {
        let fileManager = FileManager.default
        let docsFolderPath = FileManager.documentsDirectory.path
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: docsFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: docsFolderPath+"/"+filePath)
            }
            print("Cleared Documents folder")
        }
        catch {
            print("Could not clear Documents folder: \(error)")
        }
    }
}
