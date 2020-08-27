//
//  MXInputToolBar.swift
//  MXRichTextView_Example
//
//  Created by Liuxiaomin on 2020/8/26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MobileCoreServices
import MXRichTextView

class MXInputToolBar: UIView {
    private let textActions: [(MXRichTextButton.Style, MXRichTextButton.Config)] = [
        (.bold, .init(icon: UIImage(named: "aa_b_n")!,
                      activeIcon: UIImage(named: "aa_b_n")!)),
        
        (.italic, .init(icon: UIImage(named: "aa_italic_n")!,
        activeIcon: UIImage(named: "aa_italic_n")!)),
        
        (.underline, .init(icon: UIImage(named: "aa_underline_n")!,
        activeIcon: UIImage(named: "aa_underline_n")!)),
        
        (.strikethrough, .init(icon: UIImage(named: "aa_strikethrough_n")!,
        activeIcon: UIImage(named: "aa_strikethrough_n")!)),
        
        (.insertOrderedList, .init(icon: UIImage(named: "aa_numberedlist_n")!,
        activeIcon: UIImage(named: "aa_numberedlist_r")!)),
        
        (.insertUnorderedList, .init(icon: UIImage(named: "aa_bulleted_list_n")!,
        activeIcon: UIImage(named: "aa_bulleted_list_r")!)),
        
        (.justifyLeft, .init(icon: UIImage(named: "aa_left_n")!,
        activeIcon: UIImage(named: "aa_left_r")!)),
        
        (.justifyCenter, .init(icon: UIImage(named: "aa_center_n")!,
        activeIcon: UIImage(named: "aa_center_r")!)),
        
        (.justifyRight, .init(icon: UIImage(named: "aa_right_n")!,
        activeIcon: UIImage(named: "aa_right_r")!)),
        
        (.formatH1, .init(icon: UIImage(named: "aa_h1_n")!,
        activeIcon: UIImage(named: "aa_h1_r")!)),
        
        (.formatH2, .init(icon: UIImage(named: "aa_h2_n")!,
        activeIcon: UIImage(named: "aa_h2_r")!)),
    ]
    @IBOutlet weak var textActionContentVeiw: UIStackView!
    @IBOutlet var textActionContraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLine: UIView!
    private weak var textView: MXRichTextView?
    
    public func setupView(textView: MXRichTextView) {
        self.textView = textView
        for action in textActions {
            let button = MXRichTextButton(style: action.0, config: action.1, textView: textView)
            button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            textActionContentVeiw.addArrangedSubview(button)
        }
    }

    @IBAction func onClickText(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            hideTextAction()
        } else {
            sender.isSelected = true
            showTextAction()
        }
    }
    
    private func showTextAction() {
        if !textActionContraint.isActive {
            textActionContraint.isActive = true
            UIView.animate(withDuration: 0.1) {
                self.superview?.layoutIfNeeded()
                self.seperatorLine.alpha = 1
            }
        }
    }
    
    private func hideTextAction() {
        if textActionContraint.isActive {
            textActionContraint.isActive = false
            UIView.animate(withDuration: 0.1) {
                self.seperatorLine.alpha = 0
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func onClickInserImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        let mediaType = kUTTypeImage as String
        guard let availableMediaTypes =  UIImagePickerController.availableMediaTypes(for: .photoLibrary), availableMediaTypes.contains(mediaType) else {
            return
        }
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [mediaType]
        vc.delegate = self
        
        self.md_viewController?.present(vc, animated: true)
    }
    
    @IBAction func onClickLink(_ sender: Any) {
        let builder = MDAlertBuilder()
        .set(title: NSLocalizedString("Add a link", comment: ""))
        .set(message: NSLocalizedString("Enter your link test and the URL", comment: ""))
        
        var nameTF:UITextField?, linkTF:UITextField?
        builder.addAction(title: NSLocalizedString("Add Link", comment: "")) { _ in
            guard let name = nameTF?.text,
                let link = linkTF?.text else {
                    return
            }
            self.textView?.excuteCommand(.createLink(text: name, url: link))
        }
        builder.addCancelAction()
        let alert = builder.build()
        alert.addTextField { tf in
            nameTF = tf
        }
        alert.addTextField { tf in
            linkTF = tf
        }
        self.md_viewController?.present(alert, animated: true)
    }
    
    @IBAction func onClickHideKeyboard(_ sender: Any) {
        textView?.endEditing(true)
    }
}

extension UIView {
    @objc
    public var md_viewController: UIViewController? {
        var nextResponder = self.next
        while nextResponder != nil {
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}

extension MXInputToolBar: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        if #available(iOS 11.0, *) {
            guard let url = info[UIImagePickerControllerImageURL] as? URL else {
                return
            }
            textView?.excuteCommand(.insertImageUrl(url.absoluteString))
        } else {
            // Fallback on earlier versions
        }
        print(info)
    }
}
