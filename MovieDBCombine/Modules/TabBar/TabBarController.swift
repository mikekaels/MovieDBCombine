//
//  TabBarController.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit

class TabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let listVC = HomeVC()
		listVC.tabBarItem = UITabBarItem(title: "Animals", image: UIImage(systemName: "pawprint.fill"), tag: 0)
		
		let favoriteVC = FavoriteVC()
		favoriteVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 0)
		
		//		let favoriteSwiftUI = UIHostingController(rootView: FavoriteView())
		//		favoriteSwiftUI.tabBarItem = UITabBarItem(title: "Favorites SwiftUI", image: UIImage(systemName: "heart.circle.fill"), tag: 0)
		
		self.viewControllers = [listVC, favoriteVC]
		customizeTabBarAppearance()
	}
	
	func customizeTabBarAppearance() {
		self.tabBar.isTranslucent = false
		self.view.bringSubviewToFront(self.tabBar)
		
		self.tabBar.tintColor = UIColor(hex: "FE1F44")
		
		self.tabBar.unselectedItemTintColor = UIColor.systemGray
		
		self.tabBar.barTintColor = UIColor(hex: "1E1C1C")
		
		self.tabBar.backgroundColor = UIColor(hex: "1E1C1C")
	}
}

