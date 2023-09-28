
import UIKit

final class DropdownContainer: BaseContainerView {
    
    private var selectedValue: String?
    
    required init(models: ValueOption) {
        super.init(models: models)
        prepareCheckView()
        prepareDropdown()
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
        view.snp.makeConstraints { $0.height.equalTo(50) }
        let dropdown = UIImageView(frame: .init(x: 0, y: 0, width: 40, height: 20))
        dropdown.image = UIImage(named: "down_arrow")
        view.rightView = dropdown
        view.rightViewMode = .always
        view.placeholder = models.title
        view.backgroundColor = Colors.colorLightGray
        view.delegate = self
        return view
    }()
    
    private lazy var toolBar: UIToolbar = {
        let view = UIToolbar()
        view.barStyle = UIBarStyle.default
        view.isTranslucent = true
        view.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        view.sizeToFit()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let fieldContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private func prepareCheckView()  {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    let picker = UIPickerView()
    private func prepareDropdown() {
       
        picker.delegate = self
        textField.inputView = picker
        
        let buttonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        buttonDone.tintColor = .systemBlue
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), buttonDone], animated: false)
        textField.inputAccessoryView = toolBar
    }
    
    @objc private func donePicker() {
        textField.resignFirstResponder()
        textField.text = selectedValue
            didUpdateValue?(CheckListItem(id: models.id, value: selectedValue ?? ""))
    }
}

extension DropdownContainer: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return models.info.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return models.info[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = models.info[row].title
    }
}

extension DropdownContainer: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard selectedValue == nil else { return }
            picker.selectRow(0, inComponent: 0, animated: true)
            pickerView(picker, didSelectRow: 0, inComponent: 0)
    }
}
