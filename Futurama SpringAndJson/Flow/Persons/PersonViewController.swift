//
//  PersonViewController.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 04.12.22.
//

import UIKit
import SnapKit

private extension CGFloat {
    static let fontSize: CGFloat = 24
    static let loaderDimention: CGFloat = 64
    static let spacing: CGFloat = 1
    static let inset: CGFloat = 40
}

protocol IPersonsView: AnyObject {
    func startLoader()
    func stopLoader()
    func showAnotherPerson()
}

class PersonViewController: UIViewController {
    
    private let output: IPersonPresentor?
    
    private var index = 0
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .large
        loader.color = .black
        return loader
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .fontSize)
        label.textColor = .red
        label.text = "Quotes by\nThe Futurama"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .fontSize)
        label.textColor = .black
        label.text = "quoteLabel"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var personView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .fontSize)
        label.text = "nameLabel"
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show another person", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIStackView = {
        let containerView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                quoteLabel,
                personView,
                nameLabel,
                button
            ]
        )
        containerView.axis = .vertical
        containerView.spacing = .spacing
        containerView.distribution = .equalSpacing
        containerView.alignment = .center
        return containerView
    }()
    
    init(output: IPersonPresentor?) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoader()
        setupLabels()
        output?.viewDidLoad()
    }
    
    //MARK: - Private
    
    @objc private func buttonTaped() {
        guard let output = output?.numberOfRows else { return }
        if index < output - 1 {
            index += 1
        } else {
            index = 0
        }
        showAnotherPerson()
    }
    
    private func setupLoader() {
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.loaderDimention)
            make.center.equalToSuperview()
        }
    }
    
    private func setupLabels() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat.inset)
        }
    }
    
    private func hiddenView() {
        loader.isHidden = false
        loader.startAnimating()
        quoteLabel.isHidden = true
        nameLabel.isHidden = true
        personView.isHidden = true
    }
    
    private func showView() {
        loader.stopAnimating()
        loader.isHidden = true
        quoteLabel.isHidden = false
        nameLabel.isHidden = false
        personView.isHidden = false
    }
}

extension PersonViewController: IPersonsView {
    
    func startLoader() {
        loader.isHidden = false
        loader.startAnimating()
        containerView.isHidden = true
        
    }
    func stopLoader() {
        loader.stopAnimating()
        loader.isHidden = true
        containerView.isHidden = false
        }
    
    func showAnotherPerson() {
        guard let image = output?.getItem(for: index).images.main,
        let imageUrl = URL(string: image) else { return }
        let request = URLRequest(url: imageUrl)
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print(error)
                return
            }
            guard let imageData = data else { return }

            DispatchQueue.main.async {
                self.personView.image = UIImage(data: imageData)
            }
        }.resume()
        
    self.quoteLabel.text = output?.getItem(for: self.index).sayings.randomElement()
        
        guard let firstName = output?.getItem(for: self.index).name.first,
              let lastName = output?.getItem(for: self.index).name.last,
              let middleeName = output?.getItem(for: self.index).name.middle else { return }
        
        self.nameLabel.text = "\(firstName) \(middleeName) \(lastName)"
    }
}
