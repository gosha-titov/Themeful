/// A publisher that is responsible for notifying about updates of the objects' appearance.
internal final class TFPublisher {
    
    // MARK: - Properties
    
    /// The singleton publisher instance.
    internal static let shared = TFPublisher()
    
    /// The current theme of the application.
    internal var currentTheme: TFTheme {
        didSet { updateAppearanceOfAllObjects() }
    }
    
    /// The dictionary of objects that are currently being tracked.
    private var trackedObjects = [ObjectID: WeakObject]()
    
    /// The ID that was last used.
    private var lastID: ObjectID = 0
    
    
    // MARK: - Registering and Releasing Methods
    
    /// Adds the given object to the tracked ones.
    /// - Returns: An ID associated with this object.
    internal final func registerForAppearanceUpdates(_ object: any Object) -> Void {
        let weakObject = WeakObject(object)
        let objectID = findAvailableID()
        trackedObjects[objectID] = weakObject
        object.objectID = objectID
    }
    
    /// Removes the given object from tracked ones.
    internal final func releaseFromAppearanceUpdates(_ object: any Object) -> Void {
        let ids = trackedObjects.filter { $0.value.reference === object }.keys
        for id in ids { releaseFromAppearanceUpdates(by: id) }
    }
    
    /// Removes a specific object from tracked ones by the given ID.
    internal final func releaseFromAppearanceUpdates(by id: ObjectID) -> Void {
        if let object = trackedObjects.removeValue(forKey: id)?.reference {
            object.objectID = nil
        }
    }
    
    
    // MARK: Updating Appearance Methods
    
    /// Updates appearances of all tracked objects by passing the current theme to them.
    internal func updateAppearanceOfAllObjects() -> Void {
        removeNilObjects()
        let objects = trackedObjects.compactMap { $0.value.reference }
        for object in objects {
            updateAppearance(of: object)
        }
    }
    
    /// Updates an appearance of the given object by passing the current theme to it.
    internal final func updateAppearance(of object: any Object) -> Void {
        object.internalUpdateAppearance(with: currentTheme)
    }
    
    
    // MARK: Other Methods
    
    /// Removes tracked objects that have `nil` references.
    private func removeNilObjects() -> Void {
        trackedObjects = trackedObjects.filter { $0.value.reference != nil }
    }
    
    /// Finds the nearest available ID, recursively.
    /// - Returns: An ID that can be used to add a new subscriber.
    private func findAvailableID() -> ObjectID {
        lastID += 1
        if let trackedObject = trackedObjects[lastID] {
            guard trackedObject.reference != nil else {
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
    
    /// The object that can update its appearance.
    internal typealias Object = TFAppearanceUpdatable
    
    /// The ID associated with a specific object.
    internal typealias ObjectID = Int
    
    /// The object that weakly references a specific `Object` instance.
    private struct WeakObject {
        weak var reference: (any Object)?
        init(_ reference: any Object) {
            self.reference = reference
        }
    }
    
}
