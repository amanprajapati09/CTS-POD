
import UIKit

final class NumberContainer: BaseContainerView {
   
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
    
    private lazy var textField: VehicleTextField = {
        let view = VehicleTextField ()
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Colors.colorGray.cgColor
        view.snp.makeConstraints { $0.height.equalTo(50) }
        view.placeholder = models.title
        view.keyboardType = .numberPad
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.delegate = self
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        didUpdateValue?(CheckListItem(id: models.id, value: textField.text ?? ""))
    }
}

extension NumberContainer: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
