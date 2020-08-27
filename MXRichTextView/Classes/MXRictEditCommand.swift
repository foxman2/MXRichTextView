//
//  MXRichEditAction.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//

import WebKit

public protocol MXRictEditCommandProtocol {
    func excute(webView: WKWebView, callback: ((Any?, Error?)->Void)?)
}

public enum MXRictEditCommand: MXRictEditCommandProtocol {
    
    typealias CallBack = (Any?, Error?)
    
    //acion
    case undo, redo
    
    // Format
    case bold, italic, underline, strikethrough
    
    // Style
    case formatPara, formatH1, formatH2, formatH3
    
    //Alignment
    case justifyLeft, justifyCenter, justifyRight
    
    // List Style
    case insertOrderedList, insertUnorderedList

    case saveRange
    case restoreRange
    
    // Insert
    case insertImageUrl(String)
    
    case createLink(text: String, url: String)
    
    case getLinkInfo
    
    public func excute(webView: WKWebView, callback: ((Any?, Error?)->Void)?) {
        let js: String
        switch self {
        case .undo:
            js = "undo()"
        case .redo:
            js = "redo()"
        case .bold:
            js = "bold()"
        case .italic:
            js = "italic()"
        case .underline:
            js = "underline()"
        case .strikethrough:
            js = "strikethrough()"
        case .formatPara:
            js = "formatPara()"
        case .formatH1:
            js = "formatH1()"
        case .formatH2:
            js = "formatH2()"
        case .formatH3:
            js = "formatH3()"
        case .justifyLeft:
            js = "justifyLeft()"
        case .justifyCenter:
            js = "justifyCenter()"
        case .justifyRight:
            js = "justifyRight()"
        case .insertOrderedList:
            js = "insertOrderedList()"
        case .insertUnorderedList:
            js = "insertUnorderedList()"
        case .saveRange:
            js = "saveRange()"
        case .restoreRange:
            js = "restoreRange()"
        case .insertImageUrl(let url):
            js = "insertImageUrl('\(url)')"
        case .createLink(text: let text, url: let url):
            js = "createLink('\(text)','\(url)')"
        case .getLinkInfo:
            js = "getLinkInfo()"
        }
        
        webView.evaluateJavaScript(js, completionHandler: callback)
    }
}

