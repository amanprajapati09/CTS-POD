import UIKit
import RxSwift
import Combine

class MyDeliveriesListViewController: BaseViewController<MyDeliveriesListViewModel> {

    private var cancellable = Set<AnyCancellable>()
    let disposeBag = DisposeBag()
    var jobs: [JobDisplayModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        tableView.register(MyDeliveriesListTableViewCell.self)
        setupView()
        bindView()
        viewModel.fetchList()
    }
    
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.tintColor = .black
        self.title = viewModel.configuration.string.navigationTitle
        if let navigationBar = navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "done"),
                                          style: .done, target: self,
                                          action: #selector(navigationRightClick))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(viewModel: MyDeliveriesListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = Colors.forgotPasswordViewBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindView() {
        self.jobs = [JobDisplayModel(isExpand: false, job: Job(id: "test", cmpName: "Test", yourRef: "test", delAddressLine1: "Test", delPhone: "test", comments: "test")), JobDisplayModel(isExpand: false, job: Job(id: "test", cmpName: "Test", yourRef: "test", delAddressLine1: "Test", delPhone: "test", comments: "test"))]
        self.tableView.reloadData()
//        viewModel.$jobList.subscribe(on: DispatchQueue.main)
//            .sink { [weak self] jobList in
//                self?.jobs = jobList
//                self?.tableView.reloadData()
//            }.store(in: &cancellable)
        
        viewModel.$state.subscribe(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .LocationPermission:
                    self?.showErrorAlert(message: "Please allow location permission to access the location.")
                case .success:
                    self?.viewModel.fetchList()
                case .error(let message):
                    self?.showErrorAlert(message: message)
                default:
                    print("nothing")
                }
            }.store(in: &cancellable)
    }
    
    @objc
    private func navigationRightClick() {
        guard let jobs else { return }
        let selectedItems = jobs.filter {
            $0.isSelected == true
        }
        if selectedItems.count > 0 {
            let joblist = selectedItems.map{ $0.job }
            let controller = DeliverySubmit.build(jobs: joblist)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            showSelectedJobAlert()
        }
    }
    
    private func showSelectedJobAlert() {
        let alert = UIAlertController(title: "Error!", message: "Please select jobs which complete driver and supervisor sign", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension MyDeliveriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyDeliveriesListTableViewCell = tableView.dequeue(MyDeliveriesListTableViewCell.self, for: indexPath)
        cell.isExpand = jobs?[indexPath.row].isExpand ?? false
        cell.jobModel = jobs?[indexPath.row]
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.didTapCheckbox = { index in
            if let jobList = self.jobs {
                let job = jobList[index]
                if job.isSelected {
                    self.jobs?[index].isSelected = false
                } else {
                    self.jobs?[index].isSelected = true
                }
            }
        }
        cell.didTapETAButton = { index in
            if let jobList = self.jobs {
                let job = jobList[index]
                self.viewModel.updateStatus(selectedJob: job.job)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let status = jobs?[indexPath.row].isExpand, status == true {
            jobs?[indexPath.row].isExpand = false
        } else {
            jobs?[indexPath.row].isExpand = true
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
