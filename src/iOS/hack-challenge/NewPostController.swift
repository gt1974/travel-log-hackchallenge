//
//  NewPostController.swift
//  hack-challenge
//
//  Created by ravina patel on 5/1/22.
//

import UIKit

class NewPostController: UIViewController {
    
    var delegate: ViewController?
    
    // components
    var modalTitle: UILabel = {
        let label = UILabel()
        label.text = "New Post"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    var titleInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Title"
        input.textColor = .black
        input.font = .boldSystemFont(ofSize: 22)
        return input
    }()
    var nameInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Name"
        input.textColor = .black
        input.font = .systemFont(ofSize: 14)
        return input
    }()
    var bodyInput: UITextField = {
        let input = UITextField()
        input.placeholder = "The good, the bad, the ugly..."
        input.textColor = .black
        input.font = .systemFont(ofSize: 16)
        return input
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Post"
        
        [dismissButton, modalTitle, titleInput, nameInput, bodyInput].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        setupConstraints()
    }
    
    let margin: CGFloat = 24
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            modalTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            modalTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleInput.topAnchor.constraint(equalTo: modalTitle.bottomAnchor, constant: margin),
            titleInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            titleInput.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -margin*2),
            
            nameInput.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: 12),
            nameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            nameInput.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -margin*2),
            
            bodyInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: margin),
            bodyInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            bodyInput.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -margin*2),
            
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            dismissButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // actions
    @objc func close() {
        if let title = titleInput.text, let name = nameInput.text, let body = bodyInput.text {
            if title != "" && body != "" {
                self.delegate?.posts.append(Post(id: UUID.init(), title: title, body: body, poster: name, timeStamp: Date()))
                self.delegate?.tableView.reloadData()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

}


import Foundation
