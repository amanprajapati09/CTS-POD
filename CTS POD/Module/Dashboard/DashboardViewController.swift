
import UIKit

class DashboardViewController: UIViewController {
    
    private let viewModel: DashboardViewModel
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setLogo()
        prepareCollectionView()
        prepareFooterView()
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
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(iconImage.snp.bottom).offset(30)
            $0.height.equalTo(view.frame.size.width + 30)
        }
        
        view.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safearea)
            $0.bottom.equalToSuperview()
        }
        
        footerView.addSubview(driverNameLabel)
        driverNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(5)
            $0.bottom.equalTo(safearea).inset(10)
        }
        
        footerView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(5)
            $0.bottom.equalTo(safearea).inset(10)
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
            LocalTempStorage.removeValue(for: UserDefaultKeys.user)
            self.optionList = self.viewModel.fetchOptions()
            self.prepareFooterView()
        }))
        navigationController?.present(alert, animated: true)
    }
}
