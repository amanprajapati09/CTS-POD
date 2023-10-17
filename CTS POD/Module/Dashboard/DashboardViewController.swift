
import UIKit
import Combine

class DashboardViewController: UIViewController {
    
    private let viewModel: DashboardViewModel
    private var cancellable = Set<AnyCancellable>()
    private var optionList: [DashboardDisplayModel] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var iconImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var contentFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var driverNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.popSemiBold
        label.textColor = Colors.colorBlack
        return label
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.popSemiBold
        label.textColor = Colors.colorBlack
        return label
    }()
    
    private lazy var fetchButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.configuration.string.fetchJobTitle, for: .normal)
        button.setImage(viewModel.configuration.images.fetchJobs, for: .normal)
        button.backgroundColor = Colors.colorPrimaryDark
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(fetchButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var supportButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.popRegular
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("Support", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private lazy var buttonContainer: UIView = {
        let view = UIView()
        view.addSubview(fetchButton)
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setLogo()
        prepareCollectionView()
        prepareFooterView()
        bind()
        canShowFetchButton()
        fetchJobList()
        print(RealmManager.shared.printRealmPath())
    }
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        self.optionList = viewModel.fetchOptions()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DashBoardCell.self)
    }
    
    private func prepareFooterView() {
        if let user = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: "user") {
            footerView.isHidden = false
            driverNameLabel.text = user.user.username
            versionLabel.text = "Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            footerView.layoutIfNeeded()
        } else {
            footerView.isHidden = true
        }
    }
    
    private func setLogo() {        
        if let imageData = Data(base64Encoded: viewModel.customer.logo) {
            iconImage.image = UIImage(data: imageData)
        }
    }
    
    private func setupView() {
        view.backgroundColor = Colors.colorPrimary
        let safearea = view.safeAreaLayoutGuide
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.height.width.equalTo(150)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.centerX.equalToSuperview()
        }
    
        let containerStack = UIStackView(arrangedSubviews: [buttonContainer, collectionView])
        containerStack.axis = .vertical
        
        buttonContainer.snp.makeConstraints { $0.height.equalTo(50)}
        
        fetchButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(170)
            $0.center.equalToSuperview()
        }
        
        view.addSubview(containerStack)
        containerStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(iconImage.snp.bottom).offset(30)
            $0.height.equalTo(view.frame.size.width + 30)
        }
            
        view.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safearea)
            $0.bottom.equalToSuperview()
        }
        
        footerView.addSubview(contentFooterView)
        contentFooterView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safearea)
            $0.bottom.equalToSuperview()
        }
        
        contentFooterView.addSubview(driverNameLabel)
        driverNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(5)
            $0.bottom.equalTo(safearea).inset(10)
        }
        
        contentFooterView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(5)
            $0.bottom.equalTo(safearea).inset(10)
        }
        
        footerView.addSubview(supportButton)
        supportButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(contentFooterView.snp.top).inset(-16)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        
    }
    
    private func bind() {
        viewModel.$canShowFetchButton.subscribe(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.buttonContainer.isHidden = value
            }.store(in: &cancellable)
        
        viewModel.$updateJobListComplete.subscribe(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard value == true else { return }
                guard let self else { return }
                self.optionList = self.viewModel.fetchOptions()
            }.store(in: &cancellable)
    }
    
    @objc
    func fetchButtonClick() {
        viewModel.updateJobStatus()
    }
    
    private func canShowFetchButton() {
        buttonContainer.isHidden =  viewModel.checkFetchButtonStatus()
    }
    
    func fetchJobList() {
        if Constant.isLogin, Constant.isVehicalSubmit {
            viewModel.fetchJobList()
        }
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashBoardCell.reuseIdentifier, for: indexPath)
        (cell as? DashBoardCell)?.dashboardDisplayModel = optionList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2 - 30, height: view.frame.size.width/2 - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch optionList[indexPath.row].type {
        case .login:
            if Constant.isLogin {
                showlogoutAlert()
            } else {
                let signInVC = SignIn.build(customer: viewModel.customer) {
                    self.optionList = self.viewModel.fetchOptions()
                    self.prepareFooterView()
                }
                self.navigationController?.pushViewController(signInVC, animated: true)
            }
        case .vehical:
            if Constant.isVehicalCheck {
                let controller = VehicleCheckList.build()
                controller.vehicalCheckUpdate = {
                    self.optionList = self.viewModel.fetchOptions()
                    self.fetchJobList()
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }
        default:
            print("Default")
        }
    }
    
    private func showlogoutAlert() {
        let alert = UIAlertController(title: "Logout", message: viewModel.configuration.string.logoutAlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.viewModel.signOutDriver()
            self.optionList = self.viewModel.fetchOptions()
            self.prepareFooterView()
            self.canShowFetchButton()
        }))
        navigationController?.present(alert, animated: true)
    }

}
