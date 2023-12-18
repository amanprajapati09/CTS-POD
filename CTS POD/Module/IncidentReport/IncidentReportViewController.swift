
import UIKit

final class IncidentReportViewController: BaseViewController<IncidentReportViewModel> {
    
    weak var delegate: IncidentNavigatorProtocol?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var containerStack: ScrollableStackView = {
        let view = ScrollableStackView()
        view.spacing = 25
        return view
    }()
    
    private lazy var buttonPrevious: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorGray
        view.setTitleColor(Colors.colorBlack, for: .normal)
        view.setTitle(viewModel.configuration.string.buttonPreviousTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonPreviousTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        return view
    }()
    
    private lazy var buttonNext: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorGray
        view.setTitleColor(Colors.colorBlack, for: .normal)
        view.setTitle(viewModel.configuration.string.buttonNextTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonNextTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        return view
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonPrevious, buttonNext])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 15
        return view
    }()
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = viewModel.dynamicReportList.first?.sectionDescription
        view.backgroundColor = Colors.viewBackground
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        containerView.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        containerView.addSubview(containerStack)
        containerStack.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(buttonContainer.snp.top).inset(-20)
        }
    }
    
    private lazy var backButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "icn_back"),
                                   style: .done,
                                   target:self,
                                   action: #selector(navigationBackClick))
        return view
    }()
    
    init(viewModel: IncidentReportViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        prepareView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func buttonPreviousTap() {
        delegate?.didPressPrevious()
    }
    
    @objc
    func buttonNextTap() {
        let compolsorryField = viewModel.dynamicReportList.filter { $0.isRequierd == true }
        if let navigationController = navigationController as? IncidentNavigatorController {
            if compolsorryField.count > 0 {
                for item in compolsorryField {
                    if let field = navigationController.requestModel.values.filter({
                        return $0.id == item.id
                    }).first {
                        if field.name.isEmpty {
                            showErrorAlert(message: "Please fill the \(item.description) field")
                            return
                        }
                    }
//                    if navigationController.requestModel.values.contains(where: { $0.id == item.id }) == false {
//                        showErrorAlert(message: "Please fill the \(item.description) field")
//                        return
//                    }
                }
            }
            delegate?.didPressNext(index: viewModel.dynamicReportList.first?.sectionNo ?? 0)
        }
    }
    
    @objc
    private func navigationBackClick() {
        if let navigationController {
           if navigationController.viewControllers.count == 1 {
                navigationController.dismiss(animated: true)
            } else {
                delegate?.didPressPrevious()
            }
        }
    }
    
    private func prepareView() {
        for item in viewModel.dynamicReportList {
            let info = item.values.map { $0.map() }
            if let className = "\(item.type)Container".toMyModuleClass() as? BaseContainerView.Type {
                var model: ValueOption!
                
                if let prefilledValue = (navigationController as? IncidentNavigatorController)?.requestModel.values.filter({
                    $0.id == item.id
                }), prefilledValue.count > 0 {
                    model = ValueOption(id: item.id, title: item.description, info: info, prefilledValue: prefilledValue.first?.name ?? "")
                } else {
                    model = ValueOption(id: item.id, title: item.description, info: info)
                }
                    
                let fieldView = className.init(models: model)
                containerStack.stackView.addArrangedSubview(fieldView)
                fieldView.didUpdateValue = { [weak self] updatedValue in
                    self?.delegate?.modifyStatus(item: updatedValue)                    
                }
                fieldView.snp.makeConstraints {
                    $0.height.greaterThanOrEqualTo(80)
                    $0.leading.trailing.equalToSuperview()
                }
            }
        }
    }
}
