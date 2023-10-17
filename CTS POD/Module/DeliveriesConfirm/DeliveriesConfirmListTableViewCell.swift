//
//  DeliveriesConfirmListTableViewCell.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 07/10/23.
//

import UIKit
import SnapKit

class DeliveriesConfirmListTableViewCell: UITableViewCell, Reusable {

    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.text = "North Shore Plumbing Group Construction"
        view.numberOfLines = 0
        return view
    }()

    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.text = "97099940-MILPERRA"
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var expandCollapseIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var checkBoxIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var dataView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpHeaderView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHeaderView() {
        self.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        headerView.addSubview(expandCollapseIcon)
        expandCollapseIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
        }
        
        headerView.addSubview(checkBoxIcon)
        checkBoxIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(expandCollapseIcon.snp.trailing).offset(10)
            make.top.equalTo(expandCollapseIcon.snp.top)
            make.trailing.equalTo(checkBoxIcon.snp.leading)
        }
        
        headerView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(dataView)
        dataView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.leading.equalTo(headerView.snp.leading).inset(10)
            make.trailing.equalTo(headerView.snp.trailing).inset(10)
            make.bottom.equalToSuperview()
        }
        
        dataView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for _ in 0...2 {
            let view = RowView(title: "test", icon: UIImage(named: "icn_radio_on")!)
            stackView.addArrangedSubview(view)
        }
    }
}


class RowView: UIView {
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.text = "North Shore Plumbing Group Construction"
        view.numberOfLines = 0
        return view
    }()
    
    init(title: String,icon: UIImage) {
        super.init(frame: .zero)
        setUpView()
        self.titleLabel.text = title
        self.icon.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing)
        }
    }
}
