//
//  HomeContentCell.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import UIKit
import Kingfisher
import SnapKit
import Combine

internal final class HomeContentCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	private let cardView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 5
		view.layer.masksToBounds = true
		return view
	}()
	
	private let contentTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.textAlignment = .left
		label.textColor = .white
		return label
	}()
	
	private let yearLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
		label.numberOfLines = 1
		label.textAlignment = .left
		label.textColor = .white.withAlphaComponent(0.6)
		return label
	}()
	
	private let imageContainerView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 3
		view.layer.masksToBounds = false
		return view
	}()
	
	private let imageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	private let overlayView: UIView = {
		let view = UIView()
		view.backgroundColor = .black.withAlphaComponent(0.3)
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
		
		[imageContainerView].forEach { cardView.addSubview($0) }
		contentView.addSubview(contentTitleLabel)
		contentView.addSubview(yearLabel)
		
		imageContainerView.snp.makeConstraints { make in
			make.width.equalToSuperview()
			make.height.equalToSuperview().offset(-50)
			make.centerX.equalToSuperview()
			make.top.equalToSuperview()
		}
		
		contentTitleLabel.snp.makeConstraints { make in
			make.right.equalTo(cardView)
			make.left.equalTo(cardView)
			make.top.equalTo(imageContainerView.snp.bottom).offset(10)
		}
		
		yearLabel.snp.makeConstraints { make in
			make.right.equalTo(cardView)
			make.left.equalTo(cardView)
			make.top.equalTo(contentTitleLabel.snp.bottom).offset(5)
		}
		
		imageContainerView.addSubview(imageView)
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension HomeContentCell {
	internal func set(image: String) {
		if let url = URL(string: image) {
			self.imageView.kf.setImage(with: url)
		}
	}
	
	internal func set(title: String) {
		self.contentTitleLabel.text = title
	}
	
	internal func set(year: String) {
		self.yearLabel.text = year
	}
}

