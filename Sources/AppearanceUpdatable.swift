/// A UI element that can subscribe to appearance updates and, accordingly, can handle changes of the current theme.
public protocol TFAppearanceUpdatable: AnyObject {
    
    /// A custom theme that provides appearance that UI elements adhere to.
    associatedtype Theme: TFTheme
    
    /// A boolean value that indicates whether the appearance update can be animated.
    ///
    /// If the value is `false` then the appearance update will never be animated.
    var prefersAppearanceUpdateToBeAnimated: Bool { get }
    
    /// Called when the current theme has been changed by user or system.
    ///
    /// - Important: In order to handle changes of the current theme, this object should be subscribed to appearance updates.
    /// If you haven't done it yet, then call the `subscribeToAppearanceUpdates(withGettingCurrentTheme:)` method.
    ///
    /// - Note: You can manually update appearance by calling the `setNeedsUpdateAppearance()` method.
    func updateAppearance(with theme: Theme) -> Void
    
}


public extension TFAppearanceUpdatable {
    
    /// A boolean value that indicates whether the appearance update can be animated.
    ///
    /// If the value is `false` then the appearance update will never be animated.
    ///
    /// - Note: It's the default implementation of this property, so the value is always `true`.
    /// If you need to change the value then re-create an implementation in your own way.
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
    func subscribeToAppearanceUpdates(withGettingCurrentTheme needsUpdateAppearance: Bool = true) -> Void {
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
    
    /// Casts the given theme to the theme of this object, and calls the corresponding `updateAppearance(with:)` method.
    func internalUpdateAppearance(with newTheme: TFTheme) -> Void {
        guard let theme = newTheme as? Theme else { return }
        updateAppearance(with: theme)
    }
    
}
