//
//  IJKDemoLocalFolderViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class IJKDemoLocalFolderViewController: UITableViewController {
    var folderPath: String = ""
    private var subpaths = [String]()
    private var files: [String]? = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.folderPath = (folderPath as NSString).standardizingPath
        title = (folderPath as NSString).lastPathComponent
        subpaths = [String]()

        var isDirectory: ObjCBool = false
        files = try? FileManager.default.contentsOfDirectory(atPath: folderPath)
        subpaths.append("..")
        guard files != nil else {
            return
        }
        for fileName: String in files! {
            let fullFileName: String = URL(fileURLWithPath: folderPath).appendingPathComponent(fileName).absoluteString
            FileManager.default.fileExists(atPath: fullFileName, isDirectory: &isDirectory)
            if isDirectory.boolValue {
                subpaths.append(fileName)
            }
            else {
                self.files?.append(fileName)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return subpaths.count
        case 1:
            return files?.count ?? 0
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "IJKDemoLocalFolderCell")
        cell?.textLabel?.lineBreakMode = .byTruncatingMiddle
        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = "[\(subpaths[indexPath.row])]"
            cell?.accessoryType = .disclosureIndicator
        case 1:
            cell?.textLabel?.text = files?[indexPath.row]
            cell?.accessoryType = .none
        default:
            break
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let fileName: String = URL(fileURLWithPath: folderPath).appendingPathComponent(subpaths[indexPath.row]).absoluteString
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "IJKDemoLocalFolderViewController") as! IJKDemoLocalFolderViewController
            viewController.folderPath = fileName
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            var fileName: String = URL(fileURLWithPath: folderPath).appendingPathComponent(files![indexPath.row]).absoluteString
            fileName = (fileName as NSString).standardizingPath
            IJKPlayerViewController.present(from: self, withTitle: "File: \(fileName)", url: URL(fileURLWithPath: fileName), completion: {() -> Void in
            })
        default:
            break
        }
        
    }
}
