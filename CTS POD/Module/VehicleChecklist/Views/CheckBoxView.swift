
import UIKit

final class CheckBoxView: UIView {
    
    let models: CheckBoxViewOption
    
    init(models: CheckBoxViewOption) {
        self.models = models
        super.init(frame: .zero)
        prepareCheckView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = Fonts.popSemiBold
        view.textColor = Colors.colortext
        view.textAlignment = .left
        view.text = models.title
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [label])
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private lazy var checkboxContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 40
        return view
    }()
    
    func prepareCheckView()  {
        for info in models.info {
            checkboxContainer.addArrangedSubview(CheckBox(models: info))
        }
        checkboxContainer.addArrangedSubview(UIView())
        stackView.addArrangedSubview(checkboxContainer)
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
}

final class CheckBox: UIView {
    
    let models: CheckBoxInfo
    
    init(models: CheckBoxInfo) {
        self.models = models
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttonImage: UIImage? {
        return models.isCheckd ? UIImage(named: "check_mark") : UIImage(named: "check_empty")
    }
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = Fonts.popMedium
        view.textColor = Colors.colortext
        view.textAlignment = .left
        view.text = models.title
        return view
    }()
  
    private lazy var button: UIButton = {
        let view = UIButton()
        view.setImage(buttonImage, for: .normal)
        view.snp.makeConstraints {
            $0.height.width.equalTo(30)
        }
        return view
    }()
    
    private lazy var checkContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [spacerView, label, button])
        view.axis = .horizontal
        view.spacing = 5
        return view
    }()
    
    private lazy var spacerView: UIView = {
       let view = UIView()
        view.snp.makeConstraints { $0.width.equalTo(20) }
        return view
    }()
    
    private func setupView() {
        addSubview(checkContainer)
        checkContainer.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }
}

struct CheckBoxViewOption {
    let title: String
    let info: [CheckBoxInfo]
}

struct CheckBoxInfo {
    let title: String
    let id: Int
    let isCheckd: Bool = false
}

