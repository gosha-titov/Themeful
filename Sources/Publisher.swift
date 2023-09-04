/// A publisher that is responsible for notifying about updates of the objects' appearance.
internal final class TFPublisher {
    
    // MARK: - Properties
    
    /// The singleton publisher instance.
    internal static let shared = TFPublisher()
    
    /// The current theme of the application.
    internal private(set) var currentTheme: TFTheme
    
    /// The dictionary of objects that are currently being tracked.
    private var trackedObjects = [ObjectID: WeakObject]()
    
    /// The ID that was last used.
    private var lastID: ObjectID = 0
    
    
    // MARK: - Registering and Releasing Methods
    
    /// Adds the given object to the tracked ones.
    internal final func registerForAppearanceUpdates(_ object: any TFObject) -> Void {
        guard object.objectID.isNil else { return }
        let weakObject = WeakObject(object)
        let objectID = findAvailableID()
        trackedObjects[objectID] = weakObject
        object.objectID = objectID
    }
    
    /// Removes the given object from the tracked ones.
    internal final func releaseFromAppearanceUpdates(_ object: any TFObject) -> Void {
        guard let objectID = object.objectID else { return }
        trackedObjects.removeValue(forKey: objectID)
        object.objectID = nil
    }
    
    
    // MARK: Updating Appearance Methods
    
    /// Updates the current theme of this publisher and its tracked objects.
    internal final func updateCurrentTheme(with newTheme: TFTheme) -> Void {
        currentTheme = newTheme
        updateAppearanceOfAllObjects()
    }
    
    /// Updates appearances of all tracked objects by passing the current theme to them.
    internal final func updateAppearanceOfAllObjects() -> Void {
        removeNilObjects()
        let objects = trackedObjects.compactMap { $0.value.reference }
        for object in objects {
            updateAppearance(of: object)
        }
    }
    
    /// Updates an appearance of the given object by passing the current theme to it.
    internal final func updateAppearance(of object: any TFObject) -> Void {
        TFAnimator.shared.updateAppearance(of: object, with: currentTheme)
    }
    
    
    // MARK: Other Methods
    
    /// Removes tracked objects that have `nil` references.
    private func removeNilObjects() -> Void {
        trackedObjects = trackedObjects.filter { $0.value.reference.hasValue }
    }
    
    /// Finds the nearest available ID, recursively.
    /// - Returns: An ID that can be used to add a new subscriber.
    private func findAvailableID() -> ObjectID {
        lastID += 1
        if let trackedObject = trackedObjects[lastID] {
            guard trackedObject.reference.hasValue else {
                removeNilObjects()
                return lastID
            }
            return findAvailableID()
        } else {
            return lastID
        }
    }
    
    
    // MARK: - Init
    
    /// Creates a publisher instance.
    private init() {
        currentTheme = TFEmptyTheme()
    }
    
}


extension TFPublisher {
    
    /// The ID associated with a specific object.
    internal typealias ObjectID = Int
    
    /// The object that weakly references a specific `TFObject` instance.
    private struct WeakObject {
        weak var reference: (any TFObject)?
        init(_ reference: any TFObject) {
            self.reference = reference
        }
    }
    
}
