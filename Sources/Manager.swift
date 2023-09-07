import Foundation

/// A manager that is responsible for managing themes and notifying subscribers about it.
///
/// The `TFManager` class defines the behavior to manage the current theme of your application.
/// That is, it's responsible for managing subscriptions, storing the current theme, and updating appearances.
///
/// You always define a new class that subclasses the `TFManager` class and override `createTheme(by:)` and `createDefaultTheme()` methods
/// (in order for the current theme to be saved-to or loaded-from `UserDefaults`) as in the following example:
///
///     final class ThemeManager: TFManager {
///
///         static let shared = ThemeManager()
///
///         override class func getCurrentManager() -> TFManager? {
///             return shared
///         }
///
///         func changeCurrentTheme(to themeOption: ThemeOption) -> Void {
///             let newTheme: Theme
///             switch themeOption {
///             case .light: newTheme = LightTheme()
///             case .dark:  newTheme = DarkTheme()
///             case .ocean: newTheme = OceanTheme()
///             }
///             currentTheme = newTheme
///         }
///
///         override func createTheme(by themeName: String) -> TFTheme? {
///             switch themeName {
///             case "Light": return LightTheme()
///             case "Dark":  return DarkTheme()
///             case "Ocean": return OceanTheme()
///             default: return nil
///             }
///         }
///
///         override func createDefaultTheme() -> TFTheme {
///             return LightTheme()
///         }
///
///     }
///
/// Note that to update appearances of all subscribed objects, you just need to set a new value for the `currentTheme` property.
///
/// Also note that you need to override the `getCurrentManager()` class method, because it makes work easier.
///
/// And in order to change the duration of animations or disable them,
/// use the corresponding `animationDuration` and `animatesAppearanceUpdates` properties.
open class TFManager {
    
    // MARK: - Properties
    
    /// The current theme of the application, settable.
    ///
    /// When you set a new value for this property, it automatically updates appearances of subscribed objects,
    /// and saves the name of this new theme to `UserDefaults` as the current one.
    public final var currentTheme: TFTheme {
        get { return publisher.currentTheme }
        set(newTheme) {
            publisher.updateCurrentTheme(with: newTheme)
            storage.saveNameForCurrentTheme(newTheme.name)
        }
    }
    
    /// The total duration of the animations of appearance updates, measured in seconds.
    public final var animationDuration: CGFloat {
        get { return animator.animationDuration }
        set { animator.animationDuration = newValue }
    }
    
    /// A boolean value that indicates whether the appearance updates are animated.
    ///
    /// If the value is `false` then the appearance updates are not animated.
    public final var animatesAppearanceUpdates: Bool {
        get { return animator.animatesAppearanceUpdates }
        set { animator.animatesAppearanceUpdates = newValue }
    }
    
    private let publisher = TFPublisher.shared
    private let animator = TFAnimator.shared
    private let storage = TFStorage.shared
    
    
    // MARK: - Methods
    
    /// Returns a manager that is currently in use; otherwise, `nil`.
    ///
    /// This method allows you to load your static instance into memory in advance, since static properties are lazy.
    ///
    ///     override class func getCurrentManager() -> TFManager? {
    ///         return shared
    ///     }
    ///
    /// Otherwise, you need to somehow load your static instance by yourself, for example:
    ///
    ///     let _ = ThemeManager.shared
    ///
    open class func getCurrentManager() -> TFManager? {
        return nil
    }
    
    /// Returns a specific theme associated with the given name.
    ///
    /// This method is used to restore a theme of the last session.
    /// That is, the manager loads the name of the current theme from `UserDefaults`,
    /// and then create a theme associated with this name.
    ///
    /// You should override this method in the following way:
    ///
    ///     override func createTheme(by themeName: String) -> TFTheme? {
    ///         switch themeName {
    ///         case "Light": return Theme.light
    ///         case "Dark":  return Theme.dark
    ///         case "Ocean": return Theme.ocean
    ///         default: return nil
    ///         }
    ///     }
    ///
    /// You don't need to call the `super` method.
    /// - Returns: The associated theme; otherwise, `nil`.
    open func createTheme(by themeName: String) -> TFTheme? {
        return nil
    }
    
    /// Returns a created default theme.
    ///
    /// This method is used when the manager could not restore a theme from the last session.
    /// That is, it creates a default theme and use it as the current one.
    ///
    /// You should override this method in the following way:
    ///
    ///     override createDefaultTheme() -> TFTheme {
    ///         return Theme.light
    ///     }
    ///
    /// You don't need to call the `super` method.
    /// - Returns: The default theme.
    open func createDefaultTheme() -> TFTheme {
        return TFEmptyTheme()
    }
    
    /// Loads the current manager into memory.
    internal static func loadCurrentManager() -> Void {
        let _ = getCurrentManager()
    }
    
    /// Returns the current theme loaded from `UserDefaults`.
    internal final func loadCurrentTheme() -> TFTheme? {
        guard let themeName = storage.loadNameOfCurrentTheme(),
              let theme = createTheme(by: themeName)
        else { return nil }
        return theme
    }
    
    
    // MARK: - Init
    
    /// Creates a manager instance by loading a current theme from `UserDefaults`, or (if it does not exist) creating a default theme.
    public init() {
        if let loadedTheme = loadCurrentTheme() {
            currentTheme = loadedTheme
        } else {
            currentTheme = createDefaultTheme()
        }
    }
    
}
