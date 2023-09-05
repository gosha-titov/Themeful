import Foundation

/// An object that can update its appearance.
internal typealias TFObject = TFAppearanceUpdatable



/// A UI element that can subscribe to appearance updates and, accordingly, can handle changes of the current theme.
///
/// The `TFAppearanceUpdatable` protocol provides methods and properties needed to update the appearance.
/// You can use this protocol not only to UI elements (UIView) but also to containers (UIViewController).
/// At the same time, you do not need to create a new class for each UI element,
/// but only enough for those that contain other UI elements as in the following example:
///
///     final class View: UIView, TFAppearanceUpdatable {
///
///         private let label: UILabel
///         private let button: UIButton
///
///         ...
///
///         func updateAppearance(with theme: Theme) -> Void {
///             backgroundColor = theme.environment.colors.background
///             label.backgroundColor = theme.label.colors.background
///             label.textColor = theme.label.colors.text
///             label.font = theme.label.typography.font
///             button.backgroundColor = theme.button.colors.background
///             button.titleLabel?.textColor = theme.button.colors.text
///             button.setImage(theme.button.images.normal, for: .normal)
///         }
///
///         ...
///
///         override init(frame: CGRect) {
///             super.init(frame: frame)
///             ...
///             subscribeToAppearanceUpdates()
///         }
///
///     }
///
/// Note that the `subscribeToAppearanceUpdates()` method is called during initialization.
/// This method is important because without it the appearance will not be updated.
///
/// You can also manually update appearance by calling the `setNeedsUpdateAppearance()` method.
public protocol TFAppearanceUpdatable: AnyObject {
    
    /// A custom theme that provides appearance that UI elements adhere to.
    associatedtype Theme: TFTheme
    
    /// A boolean value that indicates whether the appearance update can be animated.
    ///
    /// If the value is `false` then the appearance update is not animated.
    var prefersAppearanceUpdateToBeAnimated: Bool { get }
    
    /// Called when the current theme has been changed by user or system.
    ///
    /// - Important: In order to handle changes of the current theme, this object should be subscribed to appearance updates.
    /// If you haven't done it yet, then call the `subscribeToAppearanceUpdates(andGetCurrentTheme:)` method.
    func updateAppearance(with theme: Theme) -> Void
    
}


public extension TFAppearanceUpdatable {
    
    /// A boolean value that indicates whether the appearance update can be animated.
    ///
    /// If the value is `false` then the appearance update is not animated.
    ///
    /// - Note: It's the default implementation of this property, so the value is always `true`.
    /// If you need to change the value then re-create this implementation in your own way.
    var prefersAppearanceUpdateToBeAnimated: Bool { true }
    
    /// Subscribes this view to appearance updates.
    ///
    /// You usually call this method during additional initialization or during setup.
    ///
    /// - Important: The compiler provides the implementation of this method using internal properties.
    /// If you replace this implementation, you won't be able to subscribe to updates.
    ///
    /// - Parameter needsUpdateAppearance: Specify `true` to update the appearance by getting the current theme,
    /// or `false` if you do not need the appearance to be updated. The default value is `true`.
    func subscribeToAppearanceUpdates(andGetCurrentTheme needsUpdateAppearance: Bool = true) -> Void {
        TFPublisher.shared.registerForAppearanceUpdates(self)
        if needsUpdateAppearance { setNeedsUpdateAppearance() }
    }
    
    /// Unsubscribes this view from appearance updates.
    ///
    /// Use this method when you clearly need to unsubscribe from appearance updates,
    /// for example, when a user custom edits the current theme in settings:
    /// picks new accent color (different from the standard), selects their own wallpaper, and so on.
    ///
    /// In other cases, you don't need to call this method, because the publisher automatically removes your subscription
    /// when this object is deleted.
    ///
    /// - Important: The compiler provides the implementation of this method using internal properties.
    /// If you replace this implementation, you won't be able to unsubscribe from updates.
    ///
    /// **Do not call this method during deinitialization because you can get the runtime failure.**
    func unsubscribeFromAppearanceUpdates() -> Void {
        TFPublisher.shared.releaseFromAppearanceUpdates(self)
    }
    
    /// Informs the publisher to update the appearance of this object.
    ///
    /// - Important: The compiler provides the implementation of this method using internal properties.
    /// If you replace this implementation, you won't be able to inform the publisher.
    func setNeedsUpdateAppearance() {
        TFPublisher.shared.updateAppearance(of: self)
    }
    
}


internal extension TFAppearanceUpdatable {
    
    /// The ID associated with this object.
    var objectID: TFPublisher.ObjectID? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.objectID) as? TFPublisher.ObjectID }
        set { objc_setAssociatedObject(self, &AssociatedKeys.objectID, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// Casts the given theme to the theme of this object, and calls the corresponding `updateAppearance(with:)` method.
    func internalUpdateAppearance(with newTheme: TFTheme) -> Void {
        guard let theme = newTheme as? Theme else { return }
        updateAppearance(with: theme)
    }
    
}



fileprivate enum AssociatedKeys {
    static var objectID = "com.themeful-object_id"
}
