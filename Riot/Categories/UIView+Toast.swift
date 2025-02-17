// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

//  MARK: - ToastPosition

/// Vertical position for a toast
@objc
enum ToastPosition: Int {
    /// Toast will be placed at the top of the screen, with a margin to the safe area insets of the superview. Max height is also limited with safe area insets.
    case top
    /// Toast will be placed at the middle of the screen vertically. Max height is also limited with safe area insets.
    case middle
    /// Toast will be placed at the bottom of the screen, with a margin to the safe area insets of the superview. Max height is also limited with safe area insets.
    case bottom
}

//  MARK: - UIView Extension

extension UIView {
    
    private enum Constants {
        static let defaultDuration: TimeInterval = 2.0
        static let defaultPosition: ToastPosition = .bottom
    }
    
    private static var operationQueue: OperationQueue = {
        let queue = OperationQueue.vc_createSerialOperationQueue(name: "ToastQueue")
        queue.qualityOfService = .userInteractive
        queue.underlyingQueue = .main
        return queue
    }()
    
    /// Show a toast message with the given properties.
    /// - Parameters:
    ///   - message: Message to be displayed
    ///   - image: Icon to be displayed. Placed left to the message. Will be tinted.
    ///   - duration: Duration of the toast messsage
    ///   - position: Vertical position of the toast message in the view. Toast view spans the receiver view horizontally, taking into account the safe area insets.
    ///   - additionalMargin: By default, a toast placed according to safe area insets, with a margin.
    ///   For `top` and `bottom` positions, adds toast an additional margin from the top and bottom respectively.
    ///   Has no effect for `middle` position.
    @objc
    func vc_toast(message: String?,
                  image: UIImage? = nil,
                  duration: TimeInterval = Constants.defaultDuration,
                  position: ToastPosition = Constants.defaultPosition,
                  additionalMargin: CGFloat = 0.0) {
        let view = ToastView(withMessage: message, image: image)
        vc_toast(view: view, duration: duration, position: position, additionalMargin: additionalMargin)
    }
    
    /// Show a toast view with the given properties.
    /// - Parameters:
    ///   - view: View to be displayed as a toast
    ///   - duration: Duration of the toast messsage
    ///   - position: Vertical position of the toast message in the view. Toast view spans the receiver view horizontally, taking into account the safe area insets.
    ///   - additionalMargin: By default, a toast placed according to safe area insets, with a margin.
    ///   For `top` and `bottom` positions, adds toast an additional margin from the top and bottom respectively.
    ///   Has no effect for `middle` position.
    @objc
    func vc_toast(view: UIView,
                  duration: TimeInterval = Constants.defaultDuration,
                  position: ToastPosition = Constants.defaultPosition,
                  additionalMargin: CGFloat = 0.0) {
        let operation = ToastOperation(containerView: self,
                                       toastView: view,
                                       duration: duration,
                                       position: position,
                                       additionalMargin: additionalMargin,
                                       completion: nil)
        Self.operationQueue.addOperation(operation)
    }
    
}

//  MARK: - ToastOperation

/// Async toast UI operation. Will run on the main thread.
private class ToastOperation: AsyncOperation {
    
    private enum Constants {
        static let margin: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let animationDuration: TimeInterval = 0.15
        static let timeBetweenToasts: TimeInterval = 0.5
    }
    
    private var containerView: UIView
    private var toastView: UIView
    private var duration: TimeInterval
    private var position: ToastPosition
    private var additionalMargin: CGFloat
    private var completion: (() -> Void)?
    private var timer: Timer?
    
    init(containerView: UIView,
         toastView: UIView,
         duration: TimeInterval,
         position: ToastPosition,
         additionalMargin: CGFloat,
         completion: (() -> Void)? = nil) {
        self.containerView = containerView
        self.toastView = toastView
        self.duration = duration
        self.position = position
        self.additionalMargin = additionalMargin
        self.completion = completion
    }
    
    override func main() {
        showToast {
            self.invalidateTimer()
            let timer = Timer(timeInterval: self.duration,
                              target: self,
                              selector: #selector(self.timerFired(_:)),
                              userInfo: nil,
                              repeats: false)
            RunLoop.main.add(timer, forMode: .common)
            self.timer = timer
        }
    }
    
    @objc
    private func timerFired(_ timer: Timer) {
        invalidateTimer()
        hideToast()
    }
    
    private func showToast(_ completion: @escaping () -> Void) {
        toastView.alpha = 0.0
        containerView.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            NSLayoutConstraint.activate([
                toastView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.margin.left),
                toastView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor,
                                               constant: Constants.margin.top + additionalMargin),
                toastView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -Constants.margin.right),
                toastView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -Constants.margin.bottom)
            ])
        case .middle:
            NSLayoutConstraint.activate([
                toastView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.margin.left),
                toastView.topAnchor.constraint(greaterThanOrEqualTo: containerView.safeAreaLayoutGuide.topAnchor,
                                               constant: Constants.margin.top),
                toastView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -Constants.margin.right),
                toastView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -Constants.margin.bottom),
                toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                toastView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.margin.left),
                toastView.topAnchor.constraint(greaterThanOrEqualTo: containerView.safeAreaLayoutGuide.topAnchor,
                                               constant: Constants.margin.top),
                toastView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -Constants.margin.right),
                toastView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -Constants.margin.bottom - additionalMargin)
            ])
        }
        
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: 0.0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        self.toastView.alpha = 1.0
                       }, completion: { _ in
                        completion()
                       })
    }
    
    private func hideToast() {
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: 0.0,
                       options: [.curveEaseIn, .beginFromCurrentState],
                       animations: {
                        self.toastView.alpha = 0.0
                       }, completion: { _ in
                        self.toastView.removeFromSuperview()
                        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeBetweenToasts) {
                            self.finish()
                            self.completion?()
                        }
                       })
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

//  MARK: - ToastView

/// Default view for a basic toast.
private class ToastView: UIView, Themable {
    
    private enum Constants {
        static let padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let cornerRadius: CGFloat = 8.0
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeService.shared().theme.fonts.body
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.distribution = .fill
        result.alignment = .center
        result.spacing = 8.0
        result.backgroundColor = .clear
        
        addSubview(result)
        result.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            result.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding.left),
            result.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding.top),
            result.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding.right),
            result.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding.bottom)
        ])
        
        return result
    }()
    
    init(withMessage message: String?,
         image: UIImage? = nil) {
        super.init(frame: .zero)
        
        if let image = image {
            imageView.image = image
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: image.size.width),
                imageView.heightAnchor.constraint(equalToConstant: image.size.height)
            ])
            stackView.addArrangedSubview(imageView)
        }
        
        messageLabel.text = message
        stackView.addArrangedSubview(messageLabel)
        
        stackView.layoutIfNeeded()
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        registerThemeServiceDidChangeThemeNotification()
        themeDidChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerThemeServiceDidChangeThemeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .themeServiceDidChangeTheme,
                                               object: nil)
    }
    
    @objc
    private func themeDidChange() {
        self.update(theme: ThemeService.shared().theme)
    }
    
    //  MARK: Themable
    
    func update(theme: Theme) {
        backgroundColor = theme.colors.quinaryContent
        imageView.tintColor = theme.colors.tertiaryContent
        messageLabel.textColor = theme.colors.primaryContent
        messageLabel.font = theme.fonts.body
    }
    
}
