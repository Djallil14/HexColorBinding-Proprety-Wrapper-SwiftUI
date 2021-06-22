//
//  HexColorPropretyWrapper + Extension + HexColor.swift
//  Melomania Proto without firebase
//
//  Created by Djallil Elkebir on 2021-06-22.
//

import SwiftUI

extension Color {
    
    init?(hexString: String) {
        let rgbaData = getrgbaData(hexString: hexString)
        if(rgbaData != nil){
            self.init(
                .sRGB,
                red:     Double(rgbaData!.r),
                green:   Double(rgbaData!.g),
                blue:    Double(rgbaData!.b),
                opacity: Double(rgbaData!.a)
            )
            return
        }
        return nil
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let rgbaData = getrgbaData(hexString: hexString)
        if(rgbaData != nil){
            self.init(
                red:   rgbaData!.r,
                green: rgbaData!.g,
                blue:  rgbaData!.b,
                alpha: rgbaData!.a)
            return
        }
        return nil
    }
    
}
private func getrgbaData(hexString: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
    
    var rgbaData : (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? = nil
    if hexString.hasPrefix("#") {
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...]) // Swift 4
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            
            rgbaData = { // start of a closure expression that returns the values
                switch hexColor.count {
                case 8:
                    return ( r: CGFloat((hexNumber & 0xff000000) >> 24) / 255,
                             g: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
                             b: CGFloat((hexNumber & 0x0000ff00) >> 8)  / 255,
                             a: CGFloat( hexNumber & 0x000000ff)        / 255
                    )
                case 6:
                    return ( r: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
                             g: CGFloat((hexNumber & 0x00ff00) >> 8)  / 255,
                             b: CGFloat((hexNumber & 0x0000ff))       / 255,
                             a: 1.0
                    )
                default:
                    return nil
                }
            }()
            
        }
    }
    return rgbaData
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

@propertyWrapper struct HexColorBinding: DynamicProperty {
    @State private var hexColor: String
    var wrappedValue: String {
        get {
            hexColor
        }
        set {
            hexColor = newValue
        }
    }
    var projectedValue: Binding<Color> {
        Binding(get: { Color(hexString:self.wrappedValue)! },
                                         set: {self.hexColor = UIColor($0).toHexString()})
    }
    init(_ hexColor: String){
        self.hexColor = hexColor
    }
}

