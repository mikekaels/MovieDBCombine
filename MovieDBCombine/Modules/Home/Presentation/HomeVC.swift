//
//  HomeVC.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit
import SnapKit
import Combine

internal final class HomeVC: UIViewController {
	enum Section {
		case main
	}
	
	private let viewModel: HomeVM
	private let cancellables = CancelBag()
	private let didLoadPublisher = PassthroughSubject<Void, Never>()
	
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
		setupNavBar()
		didLoadPublisher.send(())
	}
	
	private lazy var searchController: UISearchController = {
		let sc = UISearchController(searchResultsController: nil)
		sc.obscuresBackgroundDuringPresentation = false
		sc.searchBar.autocapitalizationType = .words
		sc.obscuresBackgroundDuringPresentation = false
		sc.searchBar.placeholder = "Search"
		sc.searchBar.barStyle = .black
		
		return sc
	}()
	
	private let collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 260, totalColumn: 2))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		collection.register(HomeContentCell.self, forCellWithReuseIdentifier: HomeContentCell.identifier)
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Section, HomeVM.DataSourceType> = {
		let dataSource = UICollectionViewDiffableDataSource<Section, HomeVM.DataSourceType>(collectionView: collectionView) { [weak self] collectionView, indexPath, type in
			guard let self = self else { return UICollectionViewCell() }
			
			if case let .content(data) = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeContentCell.identifier, for: indexPath) as? HomeContentCell {
//				cell.set(image: data.image)
				cell.set(title: data.title)
//				cell.set(backgroundColor: data.color)
				return cell
			}
			
			return UICollectionViewCell()
		}
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = HomeVM.Action(didLoad: didLoadPublisher)
		let state = viewModel.transform(action, cancellables)
		
		state.$dataSources
			.receive(on: DispatchQueue.main)
			.sink { [weak self] contents in
				guard let self = self else { return }
				var snapshoot = NSDiffableDataSourceSnapshot<Section, HomeVM.DataSourceType>()
				snapshoot.appendSections([.main])
				snapshoot.appendItems(contents, toSection: .main)
				self.dataSource.apply(snapshoot, animatingDifferences: true)
			}
			.store(in: cancellables)
		
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	private func setupNavBar() {
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
		navigationItem.searchController = searchController
		navigationController?.navigationBar.prefersLargeTitles = false
	}
}
