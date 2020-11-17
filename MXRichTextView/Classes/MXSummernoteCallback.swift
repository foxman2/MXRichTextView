//
//  MXRichEditAction.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//
import WebKit

public protocol MXSummernoteDelegate: AnyObject {
    func updateCurrentStyle(_ style: [String:Any])
}

public class MXSummernoteCallback: NSObject, WKScriptMessageHandler {
    private let jsonDecoder = JSONDecoder()
    weak var delegate: MXSummernoteDelegate?
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let delegate = delegate else {
            return
        }
        guard let json = message.body as? String,
            let jsonData = json.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            return
        }
        
        guard let style = jsonObject as? [String:Any] else {
            return
        }
        
        delegate.updateCurrentStyle(style)
        
    }
}
