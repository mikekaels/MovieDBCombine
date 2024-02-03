//
//  UIColor+Ext.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit

extension UIColor {
	internal static var prefixColors: [String] {
		return [
			"DC148C",
			"006450",
			"8400E7",
			"1E3264",
			"E8115B",
			"148A08",
			"E91429",
			"5179A1",
			"D84000",
			"BC5900",
			"777777",
			"8C67AC",
			"2D46BA",
			"4F374F"
		]
	}
	
	internal static func getRandomPrefixColor() -> String {
		return prefixColors.randomElement() ?? "DC148C"
	}
	
	internal convenience init(light: UIColor, dark: UIColor) {
		if #available(iOS 13.0, *) {
			self.init { (traitCollection) -> UIColor in
				traitCollection.userInterfaceStyle == .dark ? light : light
			}
		} else {
			self.init(cgColor: light.cgColor)
		}
	}
	
	public convenience init(hex: String) {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 1
		
		let hexColor = hex.replacingOccurrences(of: "#", with: "")
		let scanner = Scanner(string: hexColor)
		var hexNumber: UInt64 = 0
		var valid = false
		
		if scanner.scanHexInt64(&hexNumber) {
			if hexColor.count == 8 {
				r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
				g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
				b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
				a = CGFloat(hexNumber & 0x000000ff) / 255
				valid = true
			}
			else if hexColor.count == 6 {
				r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
				g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
				b = CGFloat(hexNumber & 0x0000ff) / 255
				valid = true
			}
		}
		
#if DEBUG
		assert(valid, "UIColor initialized with invalid hex string")
#endif
		
		self.init(red: r, green: g, blue: b, alpha: a)
	}
}


extension UIColor {
	/// blue-0 - F2F7FD
	public static let blue0 =
	UIColor(light: UIColor(hex: "F2F7FD"), dark: UIColor(hex: "F2F7FD"))
}

