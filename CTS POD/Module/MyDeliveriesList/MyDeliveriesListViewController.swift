import UIKit
import RxSwift
import Combine

class MyDeliveriesListViewController: BaseViewController<MyDeliveriesListViewModel> {

    private var cancellable = Set<AnyCancellable>()
    let disposeBag = DisposeBag()
    var jobs: [JobDisplayModel]?
    
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.tintColor = .black
        self.title = "Deliveries Confirm"
        if let navigationBar = navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black, // You can change this color to the desired one
                .font: UIFont.boldSystemFont(ofSize: 17) // You can change the font and size as needed
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        tableView.register(JobConfirmListTableViewCell.self)
        setupView()
        bindView()
        viewModel.fetchList()
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
        let safearea = view.safeAreaLayoutGuide
        view.backgroundColor = Colors.forgotPasswordViewBackground
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindView() {
//        self.jobs = [JobDisplayModel(isExpand: false, job: Job(id: "test", cmpName: "Test", yourRef: "test", delAddressLine1: "Test", delPhone: "test", comments: "test")), JobDisplayModel(isExpand: false, job: Job(id: "test", cmpName: "Test", yourRef: "test", delAddressLine1: "Test", delPhone: "test", comments: "test"))]
//        self.tableView.reloadData()
        viewModel.$jobList.subscribe(on: DispatchQueue.main)
            .sink { [weak self] jobList in
                self?.jobs = jobList
                self?.tableView.reloadData()
            }.store(in: &cancellable)
    }
}

extension MyDeliveriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JobConfirmListTableViewCell = tableView.dequeue(JobConfirmListTableViewCell.self, for: indexPath)
        cell.isExpand = jobs?[indexPath.row].isExpand ?? false
        cell.job = jobs?[indexPath.row].job
        cell.selectionStyle = .none
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
