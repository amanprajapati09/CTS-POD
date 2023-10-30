
import UIKit
import Combine

class VehicleCheckListViewController: BaseViewController<VehicleCheckListViewModel> {
    
    private var cancellable = Set<AnyCancellable>()
    private var vehicalCheckList: VehicleCheckListResponse?
    var vehicalCheckUpdate: (()->())?
    
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
    
    private lazy var buttonSafe: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorBlue
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.buttonSafeTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonSafeTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        return view
    }()
    
    private lazy var buttonUnSafe: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorGray
        view.setTitleColor(Colors.colorBlack, for: .normal)
        view.setTitle(viewModel.configuration.string.buttonUnSafeTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonUnSafeTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        return view
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonSafe, buttonUnSafe])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 15
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var updateActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    init(viewModel: VehicleCheckListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.fetchCheckList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = viewModel.configuration.string.navigationTitle
        view.backgroundColor = Colors.viewBackground
        
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
        
        containerStack.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    
        containerStack.addSubview(updateActivityIndicator)
        updateActivityIndicator.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(-20)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func prepareView() {
        for item in vehicalCheckList!.data.vehicleChecklist {
            let info = item.values.map { $0.map() }
            guard let className = "\(item.type)Container".toMyModuleClass() as? BaseContainerView.Type else { return }
            let fieldView = className.init(models: .init(id: item.id, title: item.description, info: info))
            containerStack.stackView.addArrangedSubview(fieldView)
            fieldView.didUpdateValue = { [weak self] updatedValue in
                self?.viewModel.modifyStatus(item: updatedValue)
            }
            fieldView.snp.makeConstraints {
                $0.height.equalTo(80)
                $0.leading.trailing.equalToSuperview()
            }
       }
    }
    
    private func bind() {
        viewModel.$viewState.receive(on: DispatchQueue.main).sink { state in
            switch state {
            case .loading:
                self.manageLoading(showLoading: true)
            case .loaded(let response):
                self.vehicalCheckList = response
                self.prepareView()
                self.manageLoading(showLoading: false)
            default:
                self.manageUpdateLoading(showLoading: false)
            }
        }.store(in: &cancellable)
        
        viewModel.$updateViewState.receive(on: DispatchQueue.main).sink { state in
            switch state {
            case .loading:
                self.manageUpdateLoading(showLoading: true)
            case .loaded(_):
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.isVehicalSubmit)
                self.vehicalCheckUpdate?()
                self.navigationController?.popViewController(animated: true)
                self.manageUpdateLoading(showLoading: false)
            default:
                self.manageUpdateLoading(showLoading: false)
            }
        }.store(in: &cancellable)
    }
    
    private func manageLoading(showLoading: Bool) {
        if showLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        buttonContainer.isHidden = showLoading
    }
    
    private func manageUpdateLoading(showLoading: Bool) {
        buttonContainer.isHidden = showLoading
        if showLoading {
            updateActivityIndicator.startAnimating()
        } else {
            updateActivityIndicator.stopAnimating()
        }
    }
    
    @objc
    func buttonSafeTap() {
        viewModel.updateStatus(status: "")
    }
    
    @objc
    func buttonUnSafeTap() {
        showCommentAlert()
    }
    
    private func showCommentAlert() {
        let alert = UIAlertController(title: viewModel.configuration.string.buttonUnSafeTitle, message: viewModel.configuration.string.commentMessage, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Comment"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.viewModel.updateStatus(status: textField?.text ?? "")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
