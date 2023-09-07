import UIKit

/// An animator that is responsible for animating appearance updates.
internal final class TFAnimator {
    
    /// The singleton animator instance.
    internal static let shared = TFAnimator()
    
    /// The total duration of the animations of appearance updates, measured in seconds.
    internal var animationDuration: CGFloat = 0.3
    
    /// A boolean value that indicates whether the appearance updates are animated.
    internal var animatesAppearanceUpdates: Bool = true
    
    /// Update appearance of the given object, animated.
    internal final func updateAppearance(of object: any TFObject, with theme: TFTheme) -> Void {
        if animatesAppearanceUpdates, object.prefersAppearanceUpdateToBeAnimated {
            UIView.animate(withDuration: animationDuration) {
                object.internalUpdateAppearance(with: theme)
            }
        } else {
            object.internalUpdateAppearance(with: theme)
        }
    }
    
    
    // MARK: - Init
    
    /// Creates an animator instance.
    private init() {
        TFManager.loadCurrentManager()
    }
    
}
