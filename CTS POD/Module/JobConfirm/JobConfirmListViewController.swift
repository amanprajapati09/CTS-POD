import UIKit
import RxSwift
import Combine

class JobConfirmListViewController: BaseViewController<JobConfirmListViewModel> {

    private var isAllSelected = true
    private var cancellable = Set<AnyCancellable>()
    let disposeBag = DisposeBag()
    var jobs: [JobDisplayModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var buttonDriverSign: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorBlue
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.driverSignTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonDriverSignTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        view.tag = 0
        return view
    }()
    
    private lazy var buttonSupervisorSign: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorGreen
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.superVisionTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonSupervisorSignTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        view.tag = 0
        return view
    }()
    
    private lazy var buttonAll: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colororagne
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.allTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonAllTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        view.tag = 0
        return view
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonDriverSign, buttonSupervisorSign, buttonAll])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
    
    private lazy var tableView: UITableView = {
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
        tableView.register(JobConfirmListTableViewCell.self)
        setupView()
        bindView()
        if let value = LocalTempStorage.getValue(key: UserDefaultKeys.jobDisplayOption) as? String,
           let option = JobConfirmListViewModel.JobDisplayOption(rawValue: value) {
            viewModel.fetchList(option: option)
        } else {
            viewModel.fetchDefaultList()
        }
    }
    
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.tintColor = .black
        self.title = viewModel.configuration.string.navigationTitle
        if let navigationBar = navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black, // You can change this color to the desired one
                .font: UIFont.boldSystemFont(ofSize: 17) // You can change the font and size as needed
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        let sortOptionButton = UIBarButtonItem(image: UIImage(named: "done"),
                                               style: .plain, target: self,
                                          action: #selector(navigationRightClick))
        let doneButton = UIBarButtonItem(image: UIImage(named: "more"),
                                          style: .done, target: self,
                                          action: #selector(moreButtonClick))
        navigationItem.rightBarButtonItems = [sortOptionButton, doneButton]
    }
    
    @objc
    private func navigationRightClick() {
        guard let jobs, jobs.count > 0 else { 
            showSelectedJobAlert()
            return }
        let selectedItems = jobs.filter {
            $0.isSelected == true && $0.job.driverSign != nil && $0.job.supervisonSign != nil
        }
        if selectedItems.count > 0 {
            selectedItems.forEach { item in
                do {
                    try RealmManager.shared.realm.write {
                        item.job.jobStatus = StatusString.jobConfirm.rawValue
                    }
                    navigationController?.popToViewController(ofClass: DashboardViewController.self)
                } catch {
                    print("error in update the data")
                }
            }
//            viewModel.fetchList()
        } else {
            showSelectedJobAlert(message: "Please select jobs which complete driver and supervisor sign")
        }
    }

    @objc
    private func moreButtonClick() {
        let sortOptionSheet = UIAlertController(title: "",
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
        sortOptionSheet.addAction(UIAlertAction(title: JobConfirmListViewModel.JobDisplayOption.defaultView.rawValue, style: .default, handler: { [weak self]  action in
            self?.viewModel.fetchDefaultList()
            LocalTempStorage.storeValue(value: JobConfirmListViewModel.JobDisplayOption.defaultView.rawValue, key: UserDefaultKeys.jobDisplayOption)
            self?.tableView.isEditing = false
        }))
        sortOptionSheet.addAction(UIAlertAction(title: JobConfirmListViewModel.JobDisplayOption.optimizedRoute.rawValue, style: .default, handler: { [weak self] action in
            self?.viewModel.sortBasedOnDistance()
            self?.tableView.isEditing = false
            LocalTempStorage.storeValue(value: JobConfirmListViewModel.JobDisplayOption.optimizedRoute.rawValue, key: UserDefaultKeys.jobDisplayOption)
        }))
        sortOptionSheet.addAction(UIAlertAction(title: JobConfirmListViewModel.JobDisplayOption.dragAndDrop.rawValue, style: .default, handler: { [weak self] action in
            self?.viewModel.sortBasedOnPosition()
            LocalTempStorage.storeValue(value: JobConfirmListViewModel.JobDisplayOption.dragAndDrop.rawValue, key: UserDefaultKeys.jobDisplayOption)
            self?.tableView.isEditing = true
        }))
        sortOptionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(sortOptionSheet, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(viewModel: JobConfirmListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = Colors.forgotPasswordViewBackground
        
        view.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonContainer.snp.bottom).offset(10)
        }
    }
    
    private func bindView() {
        viewModel.$jobList.subscribe(on: DispatchQueue.main)
            .sink { [weak self] jobList in
                self?.jobs = jobList
                self?.updateButtons()
            }.store(in: &cancellable)
    }
    
    @objc
    private func buttonDriverSignTap() {
        guard let jobs, jobs.filter({ $0.isSelected == true }).count > 0 else { return }
        let signatureView = Signature.build(signType: .driverSign)
        signatureView.viewModel.complition = { data in
            self.updateSignValue(sign: .driverSign, data: data)
            signatureView.dismiss(animated: true)
        }
        present(signatureView, animated: true)
    }
    
    @objc
    private func buttonSupervisorSignTap() {
        guard let jobs, jobs.filter({ $0.isSelected == true }).count > 0 else { return }
        let signatureView = Signature.build(signType: .supervisorSign)
        signatureView.viewModel.complition = { data in
            self.updateSignValue(sign: .supervisorSign, data: data)
            signatureView.dismiss(animated: true)
        }
        present(signatureView, animated: true)
    }
    
    @objc
    private func buttonAllTap() {
        jobs = jobs?.map({ value in
            return JobDisplayModel(isExpand: value.isExpand,
                                   job: value.job,
                                   isSelected: isAllSelected, distance: 0)
        })
        isAllSelected = !isAllSelected
        tableView.reloadData()
        updateButtons()
    }
    
    private func updateSignValue(sign: SignatureType, data: Data) {
        jobs?.forEach({ jobs in
            if jobs.isSelected {
                do {
                    try RealmManager.shared.realm.write {
                        if sign == .driverSign {
                            jobs.job.driverSign = data
                        } else {
                            jobs.job.supervisonSign = data
                        }
                    }
                } catch {
                    print("error in update the data")
                }
            }
        })
        isAllSelected = false
        buttonAllTap()
        tableView.reloadData()
    }
    
    private func showSelectedJobAlert(message: String = "No Jobs are available to confirm!") {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension JobConfirmListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JobConfirmListTableViewCell = tableView.dequeue(JobConfirmListTableViewCell.self, for: indexPath)
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
            self.updateButtons()
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
    
    private func updateButtons() {
        if let jobs, jobs.filter({ $0.isSelected == true }).count > 0 {
            buttonDriverSign.isHidden = false
            buttonSupervisorSign.isHidden = false
        } else {
            buttonDriverSign.isHidden = true
            buttonSupervisorSign.isHidden = true
        }
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
