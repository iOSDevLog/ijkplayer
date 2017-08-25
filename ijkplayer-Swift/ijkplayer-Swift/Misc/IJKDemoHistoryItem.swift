//
//  IJKDemoHistoryItem.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import Foundation

class IJKDemoHistoryItem: NSObject, NSCoding {
    var title: String = ""
    var url: URL?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(title, forKey: "title")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        url = aDecoder.decodeObject(forKey: "url") as? URL ?? URL(string: "")
    }
    
    override init() {
        super.init()
    }
}

class IJKDemoHistory: NSObject {
    var list: [IJKDemoHistoryItem]! = [IJKDemoHistoryItem]()
    
    class func instance() -> IJKDemoHistory {
        var s_obj: IJKDemoHistory? = nil
        var onceToken: Int = 0
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            s_obj = IJKDemoHistory()
        }
        onceToken = 1
        return s_obj!
    }
    
    func remove(at index: Int) {
        list.remove(at: index)
        NSKeyedArchiver.archiveRootObject(list, toFile: dbfilePath())
    }
    
    func add(_ item: IJKDemoHistoryItem) {
        var findIdx: Int = NSNotFound
        (list as NSArray).enumerateObjects({
            (enumItem, idx, stop) -> Void in
            let enumItem = enumItem as! IJKDemoHistoryItem
            if (enumItem).url == (item.url) {
                findIdx = idx
                stop.pointee = true
            }
        })
        if NSNotFound != findIdx {
            list.remove(at: findIdx)
        }
        list.insert(item, at: 0)
        NSKeyedArchiver.archiveRootObject(list, toFile: dbfilePath())
    }
    
    override init() {
        super.init()
        
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: dbfilePath()) {
            list = data as! [IJKDemoHistoryItem]
        } else {
            list = [IJKDemoHistoryItem]()
        }
        
    }
    
    func dbfilePath() -> String {
        var libraryPath: String? = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .allDomainsMask, true).first
        libraryPath = URL(fileURLWithPath: libraryPath!).appendingPathComponent("ijkhistory.plist").absoluteString
        return libraryPath!
    }
}
