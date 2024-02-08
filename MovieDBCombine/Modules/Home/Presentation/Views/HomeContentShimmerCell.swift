//
//  HomeContentShimmerCell.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 08/02/24.
//

import UIKit
import Kingfisher
import SnapKit
import Combine
import SkeletonView

internal final class HomeContentShimmerCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	private let cardView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 5
		view.layer.masksToBounds = true
		view.isSkeletonable = true
		
		return view
	}()
	
	private func setupView() {
		
		contentView.addSubview(cardView)
		
		cardView.snp.makeConstraints { make in
			make.height.equalToSuperview().offset(-15)
			make.width.equalToSuperview().offset(-15)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
		DispatchQueue.main.async { [weak self] in
			self?.cardView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkGray))
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
