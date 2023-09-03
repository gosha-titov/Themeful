/// A UI element that can subscribe to appearance updates and, accordingly, can handle changes of the current theme.
public protocol TFAppearanceUpdatable: AnyObject {
    
    /// Called when the current theme has been changed by the user or system.
    func updateAppearance(_ newTheme: TFTheme) -> Void
    
    /// Subscribes this view to appearance updates.
    func subscribeToAppearanceUpdates() -> Void
    
    /// Unsubscribes this view from appearance updates.
    func unsubscribeFromAppearanceUpdates() -> Void
    
}
