//
//  Menu.swift
//  UIKit-Plus
//
//  Created by Mihael Isaev on 13.08.2020.
//

#if os(macOS)
    import Cocoa

    public class Menu: NSObject, NSMenuDelegate {
        public let menu: NSMenu
        var items: [MenuItem] = []

        public init(_ menu: NSMenu) {
            self.menu = menu
            super.init()
            self.menu.delegate = self
        }

        override public init() {
            menu = .init(title: "")
            super.init()
            menu.delegate = self
        }

        public init(_ title: String? = nil, @MenuBuilder content: @escaping MenuBuilder.Block) {
            menu = .init(title: title ?? "")
            super.init()
            menu.delegate = self
            menu.cancelTracking()
            parseMenuBuilder(content().menuBuilderContent)
        }

        func parseMenuBuilder(_ item: MenuBuilderItem) {
            switch item {
            case let .menuItems(items):
                self.items.append(contentsOf: items)
                items.forEach { menu.addItem($0.item) }
            case let .items(items): items.forEach { parseMenuBuilder($0) }
            case .none: break
            }
        }

        @available(*, deprecated, message: "Please use `dismiss()`")
        public func cancelTracking() {
            menu.cancelTracking()
        }

        @available(*, deprecated, message: "Please use `dismiss()`")
        public func cancelTrackingWithoutAnimation() {
            menu.cancelTrackingWithoutAnimation()
        }

        public func dismiss(_ animated: Bool = true) {
            guard animated else {
                menu.cancelTrackingWithoutAnimation()
                return
            }
            menu.cancelTracking()
        }

    
    /// Determines the layout direction for menu items in the menu.
    /// If no layout direction is explicitly set, the menu will default to the value of [NSApp userInterfaceLayoutDirection].
    public func userInterfaceLayoutDirection(_ value: NSUserInterfaceLayoutDirection) -> Self {
        menu.userInterfaceLayoutDirection = value
        return self
    }
}

public protocol MenuBuilderContent {
    var menuBuilderContent: MenuBuilderItem { get }
}

public enum MenuBuilderItem {
    case none
    case menuItems([MenuItem])
    case items([MenuBuilderItem])
}

struct _MenuContent: MenuBuilderContent {
    let menuBuilderContent: MenuBuilderItem
}

@resultBuilder public struct MenuBuilder {
    public typealias Block = () -> MenuBuilderContent
    
    public static func buildBlock() -> MenuBuilderContent {
        _MenuContent(menuBuilderContent: .none)
    }
    
    public static func buildBlock(_ attrs: MenuBuilderContent...) -> MenuBuilderContent {
        buildBlock(attrs)
    }

    public protocol MenuBuilderContent {
        var menuBuilderContent: MenuBuilderItem { get }
    }

    public enum MenuBuilderItem {
        case none
        case menuItems([MenuItem])
        case items([MenuBuilderItem])
    }

    struct _MenuContent: MenuBuilderContent {
        let menuBuilderContent: MenuBuilderItem
    }

    @resultBuilder public enum MenuBuilder {
        public typealias Block = () -> MenuBuilderContent

        public static func buildBlock() -> MenuBuilderContent {
            _MenuContent(menuBuilderContent: .none)
        }

        public static func buildBlock(_ attrs: MenuBuilderContent...) -> MenuBuilderContent {
            buildBlock(attrs)
        }

        public static func buildBlock(_ attrs: [MenuBuilderContent]) -> MenuBuilderContent {
            _MenuContent(menuBuilderContent: .items(attrs.map { $0.menuBuilderContent }))
        }

        public static func buildIf(_ content: MenuBuilderContent?) -> MenuBuilderContent {
            guard let content = content else { return _MenuContent(menuBuilderContent: .none) }
            return _MenuContent(menuBuilderContent: .items([content.menuBuilderContent]))
        }

        public static func buildEither(first: MenuBuilderContent) -> MenuBuilderContent {
            _MenuContent(menuBuilderContent: .items([first.menuBuilderContent]))
        }

        public static func buildEither(second: MenuBuilderContent) -> MenuBuilderContent {
            _MenuContent(menuBuilderContent: .items([second.menuBuilderContent]))
        }
    }
#endif
