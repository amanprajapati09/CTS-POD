
import UIKit
import Combine

class VehicleCheckListViewController: BaseViewController<VehicleCheckListViewModel> {

    private var cancellable = Set<AnyCancellable>()
    private var vehicalCheckList: VehicleCheckListResponse?
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view 
    }()
    
    private lazy var containerStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
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
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(containerStack)
        containerStack.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func prepareView() {
        for item in vehicalCheckList!.data.vehicleChecklist {
            if item.type == VehicalCheckType.Checkbox.rawValue {
                let checkboxinfo = item.values.map { $0.map() }
                containerStack.addArrangedSubview(CheckBoxView(models: .init(title: item.description, info: checkboxinfo)))
            }
        }
    }
    
    private func bind() {
        viewModel.$viewState.receive(on: DispatchQueue.main).sink { state in
            switch state {
            case .loading:
                print("loading")
            case .loaded(let response):
                self.vehicalCheckList = response
                self.prepareView()
            default:
                print("mango")
            }
        }.store(in: &cancellable)
    }
}
