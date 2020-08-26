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
    
    public struct Style {
        let key: String
        let value: String
        let command: MXRictEditCommand
        
        public static let bold = Style(key: "font-bold", value: "bold", command: .bold)
        public static let italic = Style(key: "font-italic", value: "italic", command: .italic)
        
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
        
        let acvtive:Bool
        if let value = status[style.key] as? String, value == style.value {
            acvtive = true
        } else {
            acvtive = false
        }
        isActive = acvtive
    }
    
    @objc private func onClick() {
        if let textView = textView {
            textView.excuteCommand(style.command)
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return imageView.sizeThatFits(size)
    }
}


