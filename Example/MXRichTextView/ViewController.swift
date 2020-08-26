//
//  ViewController.swift
//  MXRichTextView
//
//  Created by b9d606c86e170baea85d0a4c2469f8e8f6705314 on 08/24/2020.
//  Copyright (c) 2020 b9d606c86e170baea85d0a4c2469f8e8f6705314. All rights reserved.
//

import UIKit
import MXRichTextView

class ViewController: UIViewController {
    @IBOutlet weak var textView: MXRichTextView!
    public private(set) var inputBarContainer: UIView!
    public private(set) var inputContentContainer: UIView!
    private var keyboardTracker: MXKeyboardTracker?
    
    private var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let inputToolBar = Bundle.main.loadNibNamed("MXInputToolBar", owner: nil, options: nil)?.first as? MXInputToolBar else {
            fatalError()
        }
        inputToolBar.setupView(textView: textView)
        inputToolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputToolBar)
        inputToolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        inputToolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = view.bottomAnchor.constraint(equalTo:  inputToolBar.bottomAnchor)
        bottomConstraint?.isActive = true
        
        
        keyboardTracker = MXKeyboardTracker(trackBlock: { [weak self] frame, status in
            guard let self = self,
                let constraint = self.bottomConstraint else {
                return
            }
            let frame = self.view.convert(frame, from: nil)
            constraint.constant = self.view.bounds.height - frame.minY
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self.view.layoutIfNeeded()
            }
        })
    }
    
    @objc func onClick() {
        textView.excuteCommand(.bold)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func addInputContentContainer() {
        self.inputContentContainer = UIView(frame: CGRect.zero)
        self.inputContentContainer.autoresizingMask = UIView.AutoresizingMask()
        self.inputContentContainer.translatesAutoresizingMaskIntoConstraints = false
        self.inputContentContainer.backgroundColor = .white
        self.view.addSubview(self.inputContentContainer)
        self.view.addConstraint(NSLayoutConstraint(item: self.inputContentContainer, attribute: .top, relatedBy: .equal, toItem: self.inputBarContainer, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: self.inputContentContainer, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.inputContentContainer, attribute: .trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.inputContentContainer, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
}

