//
//  MXRichEditAction.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//
import WebKit

public protocol MXSummernoteDelegate: AnyObject {
    func updateCurrentStyle(_ style: [String:Any])
    func richTextChange(text: String?, isEmpty:Bool)
    func richTextLinkInfoAtSelection(_ info: [String:Any])
}

public class MXSummernoteCallback: NSObject, WKScriptMessageHandler {
    public let event_update_current_style = "event_update_current_style"
    public let event_text_change = "event_text_change"
    public let event_link_info = "event_link_info"
    
    private let jsonDecoder = JSONDecoder()
    weak var delegate: MXSummernoteDelegate?
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let delegate = delegate else {
            return
        }
        
        switch message.name {
        case event_update_current_style:
            guard let json = message.body as? String,
                let jsonData = json.data(using: .utf8),
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                return
            }
            
            guard let style = jsonObject as? [String:Any] else {
                return
            }
            
            delegate.updateCurrentStyle(style)
            
        case event_text_change:
            guard let json = message.body as? String,
                let jsonData = json.data(using: .utf8),
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                return
            }
            
            guard let event = jsonObject as? [String:Any] else {
                return
            }
            
            let text = event["text"] as? String
            let isEmpty = event["isEmpty"] as? Bool ?? true
            delegate.richTextChange(text: text, isEmpty: isEmpty)
            
        case event_link_info:
            guard let json = message.body as? String,
                let jsonData = json.data(using: .utf8),
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                return
            }
            
            guard let event = jsonObject as? [String:Any] else {
                return
            }
            
            delegate.richTextLinkInfoAtSelection(event)
        default:
            break
        }
        
        
        
    }
}
