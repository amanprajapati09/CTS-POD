import UIKit
import RxSwift
import Combine
import MapKit
import CoreLocation

class MyDeliveriesListViewController: BaseViewController<MyDeliveriesListViewModel> {

    private var cancellable = Set<AnyCancellable>()
    let disposeBag = DisposeBag()
    var jobs: [JobDisplayModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsMultipleSelection = false
        tableView.dragInteractionEnabled = true
        tableView.allowsSelectionDuringEditing = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        tableView.register(MyDeliveriesListTableViewCell.self)
        setupView()
        bindView()
        fetchJobList()
    }
    
    private func fetchJobList() {
        if let value = LocalTempStorage.getValue(key: UserDefaultKeys.jobDisplayOption) as? String,
           let option = MyDeliveriesListViewModel.JobDisplayOption(rawValue: value) {
            viewModel.fetchList(option: option)
        } else {
            viewModel.fetchDefaultList()
        }
    }

    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.tintColor = .black
        if let navigationBar = navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        let right = UIButton(type: .system)
        right.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        right.setImage(UIImage(named: "done"), for: .normal)
        right.addTarget(self, action: #selector(navigationRightClick), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: right)
        
        let more = UIButton(type: .system)
        more.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        more.setImage(UIImage(named: "more"), for: .normal)
        more.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        let moreButton = UIBarButtonItem(customView: more)
        
        navigationItem.rightBarButtonItems = [rightButton, moreButton]
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "icn_back"),
                                             style: .plain,
                                             target: self,
                                      action: #selector(navigationBack))
        
        let barcode = UIButton(type: .system)
        barcode.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        barcode.setImage(UIImage(named: "barcode"), for: .normal)
        barcode.addTarget(self, action: #selector(barcodeButtonTap), for: .touchUpInside)
        let btnBarcode = UIBarButtonItem(customView: barcode)

        navigationItem.leftBarButtonItems = [btnBack, btnBarcode]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = viewModel.configuration.string.navigationTitle
        fetchJobList()
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
        viewModel.$jobList.subscribe(on: DispatchQueue.main)
            .sink { [weak self] jobList in
                self?.jobs = jobList
                self?.tableView.reloadData()
            }.store(in: &cancellable)
    }
    
    @objc
    private func navigationRightClick() {
        guard let jobs, jobs.count > 0 else {
            showSelectedJobAlert()
            return
        }
        let selectedItems = jobs.filter {
            $0.isSelected == true
        }
        if selectedItems.count > 0 {
            let joblist = selectedItems.map{ $0.job }
            let controller = DeliverySubmit.build(jobs: joblist)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            showSelectedJobAlert(message: "Please select delivery which complete driver and supervisor sign")
        }
    }
    
    @objc
    private func navigationBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showSelectedJobAlert(message: String = "No deliveries are available!") {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showMapOption(latitude: Double, longitude: Double) {
        let nav = DirectionsOpts.directionsAlertController(coordinate: .init(latitude: latitude, longitude: longitude), name: "Selection", title: "Select navigation app", message: "") { com in
                
            }
            self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func moreButtonClick() {
        let sortOptionSheet = UIAlertController(title: nil,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
        sortOptionSheet.view.tintColor = .black
        sortOptionSheet.addAction(UIAlertAction(title: MyDeliveriesListViewModel.JobDisplayOption.defaultView.rawValue, style: .default, handler: { [weak self]  action in
            self?.viewModel.fetchDefaultList()
            LocalTempStorage.storeValue(value: MyDeliveriesListViewModel.JobDisplayOption.defaultView.rawValue, key: UserDefaultKeys.jobDisplayOption)
            self?.tableView.isEditing = false
        }))
        sortOptionSheet.addAction(UIAlertAction(title: MyDeliveriesListViewModel.JobDisplayOption.optimizedRoute.rawValue, style: .default, handler: { [weak self] action in
            self?.viewModel.sortBasedOnDistance()
            self?.tableView.isEditing = false
            LocalTempStorage.storeValue(value: MyDeliveriesListViewModel.JobDisplayOption.optimizedRoute.rawValue, key: UserDefaultKeys.jobDisplayOption)
        }))
        sortOptionSheet.addAction(UIAlertAction(title: MyDeliveriesListViewModel.JobDisplayOption.dragAndDrop.rawValue, style: .default, handler: { [weak self] action in
            self?.viewModel.sortBasedOnPosition()
            LocalTempStorage.storeValue(value: MyDeliveriesListViewModel.JobDisplayOption.dragAndDrop.rawValue, key: UserDefaultKeys.jobDisplayOption)
            self?.tableView.isEditing = true
        }))
        sortOptionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(sortOptionSheet, animated: true)
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
        
        cell.didEATSubimited = { [weak self] (result, message) in
            if result == true {
                self?.fetchJobList()
            } else {
                self?.showErrorAlert(message: message ?? "")
            }
        }
        
        cell.didTapAction = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .document:
                if let document = self.jobs?[indexPath.row].job.document,
                   let data = Data(base64Encoded: document) {
                    let pdfViewController = PDFViewerViewController(data: data)
                    self.navigationController?.pushViewController(pdfViewController, animated: true)
                 }
            case .call:
                if let url = URL(string: "tel://\(self.jobs?[indexPath.row].job.delPhone ?? "")") {
                     UIApplication.shared.open(url)
                 }
            case .navigation:
                if let latitude = self.jobs?[indexPath.row].job.latitude,
                   let longitude = self.jobs?[indexPath.row].job.longitude {
                     print(latitude)
                     print(longitude)
                    self.showMapOption(latitude: latitude, longitude: longitude)
                 }
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let status = jobs?[indexPath.row].isExpand, status == true {
            jobs?[indexPath.row].isExpand = false
        } else {
            jobs?[indexPath.row].isExpand = true
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let movedItem = jobs?.remove(at: sourceIndexPath.row) else {
            return
        }
        jobs?.insert(movedItem, at: destinationIndexPath.row)
        do {
            try RealmManager.shared.realm.write {
                for (index, jobWrapper) in (jobs ?? []).enumerated() {
                    jobWrapper.job.jobSequance = index + 1
                }
            }
        } catch {}
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
}
