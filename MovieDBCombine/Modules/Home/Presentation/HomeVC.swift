//
//  HomeVC.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

internal final class HomeVC: UIViewController {
	enum Section {
		case main
	}
	
	private let viewModel: HomeVM
	private let cancellables = CancelBag()
	private let didLoadPublisher = PassthroughSubject<Void, Never>()
	private let searchDidChangePublisher = PassthroughSubject<String, Never>()
	private let searchDidCancelPublisher = PassthroughSubject<Void, Never>()
	
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
		bindView()
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
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 330, totalColumn: 2))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		collection.register(HomeContentCell.self, forCellWithReuseIdentifier: HomeContentCell.identifier)
		collection.register(HomeContentShimmerCell.self, forCellWithReuseIdentifier: HomeContentShimmerCell.identifier)
		collection.register(HomeErrorCell.self, forCellWithReuseIdentifier: HomeErrorCell.identifier)
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Section, HomeVM.DataSourceType> = {
		let dataSource = UICollectionViewDiffableDataSource<Section, HomeVM.DataSourceType>(collectionView: collectionView) { [weak self] collectionView, indexPath, type in
			
			if case let .content(data) = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeContentCell.identifier, for: indexPath) as? HomeContentCell {
				cell.set(image: data.posterPath)
				cell.set(title: data.title)
				cell.set(year: data.year)
				return cell
			}
			
			if case .shimmer = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeContentShimmerCell.identifier, for: indexPath) as? HomeContentShimmerCell {
				return cell
			}
			
			if case let .error(image, title, desc, buttonTitle) = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeErrorCell.identifier, for: indexPath) as? HomeErrorCell {
				cell.set(image: image)
				cell.set(title: title)
				cell.set(description: desc)
				cell.set(buttonTitle: buttonTitle)
				
				cell.buttonDidTapPublisher
					.sink { [weak self] _ in
						self?.didLoadPublisher.send(())
					}
					.store(in: cell.cancellables)
				return cell
			}
			
			return UICollectionViewCell()
		}
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = HomeVM.Action(
			didLoad: didLoadPublisher,
			searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
			searchDidChange: searchDidChangePublisher
		)
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
		
		Publishers.CombineLatest(state.$column,  state.$cellHeight)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] (column, height) in
				self?.collectionView.collectionViewLayout = CustomColumnFlowLayout(height: height, totalColumn: CGFloat(column))
				self?.collectionView.reloadData()
			}
			.store(in: cancellables)
	}
	
	private func bindView() {
		collectionView.reachedBottomPublisher()
			.sink { [weak self] _ in
				self?.didLoadPublisher.send(())
			}
			.store(in: cancellables)
		
		searchController.searchBar.textDidChangePublisher
			.sink { [weak self] text in
				self?.searchDidChangePublisher.send(text)
			}
			.store(in: cancellables)
		
		searchController.searchBar.cancelButtonClickedPublisher
			.sink { [weak self] _ in
				self?.searchDidCancelPublisher.send(())
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
