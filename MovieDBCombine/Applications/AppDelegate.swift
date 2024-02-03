//
//  AppDelegate.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		customNavigationBar()
		return true
	}
	
	private func customNavigationBar() {
		UINavigationBar.appearance().backgroundColor = UIColor(hex: "1E1C1C")
		UINavigationBar.appearance().barTintColor = UIColor(hex: "1E1C1C")
		
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		
		UINavigationBar.appearance().tintColor = .white
		
		UINavigationBar.appearance().isTranslucent = true
		
		UINavigationBar.appearance().largeTitleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		
		UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -5000, vertical: 0), for: .default)
		UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

