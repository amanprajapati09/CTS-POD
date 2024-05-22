
import Foundation

import UIKit
import RxSwift

final class TextareaContainer: BaseContainerView {
    
    let bag = DisposeBag()
    
    required init(models: ValueOption) {
        super.init(models: models)
        prepareCheckView()
        bindValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popSemiBold
        view.textColor = Colors.colorBlack
        view.textAlignment = .left
        view.attributedText = models.attributedTitle
        view.font = Fonts.popRegular
        return view
    }()
    
    private lazy var textField: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Colors.colorGray.cgColor
        view.snp.makeConstraints { $0.height.equalTo(50) }
        view.text = models.title
        view.textColor = .gray
        view.font = Fonts.popRegular16
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    func prepareCheckView()  {
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        stackView.addArrangedSubview(textField)
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        if let value = models.prefilledValue, !value.isEmpty {
            textField.text = models.prefilledValue
        } else {
            textField.text = models.title
        }
    }
    
    func bindValue()  {
        textField.rx.didChange.subscribe { [weak self] element in
            self?.didUpdateValue?(CheckListItem(id: self?.models.id ?? "", value: self?.textField.text ?? ""))
        }.disposed(by: bag)
        textField.rx.didBeginEditing.subscribe { [weak self] element in
            guard let self else { return }
            if self.textField.text == models.title {
                self.textField.text = ""
            }
            self.textField.textColor = .black
        }.disposed(by: bag)
        textField.rx.didEndEditing.subscribe { [weak self] element in
            guard let self else { return }
            if self.textField.text.isEmpty {
                self.textField.text = models.title
                self.textField.textColor = UIColor.lightGray
            }
        }.disposed(by: bag)
    }
}
