
import UIKit
import SnapKit

class JobConfirmListTableViewCell: UITableViewCell, Reusable {
    
    var isExpand: Bool = false {
        didSet {
            expandCollapseCell()
        }
    }
    
    var job: Job? {
        didSet {
            updateValue()
        }
    }
    
    private func updateValue() {
        guard let job else { return }
        titleLabel.text = job.cmpName
        subTitleLabel.text = job.titleAddress
        
        locationRow.titleLabel.text = job.delAddressLine3
        messageRow.titleLabel.text = job.comments
        callRow.titleLabel.text = job.orderNumber
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
    
    private lazy var checkBoxIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "check_empty")
        view.contentMode = .scaleAspectFill
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
        let view = UIStackView(arrangedSubviews: [expandCollapseIcon, titleContainer , checkBoxIcon])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .top
        view.spacing = 5
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
    
    private lazy var containerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
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
        self.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        expandCollapseIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        
        checkBoxIcon.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
    }
    
    private func prepareDataView() {
        dataView.addSubview(dataStackView)
        dataStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dataStackView.addArrangedSubview(locationRow)
        dataStackView.addArrangedSubview(messageRow)
        dataStackView.addArrangedSubview(callRow)
        containerStack.addArrangedSubview(dataView)
    }
    
    private func expandCollapseCell() {
        dataView.isHidden = !isExpand
        expandCollapseIcon.image = isExpand ? UIImage(named: "collaps_icon") : UIImage(named: "expand_icon")
    }
}


class RowView: UIView {
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .left
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(icon)
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
        
        addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

struct JobDisplayModel {
    var isExpand: Bool
    var job: Job
}