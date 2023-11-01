//
//  MyDeliveriesListTableViewCell.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 01/11/23.
//

import UIKit

class MyDeliveriesListTableViewCell: UITableViewCell, Reusable {
    
    var isExpand: Bool = false {
        didSet {
            expandCollapseCell()
        }
    }
    
    var job: Job? {
        didSet {
            updateValue()
            manageETAButton()
        }
    }
    
    var jobModel: JobDisplayModel? {
        didSet {
            job = jobModel?.job
        }
    }
    
    var didTapCheckbox: ((_ index: Int) -> ())?
    
    private func updateValue() {
        guard let job else { return }
        titleLabel.text = job.cmpName
        subTitleLabel.text = job.titleAddress
        
        locationRow.titleLabel.text = job.locationAddress
        messageRow.titleLabel.text = job.comments
        callRow.titleLabel.text = job.orderNumber
                
        checkBoxIcon.setImage((jobModel?.isSelected ?? false) ? UIImage(named: "check_mark") : UIImage(named: "check_empty"), for: .normal)
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
        
    private lazy var expandCollapseIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "expand_icon")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var etaButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorBlue
        view.titleLabel?.textColor = UIColor.white
        view.setTitle("ETA", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = Fonts.popRegularSmall
        return view
    }()
    
    private lazy var checkBoxIcon: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "check_empty"), for: .normal)
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(checkBoxDidTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var titleContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()
    
    private lazy var headerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [expandCollapseIcon, titleContainer, etaButton, checkBoxIcon])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var dataView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var dataStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 5
        return view
    }()
    
    private lazy var actionButtonView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [callButton, navButton, pdfButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = 10
        return view
    }()
    
    private lazy var callButton: ActionButtonView = {
        let view = ActionButtonView(title: "call", image: UIImage(named: "action_call")!, viewColor: Colors.colorPrimary)
        view.tappedButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var navButton: ActionButtonView = {
        let view = ActionButtonView(title: "Nav", image: UIImage(named: "action_location")!, viewColor: Colors.colorBlue)
        view.tappedButton.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var pdfButton: ActionButtonView = {
        let view = ActionButtonView(title: nil, image: UIImage(named: "action_pdf")!, viewColor: Colors.colororagne)
        view.tappedButton.addTarget(self, action: #selector(pdfButtonTapped), for: .touchUpInside)
        return view
    }()
    
    
    private lazy var containerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var locationRow: RowView = {
        let view = RowView()
        view.icon.image = UIImage(named: "job_location")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var callRow: RowView = {
        let view = RowView()
        view.icon.image = UIImage(named: "job_call")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageRow: RowView = {
        let view = RowView()
        view.icon.image = UIImage(named: "job_message")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHeaderView()
        prepareDataView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHeaderView() {
        self.contentView.addSubview(containerStack)
    
        etaButton.snp.makeConstraints { make in
            make.height.width.equalTo(35)
        }
        etaButton.layer.cornerRadius = 17.5
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        expandCollapseIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        
        checkBoxIcon.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        checkBoxIcon.addGestureRecognizer(tapGesture)
        
    }
    
    private func prepareDataView() {
        dataView.addSubview(dataStackView)
        dataStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dataStackView.addArrangedSubview(locationRow)
        dataStackView.addArrangedSubview(messageRow)
        dataStackView.addArrangedSubview(callRow)
        dataStackView.addArrangedSubview(actionButtonView)
        containerStack.addArrangedSubview(dataView)
    }
    
    private func expandCollapseCell() {
        dataView.isHidden = !isExpand
        expandCollapseIcon.image = isExpand ? UIImage(named: "collaps_icon") : UIImage(named: "expand_icon")
    }
    
    @objc private func checkBoxDidTap() {
        if jobModel != nil {
            if jobModel!.isSelected {
                jobModel!.isSelected = false
            } else {
                jobModel!.isSelected = true
            }
            updateValue()
            didTapCheckbox?(tag)
        }
    }
    
    @objc private func callButtonTapped() {
        
    }
    
    @objc private func navButtonTapped() {
        
    }
    
    @objc private func pdfButtonTapped() {
        
    }
    
    private func manageETAButton() {
        var title: String
        guard let etaTitle = job?.ETAStatus else {
            title = "EAT"
            etaButton.backgroundColor = Colors.colorBlue
            etaButton.isUserInteractionEnabled = true
            etaButton.setTitle(title, for: .normal)
            return
        }
        title = "Delay"
        if etaTitle == ETAString.eta.rawValue {
            etaButton.isUserInteractionEnabled = true
        } else {
            etaButton.isUserInteractionEnabled = false
        }
        etaButton.backgroundColor = Colors.colorGray
        etaButton.setTitle(title, for: .normal)
    }
}

class ActionButtonView: UIView {
    
    private var viewColor: UIColor
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = viewColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = viewColor
        view.textAlignment = .left
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tappedButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    init(title: String?, image: UIImage, viewColor: UIColor) {
        self.viewColor = viewColor
        super.init(frame: .zero)
        setUpView()
        self.titleLabel.text = title
        self.icon.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(icon)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = viewColor.cgColor
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.height.width.equalTo(30)
            $0.top.bottom.equalToSuperview().inset(15)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(tappedButton)
        tappedButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
