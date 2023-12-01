
import Foundation
import UIKit
import RxSwift
import Combine
import YPImagePicker

class DeliverySubmitViewController: BaseViewController<DeliverySubmitViewModel> {
    
    private var cancellable = Set<AnyCancellable>()
    private var collectionImages = [UIImage]()
    private var signatureImage: Data?
    private var selectedState: DeliveryOption
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateValue()
        bind()
        manageButtons(option: .deliver)
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var containerStack: ScrollableStackView = {
        let view = ScrollableStackView()
        view.spacing = 15
        view.stackView.axis = .vertical
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var orderNoView: UIStackView = {
        let instance = UIStackView(arrangedSubviews: [icon, orderNo])
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.axis = .horizontal
        instance.spacing = 10
        return instance
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "job_order")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var orderNo: UILabel = {
        let view = UILabel()
        view.font = Fonts.popMedium
        view.textColor = Colors.colorGray
        view.textAlignment = .left
        return view
    }()
    
    private lazy var customerView: DeliveryRowView = {
        let view = DeliveryRowView(title: "Customer Name")
        return view
    }()
    
    private lazy var jobStatusView: DeliveryRowView = {
        let view = DeliveryRowView(title: "Job Status")
        view.textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneClick))
        let dropdown = UIImageView(frame: .init(x: 0, y: 0, width: 40, height: 20))
        dropdown.image = UIImage(named: "down_arrow")
        view.textField.rightView = dropdown
        view.textField.rightViewMode = .always
        return view
    }()
    
    private lazy var commentsView: DeliveryRowView = {
        let view = DeliveryRowView(title: "Comments")
        return view
    }()
    
    private lazy var actionButtonView: UIStackView = {
        let instance = UIStackView(arrangedSubviews: [btnSignature, btnCamera])
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.axis = .horizontal
        instance.spacing = 10
        instance.distribution = .fill
        return instance
    }()
    
    private lazy var btnSignature: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorBlue
        view.setTitle(viewModel.configuration.string.signatureTitle, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.setImage(viewModel.configuration.images.signatureIcon, for: .normal)
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(buttonSignatureTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var btnCamera: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colororagne
        view.setTitle(viewModel.configuration.string.cameraTitle, for: .normal)
        view.setImage(viewModel.configuration.images.cameraIcon, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(buttonCameraTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(SignatureImageCollectionViewCell.self)
        return view
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "done"),
                                   style: .done,
                                   target:self,
                                   action: #selector(navigationRightClick))
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    init(viewModel: DeliverySubmitViewModel) {
        selectedState = .deliver
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = Colors.viewBackground
        navigationItem.title = viewModel.configuration.string.navigationTitle + ": " + viewModel.orderTitle
        
        navigationItem.rightBarButtonItem = rightButton
        
        orderNo.text = viewModel.orderNumber
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        containerView.addSubview(containerStack)
        containerStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        containerStack.stackView.addArrangedSubview(orderNoView)
        containerStack.stackView.addArrangedSubview(customerView)
        containerStack.stackView.addArrangedSubview(jobStatusView)
        containerStack.stackView.addArrangedSubview(commentsView)
        containerStack.addSubview(actionButtonView)
        
        actionButtonView.snp.makeConstraints { make in
            make.top.equalTo(containerStack.stackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        btnSignature.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        btnCamera.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        containerStack.addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actionButtonView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        jobStatusView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    private func updateValue() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        jobStatusView.textField.inputView = picker
    }
    
    @objc
    private func buttonSignatureTap() {
        let signatureView = Signature.build(signType: .driverSign)
        signatureView.viewModel.complition = { data in
            self.signatureImage = data
            signatureView.dismiss(animated: true)
        }
        present(signatureView, animated: true)
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
                    guard let photo = photo.image.compressTo(5) else {return}
                    self.collectionImages.append(photo)
                    self.imagesCollectionView.reloadData()
                default:
                    print("video not needed")
                }
            }
            picker.dismiss(animated: true)
        }
        present(picker, animated: true)
    }
    
    @objc
    private func buttonSaveTap() {
        //TODO: - API call or local save
    }
    
    fileprivate func manageButtons(option: DeliveryOption) {
        switch option {
        case .deliver:
            btnCamera.isHidden = false
            btnSignature.isHidden = false
        case .deliveredNoSign:
            btnCamera.isHidden = false
            btnSignature.isHidden = true
            signatureImage = nil
        case .unableToDeliver:
            btnCamera.isHidden = true
            btnSignature.isHidden = true
            signatureImage = nil
            collectionImages.removeAll()
        }
        jobStatusView.textField.text = option.rawValue
        selectedState = option
    }
    
    @objc
    func doneClick() {
        jobStatusView.textField.resignFirstResponder()
    }
    
    @objc
    private func navigationRightClick() {
        switch selectedState {
        case .deliver:
            validateDelivery()
        case .deliveredNoSign:
            validateDeliveryNoSign()
        case .unableToDeliver:
            validateUnableToDeliver()
        }
    }
    
    private func validateDelivery() {
        guard let name = customerView.textField.text, name.count > 0 else {
            showErrorAlert(message: "Please enter customer name!")
            return
        }
        
//        guard collectionImages.count > 0 else {
//            showErrorAlert(message: "Please capture atleast one image!")
//            return
//        }
        guard let signatureImage else {
            showErrorAlert(message: "Please capture customer signature!")
            return
        }
        
        viewModel.submitJob(comment: commentsView.textField.text ?? "",
                            name: customerView.textField.text ?? "",
                            images: collectionImages,
                            statusOption: selectedState,
                            signature: signatureImage)
    }
    
    private func validateDeliveryNoSign() {
        
        guard let comment = commentsView.textField.text, comment.count > 0 else {
            showErrorAlert(message: "Please enter comment!")
            return
        }
        
        guard collectionImages.count > 0 else {
            showErrorAlert(message: "Please capture atleast one image!")
            return
        }
        
        viewModel.submitJob(comment: commentsView.textField.text ?? "",
                            name: customerView.textField.text ?? "",
                            images: collectionImages,
                            statusOption: selectedState,
                            signature: nil)
    }
    
    private func validateUnableToDeliver() {
        
        guard let comment = commentsView.textField.text, comment.count > 0 else {
            showErrorAlert(message: "Please enter comment!")
            return
        }
        
        viewModel.submitJob(comment: commentsView.textField.text ?? "",
                            name: customerView.textField.text ?? "",
                            images: nil,
                            statusOption: selectedState,
                            signature: nil)
    }
    
    private func bind() {
        viewModel.$viewState.receive(on: DispatchQueue.main)
            .sink { state in
                self.activityIndicator.stopAnimating()
                switch state {
                case .loading:
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    self.navigationItem.leftBarButtonItem?.isEnabled = false
                case .loaded(_):
                    self.navigationItem.rightBarButtonItem = self.rightButton
                    if LocalDataBaseWraper().fetchJobsForDeliveryList().count > 0 {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.navigationController?.popToViewController(ofClass: DashboardViewController.self)
                    }
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                case .error(let message):
                    self.showErrorAlert(message: message)
                    self.navigationItem.rightBarButtonItem = self.rightButton
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                default:
                    print("")
                }
            }.store(in: &cancellable)
    }
}

extension DeliverySubmitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}

extension DeliverySubmitViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.configuration.optionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.configuration.optionList[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        manageButtons(option: viewModel.configuration.optionList[row])
    }
}

class DeliveryRowView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    public lazy var textField: VehicleTextField = {
        let view = VehicleTextField()
        view.font = Fonts.popRegular
        view.backgroundColor = .white
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.textField.placeholder = title
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview()
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading).inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
    }
}
