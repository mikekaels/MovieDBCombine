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
		label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		label.numberOfLines = 0
		label.textAlignment = .right
		label.textColor = .white
		
		label.layer.shadowColor = UIColor.black.cgColor
		label.layer.shadowRadius = 1.0
		label.layer.shadowOpacity = 0.2
		label.layer.shadowOffset = CGSize(width: 2, height: 2)
		label.layer.masksToBounds = false
		return label
	}()
	
	private let imageContainerView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 5
		view.layer.cornerRadius = 8.0
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 2)
		view.layer.shadowOpacity = 0.5
		view.layer.shadowRadius = 4.0
		view.layer.masksToBounds = false
		
		view.transform = CGAffineTransform(rotationAngle: 20 * .pi / 180)
		return view
	}()
	
	private let imageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.layer.cornerRadius = 10
		image.layer.masksToBounds = true
		return image
	}()
	
	private func setupView() {
		
		contentView.addSubview(cardView)
		
		cardView.snp.makeConstraints { make in
			make.height.equalToSuperview().offset(-15)
			make.width.equalToSuperview().offset(-15)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
		
		[imageContainerView, ].forEach { cardView.addSubview($0) }
		contentView.addSubview(contentTitleLabel)
		
		imageContainerView.snp.makeConstraints { make in
			make.height.equalTo(110)
			make.width.equalTo(140)
			make.left.equalToSuperview().offset(-20)
			make.bottom.equalToSuperview().offset(15)
		}
		
		contentTitleLabel.snp.makeConstraints { make in
			make.right.equalTo(cardView).offset(-10)
			make.left.equalTo(cardView).offset(10)
			make.top.equalTo(cardView).offset(10)
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
			self.imageView.kf.setImage(with: url, options: [
				.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 70))),
				.scaleFactor(UIScreen.main.scale),
				.forceRefresh,
				.transition(.flipFromBottom(0.8))
			])
		}
	}
	
	internal func set(title: String) {
		self.contentTitleLabel.text = title
	}
	
	internal func set(backgroundColor: String) {
		self.cardView.backgroundColor = UIColor(hex: backgroundColor)
	}
}

