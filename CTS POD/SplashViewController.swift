
import UIKit

class SplashViewController: UIViewController {

    private lazy var iconImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logoImage")
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = Colors.colorWhite
        view.hidesWhenStopped = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkCustomer()
    }
    
    private func setupView() {
        view.backgroundColor = Colors.colorPrimary
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(view.frame.size.width/2)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImage.snp.bottom).offset(20)
        }
    }

    private func checkCustomer() {
        if let customer = LocalTempStorage.getValue(fromUserDefault: Customer.self, key: UserDefaultKeys.customer) {
          fetchCustomer(customer: customer)
        } else {
           navigateToCustomer()
        }
    }
    
    private func navigateToCustomer() {
        let controller = GetCustomer.build()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToDashboard(customer: Customer) {
        let controller = Dashboard.build(customer: customer)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func fetchCustomer(customer: Customer) {
        let usecase = GetCustomerUsecase(client: GetCustomerClient())
        LocalTempStorage.storeValue(inUserdefault: customer, key: "customer")
        self.navigateToDashboard(customer: customer)
//        Task {
//            activityIndicator.startAnimating()
//            do {
//                try await usecase.getGustomer(name: customer.domainname, completion: { result in
//                    switch result {
//                    case .success(let customerResult):
//                        if let customer = customerResult.data?.Customer {
//                            SharedObject.shared.customer = customer
//                            LocalTempStorage.storeValue(inUserdefault: customer, key: "customer")
//                            self.navigateToDashboard(customer: customer)
//                        } else {
//                            self.showErrorAlert(message: customerResult.message)
//                        }
//                    case .failure:
//                        self.navigateToCustomer()
//                    }
//                })
//            } catch {
//            }
//        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error! are you want to relogin", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            alert.dismiss(animated: true)
            self.navigateToCustomer()
        }))
        
        navigationController?.present(alert, animated: true)
    }
    
}
