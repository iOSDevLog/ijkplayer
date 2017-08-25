//
//  IJKMediaPlayback.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

@IBDesignable
class IJKMediaControl: UIControl {
    
    weak var delegatePlayer: IJKMediaPlayback?
    @IBOutlet var overlayPanel: UIControl!
    @IBOutlet var topPanel: UIView!
    @IBOutlet var bottomPanel: UIView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var totalDurationLabel: UILabel!
    @IBOutlet var mediaProgressSlider: UISlider!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var hudButton: UIButton!
    private var isMediaSliderBeingDragged: Bool = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showNoFade() {
        overlayPanel.isHidden = false
        cancelDelayedHide()
        refreshMediaControl()
    }
    
    func showAndFade() {
        showNoFade()
        perform(#selector(self.hide), with: nil, afterDelay: 5)
    }
    
    func hide() {
        overlayPanel.isHidden = true
        cancelDelayedHide()
    }
    
    func refreshMediaControl() {
        guard delegatePlayer != nil else {
            return
        }
        // duration
        let duration: TimeInterval? = delegatePlayer?.duration
        let intDuration: Int = Int(duration! + 0.5)
        if intDuration > 0 {
            mediaProgressSlider.maximumValue = Float(duration!)
            totalDurationLabel.text = String(format: "%02d:%02d", Int(intDuration / 60), Int(intDuration % 60))
        }
        else {
            totalDurationLabel.text = "--:--"
            mediaProgressSlider.maximumValue = 1.0
        }
        // position
        var position: TimeInterval
        if isMediaSliderBeingDragged {
            position = TimeInterval(mediaProgressSlider.value)
        }
        else {
            guard delegatePlayer != nil else {
                return
            }
            position = (delegatePlayer?.currentPlaybackTime)!
        }
        let intPosition: Int = Int(position + 0.5)
        if intDuration > 0 {
            mediaProgressSlider.value = Float(position)
        }
        else {
            mediaProgressSlider.value = 0.0
        }
        currentTimeLabel.text = String(format: "%02d:%02d", Int(intPosition / 60), Int(intPosition % 60))
        // status
        let isPlaying: Bool? = delegatePlayer?.isPlaying()
        playButton.isHidden = isPlaying!
        pauseButton.isHidden = !isPlaying!
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.refreshMediaControl), object: nil)
        if !overlayPanel.isHidden {
            perform(#selector(self.refreshMediaControl), with: nil, afterDelay: 0.5)
        }
    }
    
    func beginDragMediaSlider() {
        isMediaSliderBeingDragged = true
    }
    
    func endDragMediaSlider() {
        isMediaSliderBeingDragged = false
    }
    
    func continueDragMediaSlider() {
        refreshMediaControl()
    }
    
    func cancelDelayedHide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hide), object: nil)
    }

}
