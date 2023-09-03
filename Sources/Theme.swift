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
    /// You usually name themes as follows: `Light`, `Dark`, `Sunrise`, `Sunset` or `Custom`.
    /// It's used, for example, when you need to display a list of available themes; or for debugging / logging.
    var name: String { get }
    
}
