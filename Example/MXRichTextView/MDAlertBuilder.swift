//
//  MDAlertBuilder.swift
//  MADV
//
//  Created by Liuxiaomin on 2019/1/10.
//  Copyright © 2019 apphi. All rights reserved.
//

import UIKit

class MDAlertBuilder: NSObject {
    var title:String?
    var message:String?
    var style = UIAlertController.Style.alert
    private var actions:[UIAlertAction] = []

    @objc
    @discardableResult
    func set(style:UIAlertController.Style) -> Self {
        self.style = style
        return self
    }
    
    @objc
    @discardableResult
    func set(title: String) -> Self {
        self.title = title
        return self
    }
    
    @objc
    @discardableResult
    func set(message: String) -> Self {
        self.message = message
        return self
    }
    
    @objc
    @discardableResult
    func add(action: UIAlertAction) -> Self {
        actions.append(action)
        return self
    }
    
    @objc
    @discardableResult
    func addAction(title:String, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: .default, handler: handler)
        actions.append(action)
        return self
    }
    
    @objc
    @discardableResult
    func addAction(title:String, style:UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        actions.append(action)
        return self
    }
    
    @objc
    @discardableResult
    func addCancelAction(handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        return self.addAction(title: NSLocalizedString("Cancel", comment: ""),
                              handler: handler)
    }
    
    @objc
    @discardableResult
    func addNOAction(handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        return self.addAction(title: NSLocalizedString("No", comment: ""),
                              handler: handler)
    }
    
    @objc
    @discardableResult
    func addYesAction(handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        return self.addAction(title: NSLocalizedString("Yes", comment: ""),
                              handler: handler)
    }
    
    @objc
    @discardableResult
    func addOKAction(handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        return self.addAction(title: NSLocalizedString("OK", comment: ""),
                              handler: handler)
    }
    
    @objc
    func build() -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            controller.addAction(action)
        }
        return controller
    }
    
}
