
import UIKit
import RxSwift

final class CheckboxContainer: BaseContainerView {
    
    required init(models: ValueOption) {
        super.init(models: models)
        prepareCheckView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popSemiBold
        view.textColor = Colors.colorBlack
        view.textAlignment = .left
        view.text = models.title
        view.font = Fonts.popRegular
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
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
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(checkboxContainer)
        checkboxContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        prepareCheckboxTax()
    }
    
    private func updateMark(info: DetailValueOption) {
        let updatedList = models.info.map {
            if info.id == $0.id {
                return DetailValueOption(title: $0.title, id: $0.id, isCheckd: !$0.isCheckd)
            } else {
                if !info.isCheckd {
                    return DetailValueOption(title: $0.title, id: $0.id, isCheckd: false)
                } else {
                    return DetailValueOption(title: $0.title, id: $0.id, isCheckd: $0.isCheckd)
                }
            }
        }
        models.info = updatedList
        prepareCheckboxTax()
    }
    
    private func prepareCheckboxTax() {
        checkboxContainer.removeFullyAllArrangedSubviews()
        for info in models.info {
            let checkbox =  CheckBox(models: info)
            checkbox.didButtonTap = {
                self.updateMark(info: info)
                if !info.isCheckd {
                    self.didUpdateValue?(CheckListItem(id: self.models.id, value: info.title))      
                }
            }
            checkboxContainer.addArrangedSubview(checkbox)
        }
        checkboxContainer.addArrangedSubview(UIView())
    }
}

final class CheckBox: UIView {
    
    var models: DetailValueOption
    let bag = DisposeBag()
    var didButtonTap: (()->())?
    init(models: DetailValueOption) {
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
        view.textColor = Colors.colorGray
        view.textAlignment = .left
        view.text = models.title
        view.font = Fonts.popRegular
        return view
    }()
  
    private(set) lazy var button: UIButton = {
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
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        button.rx.tap.bind { _ in
            self.didButtonTap?()
        }.disposed(by: bag)
    }
    
    func updateImage()  {
        button.setImage(buttonImage, for: .normal)
    }
}
