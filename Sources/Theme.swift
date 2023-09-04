/// A theme that provides appearance that UI elements adhere to.
///
/// A theme is a collection of UI attributes that form the appearance of the application.
/// It's commonly expressed with such attributes as:
/// - Colors: background colors, text colors, button colors, etc;
/// - Layout: widths, heights, paddings, margins, alignments, etc;
/// - Typography: fonts and their sizes;
/// - Images: icons, wallpapers, etc.
///
/// These attributes can be grouped into categories.
public protocol TFTheme: AnyObject {
    
    /// A string associated with the name of this theme.
    ///
    /// You usually name themes as follows: `Light`, `Dark`, `Ocean` or `Custom`.
    /// It's used to be stored in `UserDefaults`.
    /// - Important: The name must be unique.
    var name: String { get }
    
}



/// An empty theme without UI attributes that is ignored by UI elements.
internal final class TFEmptyTheme: TFTheme {
    
    /// A string associated with the name of this theme.
    ///
    /// This property has the "Empty" value.
    let name = "Empty"
    
}
