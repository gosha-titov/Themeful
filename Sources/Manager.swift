/// A manager that is responsible for managing themes and notifying subscribers about it.
open class TFManager<Theme> where Theme: TFTheme {
    
    // MARK: - Properties
    
    /// The current theme of the application, settable.
    ///
    /// When you set a new value for this property, it automatically updates appearances of subscribed objects,
    /// and saves the name of this new theme to `UserDefaults` as the current one.
    public final var currentTheme: Theme {
        willSet (newTheme) {
            TFPublisher.shared.updateCurrentTheme(with: newTheme)
            TFStorage.shared.saveNameOfCurrentTheme(newTheme.name)
        }
    }
    
    
    // MARK: - Methods
    
    /// Returns the current theme loaded from `UserDefaults`.
    public final func loadCurrentTheme() -> Theme? {
        guard let themeName = TFStorage.shared.loadNameOfCurrentTheme(),
              let theme = theme(by: themeName)
        else { return nil }
        return theme
    }
    
    /// Returns a specific theme associated with the given name.
    ///
    /// You should override this method in the following way:
    ///
    ///     override func theme(by name: String) -> Theme? {
    ///         switch name {
    ///         case "Light": return LightTheme()
    ///         case "Dark":  return DarkTheme()
    ///         case "Ocean": return OceanTheme()
    ///         default: return nil
    ///         }
    ///     }
    ///
    /// You don't need to call the `super` method.
    /// - Returns: The associated theme; otherwise, `nil`.
    open func theme(by name: String) -> Theme? {
        return nil
    }
    
    
    // MARK: - Init
    
    /// Creates a manager instance.
    /// - Parameter theme: The current theme of the application.
    public init(theme: Theme) {
        currentTheme = theme
    }
    
}
