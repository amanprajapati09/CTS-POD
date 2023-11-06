
import UIKit

class SignatureImageCollectionViewCell: UICollectionViewCell, Reusable {
    
    var didCancelImage: ((_ index: Int)->Void)?
    
    private(set) lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "expand_icon")
        return view
    }()

    private(set) lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "cancel_item"), for: .normal)
        view.addTarget(self, action: #selector(cancelImageTap), for: .touchUpInside)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = Colors.viewBackground
        self.contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.center.equalToSuperview()
        }
        self.contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.trailing.top.equalToSuperview()
        }
    }

    @objc
    func cancelImageTap() {
        didCancelImage?(closeButton.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
