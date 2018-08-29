//
//  IJKDemoInputURLViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class IJKDemoInputURLViewController: UIViewController, UITextViewDelegate {
    let rtmp = "rtmp://live.hkstv.hk.lxdns.com/live/hks"
    let m3u8 = "https://video-dev.github.io/streams/x36xhzz/x36xhzz.m3u8"
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Input URL"
        textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play", style: .done, target: self, action: #selector(self.onClickPlayButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.text = m3u8
    }
    
    @objc func onClickPlayButton() {
        let url = URL(string: textView.text)
        let scheme: String? = url?.scheme?.lowercased()
        if (scheme == "http") || (scheme == "https") || (scheme == "rtmp") {
            IJKPlayerViewController.present(from: self, withTitle: "URL: \(String(describing: url))", url: url!, completion: {() -> Void in
                self.navigationController?.popViewController(animated: false)
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onClickPlayButton()
    }
}
