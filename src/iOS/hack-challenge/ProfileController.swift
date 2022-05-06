//
//  ProfileController.swift
//  hack-challenge
//
//  Created by ravina patel on 5/6/22.
//

import UIKit

// todo: show posts filtered by name

class ProfileController: UIViewController {
    
    var delegate: ViewController?
    
    // components
    var modalTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [dismissButton, modalTitle].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        modalTitle.text = delegate?.name
        
        setupConstraints()
    }
    
    let margin: CGFloat = 24
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            modalTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            modalTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            dismissButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // actions
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
}

import Foundation
