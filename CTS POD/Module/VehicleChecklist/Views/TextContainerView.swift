
import UIKit
import RxSwift

final class TextContainer: BaseContainerView {
    
    let bag = DisposeBag()
    
    required init(models: ValueOption) {
        super.init(models: models)
        prepareCheckView()
        bindValue()
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
    
    private lazy var textField: VehicleTextField = {
        let view = VehicleTextField ()
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Colors.colorGray.cgColor
        view.snp.makeConstraints { $0.height.equalTo(50) }
        view.placeholder = models.title
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    func prepareCheckView()  {
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindValue()  {
        textField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [weak self] text in
                self?.didUpdateValue?(CheckListItem(id: self?.models.id ?? "", value: self?.textField.text ?? ""))
            }).disposed(by: bag)
    }
}
