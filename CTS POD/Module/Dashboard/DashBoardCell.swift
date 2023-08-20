//
//  DashBoardCell.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import UIKit

class DashBoardCell: UICollectionViewCell, Reusable {
    
    private lazy var iconImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Colors.colorPrimary
        return view
    }()
    
    private lazy var containerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconImage, titleLabel])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 5
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        containerView.addSubview(containerStack)
        containerStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        iconImage.snp.makeConstraints { $0.height.width.equalTo(70) }
    }
    
   public var dashboardDisplayModel: DashboardDisplayModel? {
        didSet {
            guard let dashboardDisplayModel else {return}
            iconImage.image = dashboardDisplayModel.icon
            titleLabel.text = dashboardDisplayModel.title
            containerView.backgroundColor = dashboardDisplayModel.backgroundColor
        }
    }
}

