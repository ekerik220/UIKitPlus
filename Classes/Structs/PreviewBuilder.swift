#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

#if canImport(SwiftUI) && DEBUG
    @available(iOS 13.0, macOS 10.15, *)
    public class PreviewGroup {
        let previews: [Preview]
        var language: Language = Localization().detectCurrentLanguage()
        #if !os(macOS)
            var semanticContentAttribute: UISemanticContentAttribute = .unspecified
        #endif

@available(iOS 13.0, *)
@resultBuilder public struct PreviewBuilder {
    public typealias Block = () -> PreviewBuilderItem
    
    /// Builds an empty preview from an block containing no statements, `{ }`.
    public static func buildBlock() -> PreviewBuilderItem { [] }
    
    /// Passes a single preview written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
    public static func buildBlock(_ attrs: PreviewBuilderItem...) -> PreviewBuilderItem {
        buildBlock(attrs)
    }
    
    /// Passes a single preview written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
    public static func buildBlock(_ attrs: [PreviewBuilderItem]) -> PreviewBuilderItem {
        PreviewBuilderItems(items: attrs.flatMap { $0.previewBuilderItems })
    }
    
    /// Provides support for "if" statements in multi-statement closures, producing an `Optional` preview
    /// that is visible only when the `if` condition evaluates `true`.
    public static func buildIf(_ content: PreviewBuilderItem?) -> PreviewBuilderItem {
        guard let content = content else { return [] }
        return content
    }
    
    /// Provides support for "if" statements in multi-statement closures, producing
    /// ConditionalContent for the "then" branch.
    public static func buildEither(first: PreviewBuilderItem) -> PreviewBuilderItem {
        first
    }

    @available(iOS 13.0, macOS 10.15, *)
    @resultBuilder public enum PreviewBuilder {
        public typealias Block = () -> PreviewBuilderItem

        /// Builds an empty preview from an block containing no statements, `{ }`.
        public static func buildBlock() -> PreviewBuilderItem { [] }

        /// Passes a single preview written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
        public static func buildBlock(_ attrs: PreviewBuilderItem...) -> PreviewBuilderItem {
            buildBlock(attrs)
        }

        /// Passes a single preview written as a child view (e..g, `{ Text("Hello") }`) through unmodified.
        public static func buildBlock(_ attrs: [PreviewBuilderItem]) -> PreviewBuilderItem {
            PreviewBuilderItems(items: attrs.flatMap { $0.previewBuilderItems })
        }

        /// Provides support for "if" statements in multi-statement closures, producing an `Optional` preview
        /// that is visible only when the `if` condition evaluates `true`.
        public static func buildIf(_ content: PreviewBuilderItem?) -> PreviewBuilderItem {
            guard let content = content else { return [] }
            return content
        }

        /// Provides support for "if" statements in multi-statement closures, producing
        /// ConditionalContent for the "then" branch.
        public static func buildEither(first: PreviewBuilderItem) -> PreviewBuilderItem {
            first
        }

        /// Provides support for "if-else" statements in multi-statement closures, producing
        /// ConditionalContent for the "else" branch.
        public static func buildEither(second: PreviewBuilderItem) -> PreviewBuilderItem {
            second
        }
    }

    @available(iOS 13.0, macOS 10.15, *)
    extension Array: PreviewBuilderItem where Element: Preview {
        public var previewBuilderItems: [Preview] { self }
    }
#endif
