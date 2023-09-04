import Foundation

/// A storage that is responsible for managing the current theme in `UserDefaults`.
internal final class TFStorage {
    
    // MARK: - Properties
    
    /// The singleton storage instance.
    internal static let shared = TFStorage()
    
    /// The shared defaults objects.
    private let defaults = UserDefaults.standard
    
    
    // MARK: - Methods
    
    /// Saves the given name in `UserDefaults` as the name of the current theme.
    internal final func saveNameForCurrentTheme(_ themeName: String) -> Void {
        defaults.set(themeName, forKey: AssociatedKeys.themeName)
    }
    
    /// Loads the name of the current theme from `UserDefaults`.
    internal final func loadNameOfCurrentTheme() -> String? {
        return defaults.string(forKey: AssociatedKeys.themeName)
    }
    
    
    // MARK: - Init
    
    /// Creates a storage instance.
    private init() {}
    
}


extension TFStorage {
    
    private enum AssociatedKeys {
        static let themeName = "com.themeful-current_theme_name"
    }
    
}
