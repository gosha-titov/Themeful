/// A publisher that is responsible for notifying about updates of the objects' appearance.
internal final class TFPublisher {
    
    /// The singleton publisher instance.
    internal static let shared = TFPublisher()
    
    /// The current theme of the application.
    var currentTheme: TFTheme
    
    
    // MARK: - Init
    
    /// Creates a publisher instance.
    private init() {
        currentTheme = TFEmptyTheme()
    }
    
}
