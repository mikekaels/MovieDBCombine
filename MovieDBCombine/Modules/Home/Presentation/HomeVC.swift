//
//  HomeVC.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit

internal final class HomeVC: UIViewController {
	private let viewModel: HomeVM
	private let cancellables = CancelBag()
	
	init(viewModel: HomeVM = HomeVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		bindViewModel()
	}
	
	private func bindViewModel() {
		let action = HomeVM.Action()
		let state = viewModel.transform(action, cancellables)
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
	}
}
