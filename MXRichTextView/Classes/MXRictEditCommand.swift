//
//  MXRichEditAction.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//

import WebKit

public protocol MXRictEditCommandProtocol {
    func excute(webView: WKWebView)
}

public enum MXRictEditCommand: MXRictEditCommandProtocol {
    
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

    // Insert
    case insertImageUrl(String)
    
    case createLink(text: String, url: String)
    
    public func excute(webView: WKWebView) {
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
        case .insertImageUrl(let url):
            js = "insertImageUrl('\(url)')"
        case .createLink(text: let text, url: let url):
            js = "createLink('\(text)','\(url)')"
        }
        
        webView.evaluateJavaScript(js)
    }
}
