
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
