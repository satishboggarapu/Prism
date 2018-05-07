//
// Created by Satish Boggarapu on 5/3/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

public struct SourceSansFont: FontType {
    /// Size of font.
    public static var pointSize: CGFloat {
        return Font.pointSize
    }

    /// Thin font.
    public static var thin: UIFont {
        return black(with: Font.pointSize)
    }

    /// Light font.
    public static var light: UIFont {
        return blackItalic(with: Font.pointSize)
    }

    /// Regular font.
    public static var regular: UIFont {
        return bold(with: Font.pointSize)
    }

    /// Medium font.
    public static var medium: UIFont {
        return boldItalic(with: Font.pointSize)
    }

    /// Bold font.
    public static var bold: UIFont {
        return bold(with: Font.pointSize)
    }

    /**
     Black with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func black(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-Black")

        if let f = UIFont(name: "SourceSansPro-Black", size: size) {
            return f
        }

        return Font.systemFont(ofSize: size)
    }

    /**
     BlackItalic with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func blackItalic(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-BlackItalic")

        if let f = UIFont(name: "SourceSansPro-BlackItalic", size: size) {
            return f
        }

        return Font.systemFont(ofSize: size)
    }

    /**
     Bold with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func bold(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-Bold")

        if let f = UIFont(name: "SourceSansPro-Bold", size: size) {
            return f
        }

        return Font.systemFont(ofSize: size)
    }

    /**
     BoldItalic with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func boldItalic(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-BoldItalic")

        if let f = UIFont(name: "SourceSansPro-BoldItalic", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     ExtraLight with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func extraLight(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-ExtraLight")

        if let f = UIFont(name: "SourceSansPro-ExtraLight", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     ExtraLightItalic with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func extraLightItalic(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-ExtraLightItalic")

        if let f = UIFont(name: "SourceSansPro-ExtraLightItalic", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     Italic with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func italic(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-Italic")

        if let f = UIFont(name: "SourceSansPro-Italic", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     Light with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func light(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-Light")

        if let f = UIFont(name: "SourceSansPro-Light", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     LightItalic with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func lightItalic(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-LightItalic")

        if let f = UIFont(name: "SourceSansPro-LightItalic", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     Regular with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func regular(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-Regular")

        if let f = UIFont(name: "SourceSansPro-Regular", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     SemiBold with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func semiBold(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-SemiBold")

        if let f = UIFont(name: "SourceSansPro-SemiBold", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

    /**
     SemiBoldItalic with size font.
     - Parameter with size: A CGFloat for the font size.
     - Returns: A UIFont.
     */
    public static func semiBoldItalic(with size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "SourceSansPro-SemiBoldItalic")

        if let f = UIFont(name: "SourceSansPro-SemiBoldItalic", size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }

}