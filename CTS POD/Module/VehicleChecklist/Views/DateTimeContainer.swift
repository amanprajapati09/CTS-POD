
import UIKit
import DatePicker

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
        view.attributedText = models.attributedTitle
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
        view.tintColor = .clear
        view.inputView = UIView()
        view.inputAccessoryView = UIView()
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
    
    private lazy var datePicker: DatePicker = {
        let picker = DatePicker()
        return picker
    }()
    
    private func prepareDropdown() {
        let minDate = DatePickerHelper.shared.dateFrom(day: 1, month: 01, year: 1800)!
        let maxDate = DatePickerHelper.shared.dateFrom(day: 31, month: 12, year: 2080)!
        datePicker.setup(beginWith: Date(), min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                self.textField.resignFirstResponder()
                self.handleDatePicker(date: selectedDate.string().calanderDateToDate())
            } else {
                print("Cancelled")
            }
        }
    }
    
    @objc func handleDatePicker(date: Date) {
        textField.text = date.createUTCDateString()
        selectedValue = date.createUTCDateString()
        didUpdateValue?(CheckListItem(id: models.id, value: selectedValue ?? ""))
    }
}

extension DateTimeContainer: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let controller = self.parentViewController {
            datePicker.show(in: controller)
        }
    }
}
