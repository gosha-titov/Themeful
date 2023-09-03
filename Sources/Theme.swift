/// A theme that provides appearance that UI elements adhere to.
///
/// A theme is a collection of UI attributes that form the appearance of the application.
/// They are commonly expressed with such attributes as:
/// - Colors: background colors, text colors, button colors, etc;
/// - Layout: width, height, padding, margin, alignment, etc;
/// - Typography: fonts and their sizes;
/// - Icons: button images, etc;
///
/// These attributes can be grouped into categories.
public protocol TFTheme: AnyObject {
    
    /// A string value associated with this theme.
    var name: String { get }
    
}
