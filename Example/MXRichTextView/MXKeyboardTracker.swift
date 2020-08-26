//
//  MXKeyboardTracker.swift
//  MXRichTextView_Example
//
//  Created by Liuxiaomin on 2020/8/26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public enum MXKeyboardStatus {
    case hiding
    case hidden
    case showing
    case shown
}
public typealias MXKeyboardTrackBlock = (_ frame: CGRect, _ status: MXKeyboardStatus) -> Void
class MXKeyboardTracker {
    private(set) var keyboardStatus: MXKeyboardStatus = .hidden
    public private(set) var keyboardFrame:CGRect = .zero
    private let trackBlock: MXKeyboardTrackBlock
    init(trackBlock: @escaping MXKeyboardTrackBlock) {
        self.trackBlock = trackBlock
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: .UIKeyboardDidShow,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: .UIKeyboardDidHide,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: .UIKeyboardWillChangeFrame,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        self.keyboardStatus = .showing
        keyboardFrame = frameFromNotification(notification)
    }

    @objc
    private func keyboardDidShow(_ notification: Notification) {
        self.keyboardStatus = .shown
        keyboardFrame = frameFromNotification(notification)
        trackBlock(keyboardFrame, keyboardStatus)
    }

    @objc
    private func keyboardWillChangeFrame(_ notification: Notification) {
        keyboardFrame = frameFromNotification(notification)
        trackBlock(keyboardFrame, keyboardStatus)
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.keyboardStatus = .hiding
        keyboardFrame = frameFromNotification(notification)
        trackBlock(keyboardFrame, keyboardStatus)
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        self.keyboardStatus = .hidden
        keyboardFrame = frameFromNotification(notification)
        trackBlock(keyboardFrame, keyboardStatus)
    }
    
    private func frameFromNotification(_ notification: Notification) -> CGRect {
        guard let rect = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return .zero }
        return rect
    }
}
