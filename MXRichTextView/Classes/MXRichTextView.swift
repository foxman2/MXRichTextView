//
//  MXRichTextView.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//

import UIKit
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

public protocol MXRichTextViewDelegate: MXSummernoteDelegate {
    
}

public class MXRichTextView: UIView, MXSummernoteDelegate {
    public static let updateStyleNotification = Notification.Name("updateStyleNotification")
    
    var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        webView.scrollView.isScrollEnabled = false
        webView.hack_removeInputAccessory()
        return webView
    }()
    
    var editorCallback = MXSummernoteCallback()
    
    public var placeholder: String?
    public var initalHtml: String?
    public weak var delegate: MXRichTextViewDelegate?
    
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
            .add(editorCallback, name: editorCallback.event_update_current_style)
        webView.configuration
            .userContentController
            .add(editorCallback, name: editorCallback.event_text_change)
        webView.configuration
            .userContentController
            .add(editorCallback, name: editorCallback.event_link_info)

    }
    
    public func loadEditor() {
        
        var js = ""
        if let placeholder = self.placeholder {
            js += "window.mx_placeholder='\(placeholder)'\n"
        }
        
        if let html = self.initalHtml {
            js += "window.mx_initalHtml='\(html)'\n"
        }
        
        let script = WKUserScript(source: js,
                                  injectionTime: .atDocumentStart,
                                  forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        
        let cbundle = Bundle(for: MXRichTextView.self)
        guard let bundlePath = cbundle.path(forResource: "MXRichTextView", ofType: "bundle"),
              let bundle = Bundle(path: bundlePath) else {
            return
        }
        let path = bundle.url(forResource: "richEditor", withExtension: "html")!
        let url = URL(fileURLWithPath: NSHomeDirectory())
        self.webView.loadFileURL(path, allowingReadAccessTo: url)
    }
    
    public func excuteCommand(_ cmd: MXRictEditCommand, callback: ((Any?, Error?)->Void)? = nil) {
        cmd.excute(webView: webView, callback: callback)
    }
    
    public func excuteCommand(_ cmd: MXRictEditCommandProtocol,  callback: ((Any?, Error?)->Void)? = nil) {
        cmd.excute(webView: webView, callback: callback)
    }
    
    public func getHtmlAndMarkdown(callback:@escaping (String?, String?, Error?) -> Void) {
        webView.evaluateJavaScript("getHtmlAndMarkdown()") { (result, error) in
            if let error = error {
                callback(nil, nil, error)
                return
            }
            
            guard let result = result as? [String: String] else {
                callback(nil, nil, nil)
                return
            }
            
            let html = result["html"]
            let markdown = result["markdown"]
            callback(html, markdown, nil)
        }
    }
    
    public func getLink(callback: @escaping (String?, String?, Error?) -> Void) {
        self.excuteCommand(.getLinkInfo) { (info, error) in
            var title: String? = nil
            var link: String? = nil
            if let json = info as? String,
               let data = json.data(using: .utf8),
               let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                title = jsonObj["text"] as? String
                link = jsonObj["url"] as? String
            }
            callback(title, link, error)
        }
    }
    
    //delegate
    public func updateCurrentStyle(_ style: [String : Any]) {
        NotificationCenter.default.post(name: MXRichTextView.updateStyleNotification, object: self, userInfo: style)
        delegate?.updateCurrentStyle(style)
    }
    
    public func richTextChange(text: String?, isEmpty: Bool) {
        delegate?.richTextChange(text: text, isEmpty: isEmpty)
    }
    
    public func richTextLinkInfoAtSelection(_ info: [String : Any]) {
        delegate?.richTextLinkInfoAtSelection(info)
    }
}
