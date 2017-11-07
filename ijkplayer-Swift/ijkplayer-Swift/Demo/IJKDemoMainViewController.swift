//
//  IJKDemoMainViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/25.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import MobileCoreServices

class IJKDemoMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var tableView: UITableView!
    var tableViewCellTitles = [String]()
    var historyList = [IJKDemoHistoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableViewCellTitles = ["Local Folder", "Movie Picker", "Input URL", "Scan QRCode", "Online Samples"]
        let documentsUrl: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        try? NSURL(string: (documentsUrl?.absoluteString)!)?.setResourceValue(Int(truncating: true), forKey: .isExcludedFromBackupKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyList = IJKDemoHistory.instance().list
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Open from"
        case 1:
            return "History"
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tableViewCellTitles.count
        case 1:
            return historyList.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "IJKDemoMainCell")
        
        cell?.textLabel?.lineBreakMode = .byTruncatingMiddle
        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = tableViewCellTitles[indexPath.row]
        case 1:
            cell?.textLabel?.text = historyList[indexPath.row].title
        default:
            break
        }
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let documentsPath: String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "IJKDemoLocalFolderViewController") as! IJKDemoLocalFolderViewController
                viewController.folderPath = documentsPath!
                navigationController?.pushViewController(viewController, animated: true)
            case 1:
                _ = startMediaBrowser(from: self, usingDelegate: self)
            case 2:
                self.performSegue(withIdentifier: "IJKDemoInputURLViewControllerSegue", sender: nil)
                break
            case 3:
                self.performSegue(withIdentifier: "IJKQRCodeScanViewControllerSegue", sender: nil)
                break
            case 4:
                self.performSegue(withIdentifier: "IJKDemoSampleViewControllerSegue", sender: nil)
                break
            default:
                break
            }
        case 1:
            let historyItem: IJKDemoHistoryItem? = historyList[indexPath.row]
            
            IJKPlayerViewController.present(from: self, withTitle: (historyItem?.title)!, url: (historyItem?.url)!, completion: {() -> Void in
                self.navigationController?.popViewController(animated: false)
            })
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 1)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && editingStyle == .delete {
            IJKDemoHistory.instance().remove(at: indexPath.row)
            historyList = IJKDemoHistory.instance().list
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let _: String = info[UIImagePickerControllerMediaType] as? String ?? ""
        let movieUrl: URL? = info[UIImagePickerControllerMediaURL] as? URL
        dismiss(animated: true, completion: {(_: Void) -> Void in
            let storyBoard = UIStoryboard(name: "ijkplayer", bundle: nil)
            let viewController = storyBoard.instantiateInitialViewController() as! IJKPlayerViewController
            viewController.url = movieUrl

            self.present(viewController, animated: true, completion: {
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: misc
    
    func startMediaBrowser(from controller: UIViewController, usingDelegate delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> Bool {
        if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false) {
            return false
        }
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        // Displays saved pictures and movies, if both are available, from the
        // Camera Roll album.
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = false
        mediaUI.delegate = delegate
        controller.present(mediaUI, animated: true)
        return true
    }
}
