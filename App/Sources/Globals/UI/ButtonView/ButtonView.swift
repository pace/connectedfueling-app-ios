import Foundation
import JamitFoundation
import UIKit

final class ButtonView: StatefulView<ButtonViewModel> {
    private lazy var button: UIButton = .init(type: .custom)
    private lazy var heightConstraint: NSLayoutConstraint = heightAnchor.constraint(equalToConstant: style.height)
    private var buttonStateObservation: NSKeyValueObservation?

    var style: ButtonViewStyle = .primary {
        didSet { didChangeStyle() }
    }

    private var currentState: ButtonViewStyle.State {
        if button.state.contains(.disabled) {
            return style.disabledState
        }

        if button.state.contains(.highlighted) {
            return style.highlightedState
        }

        if button.state.contains(.selected) {
            return style.selectedState
        }

        return style.normalState
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundColor = .clear

        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.addTarget(self, action: #selector(didTriggerPrimaryAction), for: .primaryActionTriggered)
        button.addTarget(self, action: #selector(didBeginHighlighting), for: [.touchDown])
        button.addTarget(self, action: #selector(didEndHighlighting), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.clipsToBounds = true
        button.adjustsImageWhenHighlighted = false
        heightConstraint.isActive = true

        buttonStateObservation = button.observe(\.state) { [weak self] _, _ in
            self?.didChangeStyle()
        }

        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        button.isEnabled = model.isEnabled
        button.setTitle(model.title, for: [])
        button.setImage(model.isSelected ? model.selectedIcon : model.icon, for: [])
        button.isSelected = model.isSelected

        didChangeStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        didChangeStyle()
    }

    private func didChangeStyle() {
        button.tintColor = currentState.titleStyle.color
        button.setTitleColor(currentState.titleStyle.color, for: [])
        button.titleLabel?.font = currentState.titleStyle.font
        button.titleLabel?.numberOfLines = currentState.titleStyle.numberOfLines
        button.titleLabel?.lineBreakMode = currentState.titleStyle.lineBreakMode
        button.titleLabel?.textAlignment = currentState.titleStyle.textAlignment
        button.backgroundColor = currentState.backgroundColor
        button.borderStyle = currentState.borderStyle
        button.layer.shadowColor = currentState.shadowColor.cgColor
        button.layer.shadowOffset = .init(width: currentState.shadowOffset.x, height: currentState.shadowOffset.y)
        button.layer.shadowRadius = currentState.shadowRadius
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        heightConstraint.constant = style.height

        guard let imageView = button.imageView,
              let titleLabel = button.titleLabel else { return }
        let imageInset = -titleLabel.frame.width + button.frame.width - 20
        button.contentEdgeInsets = .init(top: 12, left: 20, bottom: 12, right: 8)
        button.titleEdgeInsets = .init(top: 0, left: -imageView.frame.width - 20, bottom: 0, right: 0)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: imageInset)
    }

    @objc
    private func didTriggerPrimaryAction() {
        model.action()

        didBeginHighlighting()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.didEndHighlighting()
        }
    }

    @objc
    private func didBeginHighlighting() {
        button.isHighlighted = true

        didChangeStyle()
    }

    @objc
    private func didEndHighlighting() {
        button.isHighlighted = false

        didChangeStyle()
    }
}
