//
//  SignatureImageCollectionViewCell.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 03/11/23.
//

import UIKit

class SignatureImageCollectionViewCell: UICollectionViewCell, Reusable {
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "expand_icon")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
