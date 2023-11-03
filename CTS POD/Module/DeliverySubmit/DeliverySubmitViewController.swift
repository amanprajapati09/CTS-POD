
import Foundation

import UIKit
import RxSwift
import Combine

class DeliverySubmitViewController: BaseViewController<DeliverySubmitViewModel> {
    
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateValue()
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
        view.image = UIImage(named: "expand_icon")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var orderNo: UILabel = {
        let view = UILabel()
        view.font = Fonts.popMedium
        view.textColor = Colors.colorGray
        view.textAlignment = .left
        view.text = "102032323909023"
        return view
    }()
    
    private lazy var customerView: DeliveryRowView = {
        let view = DeliveryRowView(title: "Customer Name")
        return view
    }()
    
    private lazy var jobStatusView: DeliveryRowView = {
        let view = DeliveryRowView(title: "Job Status")
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
        view.setTitle("Signature", for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        //view.addTarget(self, action: #selector(buttonSignInTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var btnCamera: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorBlue
        view.setTitle("Camera", for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        //view.addTarget(self, action: #selector(buttonSignInTap), for: .touchUpInside)
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
    
    init(viewModel: DeliverySubmitViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: false)       
        view.backgroundColor = Colors.viewBackground
        navigationItem.title = viewModel.orderTitle
      
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
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        btnCamera.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        containerStack.addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actionButtonView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func updateValue() {
        
    }
    
    @objc
    private func buttonSignature() {
        
    }
    
    @objc
    private func buttonCamera() {
        
    }
    
    @objc
    private func buttonSaveTap() {
       
    }
}

extension DeliverySubmitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SignatureImageCollectionViewCell = collectionView.dequeue(SignatureImageCollectionViewCell.self, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
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
    
    public lazy var textField: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
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
