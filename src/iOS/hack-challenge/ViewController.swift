//
//  ViewController.swift
//  hack-challenge
//
//  Created by ravina patel on 5/1/22.
//

import UIKit

class ViewController: UIViewController {

    var tableView = UITableView()
    let cellPadding: CGFloat = 15
    let padding: CGFloat = 24

    let feedReuseIdentifier = "postCellReuse"
    let cellHeight: CGFloat = 150

    var posts: [Post] = [] // todo: get from backend
    var name: String? = "ravina" // todo: get from backend

    
    // components
    var profileButton: UIImageView = {
       let img = UIImageView()
       img.image = UIImage(named: "profile")
       return img
    }()
    var newPostButton: UIImageView = {
       let img = UIImageView()
       img.image = UIImage(named: "plus")
       return img
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ithaca Spots"

        view.backgroundColor = .white
        
        // create default posts - todo: delete when connected to backend
        let default1 = Post(id: UUID.init(), title: "Second Dam", body: "Super cool waterfall with swimming and cliff diving!", poster: "ravina", timeStamp: Date(), rating: 5)
        let default2 = Post(id: UUID.init(), title: "Gorgers", body: "Delicious subs here! Would def recommend!", poster: "ravina", timeStamp: Date(), rating: 2)
        posts = [default1, default2]
        
        // initialize tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: feedReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        [tableView, newPostButton, profileButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        // enable images as buttons
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped(tapGestureRecognizer:)))
        profileButton.isUserInteractionEnabled = true
        profileButton.addGestureRecognizer(profileTapGestureRecognizer)
        
        let plusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusTapped(tapGestureRecognizer:)))
        newPostButton.isUserInteractionEnabled = true
        newPostButton.addGestureRecognizer(plusTapGestureRecognizer)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            newPostButton.bottomAnchor.constraint(equalTo: profileButton.topAnchor, constant: -12),
            newPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            
        ])
    }
    
    // open profile
    @objc func profileTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let profileController = ProfileController()
        profileController.delegate = self
        present(profileController, animated: true, completion: nil)
    }
    
    // new post
    @objc func plusTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let newPostController = NewPostController()
        newPostController.delegate = self
        present(newPostController, animated: true, completion: nil)
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: feedReuseIdentifier, for: indexPath) as? PostTableViewCell {
            let post = posts[indexPath.row]
            cell.delegate = self
            cell.configure(post: post)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

