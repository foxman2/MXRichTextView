//test
// const iosMessage = {
//     postMessage: (obj) => {
//         console.log(obj)
//     }
// };

// window.webkit = {
//     messageHandlers: {}
// }
// window.webkit.messageHandlers.event_text_change = iosMessage;
// window.webkit.messageHandlers.event_update_current_style = iosMessage;
// window.webkit.messageHandlers.event_link_info = iosMessage;

var initSummernote = function(){
    const placeholder = window.mx_placeholder === undefined ? null : window.mx_placeholder
    
    $('#summernote').summernote({
        toolbar: [],
        spellCheck: false,
        disableGrammar: true,
        placeholder: window.mx_placeholder,
        popover: {
            image: [
            ['remove', ['removeMedia']]
            ],
            link: [
            ['link', ['unlink']]
            ],
            table: [],
            air: [],
        },
        callbacks: {
            onInit: function(e) {
                $("#summernote").summernote("fullscreen.toggle");
            },
            onChange: function(contents, $editable) {
                console.log('onChange:', contents, $editable);
                const message = {
                    text: contents,
                    isEmpty:  $('#summernote').summernote('isEmpty')
                }
                const json = JSON.stringify(message)
                window.webkit.messageHandlers.event_text_change.postMessage(json)
            },
            onUpdateButtonStatus: function(styleInfo) {
                const json = JSON.stringify(styleInfo)
                window.webkit.messageHandlers.event_update_current_style.postMessage(json)
            },
            onKeyup: function(e) {
                const result = $('#summernote').summernote('getLinkInfo');
                const json = JSON.stringify(result);
                window.webkit.messageHandlers.event_link_info.postMessage(json)
            },
            onMouseup: function(e) {
                const result = $('#summernote').summernote('getLinkInfo');
                const json = JSON.stringify(result);
                window.webkit.messageHandlers.event_link_info.postMessage(json)
            },
            //'summernote.keyup summernote.mouseup summernote.change summernote.scroll': () => {
        }
    });
    
    if (window.mx_initalHtml != null) {
        pasteHTML(window.mx_initalHtml)
    }
}

var focus = function(){
    $('#summernote').summernote('focus');
}

var disable = function(){
    $('#summernote').summernote('disable');
}

var enable = function(){
    $('#summernote').summernote('enable');
}

var pasteHTML = function(html){
    $('#summernote').summernote('code',html);
}

function keepLastIndex(obj) {
    var range = window.getSelection();//创建range
    range.selectAllChildren(obj);//range 选择obj下所有子内容
    range.collapseToEnd();//光标移至最后
}

var getHtmlAndMarkdown = function(){
    if ($('#summernote').summernote('isEmpty')) {
        return null
    }
    
    var html = $('#summernote').summernote('code')
    var turndownService = new TurndownService()
    var markdown = turndownService.turndown(html)
    return {
        html: html,
        markdown: markdown
    }
}

var enable = function() {
    $('#summernote').summernote('enable');
};

var bold = function() {
    $('#summernote').summernote('bold');
};

var italic = function() {
    $('#summernote').summernote('italic');
};

var underline = function() {
    $('#summernote').summernote('underline');
};

var strikethrough = function() {
    $('#summernote').summernote('strikethrough');
};

var superscript = function() {
    $('#summernote').summernote('superscript');
};

var subscript = function() {
    $('#summernote').summernote('subscript');
};

var backColor = function(color) {
    $('#summernote').summernote('backColor', color);
};

var foreColor = function(color) {
    $('#summernote').summernote('foreColor', color);
};

var fontName = function(fontName) {
    $('#summernote').summernote('fontName', fontName);
};

var fontSize = function(fontSize) {
    $('#summernote').summernote('fontSize', fontSize);
};

var justifyLeft = function() {
    $('#summernote').summernote('justifyLeft');
};

var justifyRight = function() {
    $('#summernote').summernote('justifyRight');
};

var justifyCenter = function() {
    $('#summernote').summernote('justifyCenter');
};

var justifyFull = function() {
    $('#summernote').summernote('justifyFull');
};

var insertOrderedList = function() {
    $('#summernote').summernote('insertOrderedList');
};

var insertUnorderedList = function() {
    $('#summernote').summernote('insertUnorderedList');
};

var indent = function() {
    $('#summernote').summernote('indent');
};

var outdent = function() {
    $('#summernote').summernote('outdent');
};

var formatBlock = function(tagName) {
    $('#summernote').summernote('formatBlock', tagName);
};

var formatPara = function() {
    $('#summernote').summernote('formatPara');
};

var formatH1 = function() {
    $('#summernote').summernote('formatH1');
};

var formatH2 = function() {
    $('#summernote').summernote('formatH2');
};

var formatH3 = function() {
    $('#summernote').summernote('formatH3');
};

var formatH4 = function() {
    $('#summernote').summernote('formatH4');
};

var formatH5 = function() {
    $('#summernote').summernote('formatH5');
};

var formatH6 = function() {
    $('#summernote').summernote('formatH6');
};

var lineHeight = function(lineHeight) {
    $('#summernote').summernote('lineHeight', lineHeight);
};

var insertImageUrl = function(imageUrl) {
    $('#summernote').summernote('insertParagraph');
    const range = $.summernote.range;
    const lastRange = range.createFromSelection();
    $('#summernote').summernote('editor.setLastRange', lastRange);
    return $('#summernote').summernote('insertImage', imageUrl, null);
};

var insertText = function(text) {
    $('#summernote').summernote('insertText', text);
};

var createLink = function(linkText, linkUrl) {
    $('#summernote').summernote('createLink', {
      text: linkText,
      url: linkUrl,
      isNewWindow: false
    });
};

var unlink = function() {
    $('#summernote').summernote('unlink');
};

var insertAttachment = function(url) {
    $('#summernote').summernote('insertParagraph');
    const range = $.summernote.range;
    const lastRange = range.createFromSelection();
    $('#summernote').summernote('editor.setLastRange', lastRange);

    const name = url.substring(url.lastIndexOf("/") + 1);
    const html = `<img style=\"width: 20px;\" src="https://static.engagemessage.com/images/attachment@3x.png"><a href="${url}">${name}</a>`;
    $('#summernote').summernote('pasteHTML', html);
    
}


var codeView = function(){
    $('#summernote').summernote('codeview.toggle');
}

var insertTable = function(dim){
    $('#summernote').summernote('insertTable', dim);
}

var insertHorizontalRule = function() {
    $('#summernote').summernote('insertHorizontalRule');
}

var saveRange = function() {
    $('#summernote').summernote('saveRange');
}

var restoreRange = function() {
    $('#summernote').summernote('restoreRange');
}

var getLinkInfo = function() {
    const result = $('#summernote').summernote('getLinkInfo');
    const json = JSON.stringify(result);
    return json
}

var clean = function() {
    const result = $('#summernote').summernote('reset');
    const json = JSON.stringify(result);
    return json
}
