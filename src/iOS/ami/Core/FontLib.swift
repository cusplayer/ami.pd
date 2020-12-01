//
//  FontLib.swift
//  DesignKit
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import SwiftUI
import UIKit

public enum FontLib {
    case bloggerSans
    case bloggerSansMedium
    
    public func font(size: CGFloat) -> Font {
        var name = ""
        switch self {
        case .bloggerSans: name = "BloggerSans"
        case .bloggerSansMedium: name = "BloggerSans-Medium"
        }
        return Font.custom(name, size: size)
    }
    
    public static func printFonts() {
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print("\(fontName)")
            }
        }
    }
}
