//
//  IJKDemoSampleViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class IJKDemoSampleViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var sampleList = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "M3U8"
        sampleList.append(["bipbop basic master playlist", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8"])
        sampleList.append(["bipbop basic 400x300 @ 232 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8"])
        sampleList.append(["bipbop basic 640x480 @ 650 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8"])
        sampleList.append(["bipbop basic 640x480 @ 1 Mbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear3/prog_index.m3u8"])
        sampleList.append(["bipbop basic 960x720 @ 2 Mbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear4/prog_index.m3u8"])
        sampleList.append(["bipbop basic 22.050Hz stereo @ 40 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear0/prog_index.m3u8"])
        sampleList.append(["bipbop advanced master playlist", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"])
        sampleList.append(["bipbop advanced 416x234 @ 265 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8"])
        sampleList.append(["bipbop advanced 640x360 @ 580 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear2/prog_index.m3u8"])
        sampleList.append(["bipbop advanced 960x540 @ 910 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear3/prog_index.m3u8"])
        sampleList.append(["bipbop advanced 1280x720 @ 1 Mbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear4/prog_index.m3u8"])
        sampleList.append(["bipbop advanced 1920x1080 @ 2 Mbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8"])
        sampleList.append(["bipbop advanced 22.050Hz stereo @ 40 kbps", "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear0/prog_index.m3u8"])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}
extension IJKDemoSampleViewController: UITableViewDataSource, UITableViewDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Samples"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IJKDemoSampleCell")

        cell?.textLabel?.lineBreakMode = .byTruncatingMiddle
        cell?.textLabel?.text = sampleList[indexPath.row][0]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: [String] = sampleList[indexPath.row]
        let url = URL(string: item[1] )
        let storyBoard = UIStoryboard(name: "ijkplayer", bundle: nil)
        let playerViewController = storyBoard.instantiateInitialViewController() as! IJKPlayerViewController
        playerViewController.url = url
        navigationController?.present(playerViewController, animated: true, completion: {() -> Void in
        })
    }
}
