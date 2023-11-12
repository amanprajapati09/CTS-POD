
import UIKit

final class DateTimeContainer: BaseContainerView {
    
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
        view.tintColor = .clear
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
        textField.text = models.prefilledValue
    }
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        return datePicker
    }()
    
    private func prepareDropdown() {
        
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
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
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        textField.text = sender.date.createUTCDateString()
        selectedValue = sender.date.createUTCDateString()
    }
}
