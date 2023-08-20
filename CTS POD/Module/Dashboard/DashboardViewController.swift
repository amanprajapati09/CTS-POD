//
//  DashboardViewController.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    private let viewModel: DashboardViewModel
    private let optionList: [DashboardDisplayModel]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setLogo()
        prepareCollectionView()
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
    
    private func setLogo() {
        guard let customer = viewModel.customer else { return }
        if let imageData = Data(base64Encoded: customer.logo) {
            iconImage.image = UIImage(data: imageData)
        }
    }
    
    private func setupView() {
        view.backgroundColor = Colors.colorPrimary
        
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
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel.customer?.workflow.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashBoardCell.reuseIdentifier, for: indexPath)
        (cell as? DashBoardCell)?.dashboardDisplayModel = optionList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2 - 30, height: view.frame.size.width/2 - 30)
    }
    
}
