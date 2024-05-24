
import UIKit
import YPImagePicker
import Combine

final class IncidentReportCameraViewController: BaseViewController<IncidentReportCameraViewModel> {
    
    weak var delegate: IncidentNavigatorProtocol?
    private var collectionImages = [UIImage]()
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var btnCamera: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colororagne
        view.setTitle(viewModel.configuration.string.buttonCameraTitle, for: .normal)
        view.setImage(viewModel.configuration.images.cameraIcon, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(buttonCameraTap), for: .touchUpInside)
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
    
    private lazy var buttonSubmit: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorGray
        view.setTitleColor(Colors.colorBlack, for: .normal)
        view.setTitle(viewModel.configuration.string.buttonSubmitTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonSubmitTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        return view
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(SignatureImageCollectionViewCell.self)
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonPrevious, buttonSubmit])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 15
        return view
    }()
    
    init(viewModel: IncidentReportCameraViewModel) {
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
    }
    
    @objc
    private func buttonSubmitTap() {
        guard collectionImages.count > 0 else {
            showErrorAlert(message: viewModel.configuration.string.imagePickertAlertMessage)
            return
        }
        guard collectionImages.count <= 20 else {
            showErrorAlert(message: viewModel.configuration.string.maxImageAlertMessage)
            return
        }
        if let navigation = navigationController as? IncidentNavigatorController {
            navigation.requestModel.photoCount = collectionImages.count
            navigation.requestModel.createdDate = Date().apiSupportedDate()
            viewModel.callIncidentReportAPI(requestModel: navigation.requestModel, collectionImages: collectionImages)
        }
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = Colors.viewBackground
        navigationItem.title = viewModel.configuration.string.cameraNavigationTitle
        
        view.addSubview(btnCamera)
        btnCamera.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
                        
        view.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(buttonContainer)
        }
        buttonPrevious.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        buttonSubmit.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(btnCamera.snp.bottom).offset(15)
            $0.bottom.equalTo(buttonContainer.snp.top).offset(-10)
        }
    }
    
    @objc
    private func buttonCameraTap() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        config.library.defaultMultipleSelection = true
        config.targetImageSize = YPImageSize.cappedTo(size: 960.0)
        config.showsPhotoFilters = false
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    ImageCompressor.compress(image: photo.image, maxByte: 200000) { image in
                        guard let image else { return }
                        self.collectionImages.append(image)
                        self.collection.reloadData()
                    }
                default:
                    print("video not needed")
                }
            }
            picker.dismiss(animated: true)
        }
        present(picker, animated: true)
    }
    
    @objc
    func buttonPreviousTap() {
        delegate?.didPressPrevious()
    }

    private func bind() {
        viewModel.$viewState.receive(on: DispatchQueue.main)
            .sink { state in
                self.activityIndicator.stopAnimating()
                switch state {
                case .loading:
                    self.activityIndicator.startAnimating()
                    self.navigationItem.leftBarButtonItem?.isEnabled = false
                    self.buttonContainer.isHidden = true
                case .loaded:
                    self.showSuccessAlert()
                case .error(let message):
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.showErrorAlert(message: message)
                    self.buttonContainer.isHidden = false
                default :
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.buttonContainer.isHidden = false
                }
            }.store(in: &cancellable)
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "", message: "Incident is submitted successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.navigationController?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
}

extension IncidentReportCameraViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collection.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SignatureImageCollectionViewCell = collectionView.dequeue(SignatureImageCollectionViewCell.self, for: indexPath)
        cell.closeButton.tag = indexPath.row
        cell.didCancelImage = { index in
            self.collectionImages.remove(at: index)
            collectionView.reloadData()
        }
        cell.icon.image = collectionImages[indexPath.row]
        return cell
    }
    
}
