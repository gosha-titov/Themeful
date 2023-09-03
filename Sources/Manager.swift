/// A manager that is responsible for managing themes and notifying subscribers about it.
open class TFManager<Theme: TFTheme> {
    
    /// The current theme of the application.
    public final var currentTheme: Theme {
        didSet {
            // notifying
        }
    }
    
    
    // MARK: - Init
    
    /// Creates a manager instance.
    /// - Parameter theme: The current theme of the application.
    public init(theme: Theme) {
        currentTheme = theme
    }
    
}
