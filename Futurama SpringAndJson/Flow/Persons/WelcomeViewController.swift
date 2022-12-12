//
//  WelcomeViewController.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 03.12.22.
//

import UIKit
import Spring

class WelcomeViewController: UIViewController {
    
    private lazy var futuramaLabel: SpringImageView = {
        let label = SpringImageView()
        label.image = UIImage(named: "Futurama_logo")
        label.snp.makeConstraints { make in
            make.height.equalTo(121)
            make.width.equalTo(374)
        }
        return label
    }()
    
    private lazy var cloudRight: UIImageView = {
        let label = UIImageView()
        label.snp.makeConstraints { make in
            //            make.top.equalToSuperview().inset(32)
            make.width.equalTo(184)
            make.height.equalTo(106)
        }
        label.image = UIImage(named: "cloud1")
        return label
    }()
    
    private lazy var cloudLeft: UIImageView = {
        let label = UIImageView()
        label.snp.makeConstraints { make in
            //            make.top.equalToSuperview().inset(108)
            make.width.equalTo(184)
            make.height.equalTo(106)
        }
        label.image = UIImage(named: "cloud2")
        return label
    }()
    
    private lazy var springButton: SpringButton = {
        let button = SpringButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        button.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var spaceShipImage: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "shuttle")
        return label
    }()
    
    private lazy var containerViewClouds: UIStackView = {
        let containerView = UIStackView(
            arrangedSubviews: [
                cloudLeft,
                cloudRight
            ]
        )
        containerView.axis = .horizontal
        containerView.spacing = 10
        //        containerView.distribution = .equalSpacing
        //        containerView.alignment = .center
        return containerView
    }()
    
    private lazy var containerView: UIStackView = {
        let containerView = UIStackView(
            arrangedSubviews: [
                containerViewClouds,
                futuramaLabel,
                springButton,
                spaceShipImage
            ]
        )
        containerView.axis = .vertical
        containerView.spacing = 10
        containerView.distribution = .equalCentering
        containerView.alignment = .center
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabels()
    }
    
    @objc private func startAction() {
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.cloudRight.frame.origin.x += self.cloudRight.frame.minX
            self.cloudLeft.frame.origin.x -= self.cloudLeft.frame.maxX
            self.spaceShipImage.frame.origin.y += self.spaceShipImage.frame.minY
        })
        
        springButton.animation = "fadeOut"
        futuramaLabel.animation = "fadeOut"
        futuramaLabel.animate()
        springButton.animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cloudLeft.isHidden = true
            self.cloudRight.isHidden = true
            self.spaceShipImage.isHidden = true
            self.showPersonVC()
        }
    }
    
    private func showPersonVC() {
        let service = PersonService()
        let dataSource = PersonsViewDataSource()
        let presentor = PersonsPresentor(service: service,
                                         dataSource: dataSource
        )
        let personViewController = PersonViewController(output: presentor)
        presentor.view = personViewController
        self.present(personViewController, animated: true)
    }
    
    private func setupLabels() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(30)
        }
    }
}

