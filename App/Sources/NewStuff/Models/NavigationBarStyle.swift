import Foundation

enum NavigationBarStyle {
    /// No icon or image, shows title
    case standard(title: String?)

    /// No title, shows icon in center, inline
    case centeredIcon(icon: ImageResource)
}
