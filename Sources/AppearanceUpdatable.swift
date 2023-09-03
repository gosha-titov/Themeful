import Foundation

/// A UI element that can subscribe to appearance updates and, accordingly, can handle changes of the current theme.
public protocol TFAppearanceUpdatable: AnyObject {
    
    /// A custom theme that provides appearance that UI elements adhere to.
    associatedtype Theme: TFTheme
    
    /// Called when the current theme has been changed by user or system.
    /// - Important: In order to handle changes of the current theme, this object should be subscribed to appearance updates.
    /// If you haven't done it yet, then call the `subscribeToAppearanceUpdates(withGettingCurrentTheme:)` method.
    /// - Note: You can manually update appearance by calling the `setNeedsUpdateAppearance()` method.
    func updateAppearance(with theme: Theme) -> Void
    
}


public extension TFAppearanceUpdatable {
    
    /// Subscribes this view to appearance updates.
    /// - Important: The compiler provides the implementation of this property using internal properties.
    /// If you replace this implementation, you won't be able to subscribe to updates.
    /// - Parameter needsUpdateAppearance: Specify `true` to update the appearance by getting the current theme,
    /// or `false` if you do not need the appearance to be updated. The default value is `true`.
    func subscribeToAppearanceUpdates(withGettingCurrentTheme needsUpdateAppearance: Bool = true) -> Void {
        TFPublisher.shared.registerForAppearanceUpdates(self)
        if needsUpdateAppearance { setNeedsUpdateAppearance() }
    }
    
    /// Unsubscribes this view from appearance updates.
    /// - Important: The compiler provides the implementation of this property using internal properties.
    /// If you replace this implementation, you won't be able to unsubscribe from updates.
    func unsubscribeFromAppearanceUpdates() -> Void {
        guard let objectID else { return }
        TFPublisher.shared.releaseFromAppearanceUpdates(by: objectID)
    }
    
    /// Informs the publisher to update the appearance of this object.
    /// - Important: The compiler provides the implementation of this property using internal properties.
    /// If you replace this implementation, you won't be able to inform the publisher.
    func setNeedsUpdateAppearance() {
        TFPublisher.shared.updateAppearance(of: self)
    }
    
}


internal extension TFAppearanceUpdatable {
    
    /// The ID associated with this object.
    var objectID: TFPublisher.ObjectID? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.objectID) as? TFPublisher.ObjectID
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.objectID, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Casts the given theme to the theme of this object, and calls the corresponding `updateAppearance(with:)` method.
    ///
    /// Unfortunately, there's no way to do something like this:
    ///
    ///     open class TFManager<Theme> where Theme: TFTheme {
    ///
    ///         public typealias Object = TFAppearanceUpdatable where Object.Theme == Theme
    ///         // or
    ///         public typealias Object = TFAppearanceUpdatable<Theme>
    ///
    ///         ...
    ///
    ///         private func updateAppearance(of object: Object) -> Void {
    ///             object.updateAppearance(with: currentTheme)
    ///         }
    ///
    ///     }
    ///
    /// So, the publisher must use this intermediate method.
    func internalUpdateAppearance(with newTheme: TFTheme) -> Void {
        guard let theme = newTheme as? Theme else { return }
        updateAppearance(with: theme)
    }
    
}


fileprivate enum AssociatedKeys {
    static var objectID = "themeful-objectid_associatedkey"
}
