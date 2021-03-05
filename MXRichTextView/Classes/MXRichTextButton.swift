//
//  MXTextStyle.swift
//  MXRichTextView
//
//  Created by Liuxiaomin on 2020/8/24.
//

public class MXRichTextButton: UIControl {
    
    public struct Config {
        let icon: UIImage
        let activeIcon: UIImage
        
        public init(icon: UIImage, activeIcon: UIImage) {
            self.icon = icon
            self.activeIcon = activeIcon
        }
    }
    
    public enum Style {
        case bold, italic, underline, strikethrough, formatH1, formatH2, justifyLeft, justifyCenter, justifyRight, orderedList, unorderedList
        
        var command: MXRictEditCommand {
            switch self {
            case .bold:
                return .bold
            case .italic:
                return .italic
            case .underline:
                return .underline
            case .strikethrough:
                return .strikethrough
            case .formatH1:
                return .formatH1
            case .formatH2:
                return .formatH2
            case .justifyLeft:
                return .justifyLeft
            case .justifyCenter:
                return .justifyCenter
            case .justifyRight:
                return .justifyRight
            case .orderedList:
                return .insertOrderedList
            case .unorderedList:
                return .insertUnorderedList
            }
        }
        
        func isSelected(styles: [AnyHashable : Any]) -> Bool {
            switch self {
            case .bold:
                if let value = styles["bold"] as? Bool {
                    return value
                }
                return false
            case .italic:
                if let value = styles["italic"] as? Bool {
                    return value
                }
                return false
            case .underline:
                if let value = styles["underline"] as? Bool {
                    return value
                }
                return false
            case .strikethrough:
                if let value = styles["deleteline"] as? Bool {
                    return value
                }
                return false
            case .formatH1:
                if let value = styles["h1"] as? Bool {
                    return value
                }
                return false
            case .formatH2:
                if let value = styles["h2"] as? Bool {
                    return value
                }
                return false
            case .justifyLeft:
                if let value = styles["left"] as? Bool {
                    return value
                }
                return false
            case .justifyCenter:
                if let value = styles["center"] as? Bool {
                    return value
                }
                return false
            case .justifyRight:
                if let value = styles["right"] as? Bool {
                    return value
                }
                return false
            case .orderedList:
                if let value = styles["ol"] as? Bool {
                    return value
                }
                return false
            case .unorderedList:
                if let value = styles["ul"] as? Bool {
                    return value
                }
                return false
            }
        }
    }
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
        
    private let config: Config
    private let style: Style
    private weak var textView: MXRichTextView?
    private var isActive: Bool = false {
        didSet {
            refreshState()
        }
    }
    
    public init(style: Style, config: Config, textView: MXRichTextView) {
        self.style = style
        self.config = config
        self.textView = textView
        super.init(frame: .zero)
        setupView()
        refreshState()
        NotificationCenter.default.addObserver(self, selector: #selector(updateStyle(notification:)), name: MXRichTextView.updateStyleNotification, object: textView)
    }
    
    private func setupView() {
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refreshState() {
        self.imageView.image = isActive ? config.activeIcon : config.icon
    }
    
    @objc func updateStyle(notification: Notification) {
        guard let status = notification.userInfo else {
            return
        }
        
        isActive = style.isSelected(styles: status)
    }
    
    @objc private func onClick() {
        isActive = !isActive
        if let textView = textView {
            textView.excuteCommand(style.command)
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return imageView.sizeThatFits(size)
    }
}


