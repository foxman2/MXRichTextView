//
//  MXRichTextView.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//

import UIKit
import WebKit

import WebKit

fileprivate final class InputAccessoryHackHelper: NSObject {
    @objc var inputAccessoryView: AnyObject? { return nil }
}

extension WKWebView {
    func hack_removeInputAccessory() {
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let superclass = target.superclass else {
            return
        }

        let noInputAccessoryViewClassName = "\(superclass)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)

        if newClass == nil, let targetClass = object_getClass(target), let classNameCString = noInputAccessoryViewClassName.cString(using: .ascii) {
            newClass = objc_allocateClassPair(targetClass, classNameCString, 0)

            if let newClass = newClass {
                objc_registerClassPair(newClass)
            }
        }

        guard let noInputAccessoryClass = newClass, let originalMethod = class_getInstanceMethod(InputAccessoryHackHelper.self, #selector(getter: InputAccessoryHackHelper.inputAccessoryView)) else {
            return
        }
        class_addMethod(noInputAccessoryClass.self, #selector(getter: InputAccessoryHackHelper.inputAccessoryView), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        object_setClass(target, noInputAccessoryClass)
    }
}

public class MXRichTextView: UIView, MXSummernoteDelegate {
    public static let updateStyleNotification = Notification.Name("updateStyleNotification")
    
    var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.hack_removeInputAccessory()
        return webView
    }()
    
    var editorCallback = MXSummernoteCallback()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        editorCallback.delegate = self
        webView.frame = self.bounds
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        webView.configuration
            .userContentController
            .add(editorCallback, name: "mxCallback")

        let cbundle = Bundle(for: MXRichTextView.self)
        guard let bundlePath = cbundle.path(forResource: "MXRichTextView", ofType: "bundle"),
        let bundle = Bundle(path: bundlePath) else {
            return
        }
        let path = bundle.url(forResource: "richEditor", withExtension: "html")!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.webView.loadFileURL(path, allowingReadAccessTo: path)
        }
    }
    
    public func excuteCommand(_ cmd: MXRictEditCommand, callback: ((Any?, Error?)->Void)? = nil) {
        cmd.excute(webView: webView, callback: callback)
    }
    
    public func excuteCommand(_ cmd: MXRictEditCommandProtocol,  callback: ((Any?, Error?)->Void)? = nil) {
        cmd.excute(webView: webView, callback: callback)
    }
    
    //delegate
    public func updateCurrentStyle(_ style: [String : Any]) {
        NotificationCenter.default.post(name: MXRichTextView.updateStyleNotification, object: self, userInfo: style)
    }
}
