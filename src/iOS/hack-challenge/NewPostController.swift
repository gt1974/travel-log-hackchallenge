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
        label.text = "New Spot"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    var titleInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Spot Name"
        input.textColor = .black
        input.font = .boldSystemFont(ofSize: 22)
        return input
    }()
    var ratingInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Rating 1/5"
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
    var star1: UIImageView = {
       return UIImageView()
    }()
    var star2: UIImageView = {
       return UIImageView()
    }()
    var star3: UIImageView = {
       return UIImageView()
    }()
    var star4: UIImageView = {
       return UIImageView()
    }()
    var star5: UIImageView = {
       return UIImageView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Post"
        
        [dismissButton, modalTitle, titleInput, bodyInput, star1, star2, star3, star4, star5].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        [star1, star2, star3, star4, star5].forEach { star in
            star.isUserInteractionEnabled = true
        }
        updateStars(rating: 3)
        
        // enable images as buttons
        let star1TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(star1Tapped(tapGestureRecognizer:)))
        star1.addGestureRecognizer(star1TapGestureRecognizer)
        let star2TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(star2Tapped(tapGestureRecognizer:)))
        star2.addGestureRecognizer(star2TapGestureRecognizer)
        let star3TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(star3Tapped(tapGestureRecognizer:)))
        star3.addGestureRecognizer(star3TapGestureRecognizer)
        let star4TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(star4Tapped(tapGestureRecognizer:)))
        star4.addGestureRecognizer(star4TapGestureRecognizer)
        let star5TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(star5Tapped(tapGestureRecognizer:)))
        star5.addGestureRecognizer(star5TapGestureRecognizer)
        
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
            
            star1.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: 12),
            star1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            star2.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: 12),
            star2.leadingAnchor.constraint(equalTo: star1.trailingAnchor, constant: 8),
            star3.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: 12),
            star3.leadingAnchor.constraint(equalTo: star2.trailingAnchor, constant: 8),
            star4.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: 12),
            star4.leadingAnchor.constraint(equalTo: star3.trailingAnchor, constant: 8),
            star5.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: 12),
            star5.leadingAnchor.constraint(equalTo: star4.trailingAnchor, constant: 8),
            
            bodyInput.topAnchor.constraint(equalTo: star5.bottomAnchor, constant: margin),
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
        if let title = titleInput.text, let rating = ratingInput.text, let body = bodyInput.text, let name = delegate?.name {
            if title != "" && body != "" {
                self.delegate?.posts.append(Post(id: UUID.init(), title: title, body: body, poster: name, timeStamp: Date(), rating: Int(rating)))
                self.delegate?.tableView.reloadData()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // star tapped
    @objc func star1Tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        updateStars(rating: 1)
    }
    @objc func star2Tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        updateStars(rating: 2)
    }
    @objc func star3Tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        updateStars(rating: 3)
    }
    @objc func star4Tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        updateStars(rating: 4)
    }
    @objc func star5Tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        updateStars(rating: 5)
    }
    @objc func updateStars(rating: Int) {
        let stars: [UIImageView] = [star1, star2, star3, star4, star5]
        for i in 1...5 {
            if (i > rating) {
                stars[i-1].image = UIImage(named: "star-empty")
            }
            else {
                stars[i-1].image = UIImage(named: "star-filled")
            }
        }
        ratingInput.text = String(rating)
    }

}


import Foundation
