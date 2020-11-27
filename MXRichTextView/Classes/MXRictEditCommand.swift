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
    case undo, redo, focus
    
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
    case pasteHTML(String)
    case insertImageUrl(String)
    
    case createLink(text: String, url: String)
    
    case unlink
    
    case getLinkInfo
    
    case clean
    
    public func excute(webView: WKWebView, callback: ((Any?, Error?)->Void)?) {
        let js: String
        switch self {
        case .undo:
            js = "undo()"
        case .redo:
            js = "redo()"
        case .focus:
            js = "focus()"
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
        case .pasteHTML(let html):
            js = "pasteHTML('\(html)'"
        case .insertImageUrl(let url):
            js = "insertImageUrl('\(url)')"
        case .createLink(text: let text, url: let url):
            js = "createLink('\(text)','\(url)')"
        case .unlink:
            js = "unlink()"
        case .getLinkInfo:
            js = "getLinkInfo()"
        case .clean:
            js = "clean()"
            
        }
        
        webView.evaluateJavaScript(js, completionHandler: callback)
    }
}

