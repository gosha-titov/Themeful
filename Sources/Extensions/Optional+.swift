internal extension Optional {
    
    // MARK: Properties
            
    /// A boolean value that indicates whether this optional object is `nil`.
    ///
    ///     var age: Int?
    ///     age.isNil // true
    ///
    var isNil: Bool { self == nil }
    
    /// A boolean value that indicates whether this optional object is not `nil`.
    ///
    ///     var name: String? = "gosha"
    ///     name.hasValue // true
    ///
    var hasValue: Bool { self != nil }
    
}
