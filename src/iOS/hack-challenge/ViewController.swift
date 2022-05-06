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
    let cellHeight: CGFloat = 130

    var posts: [Post] = []
    
    // components
    var newPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Post", for: .normal)
        button.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.layer.zPosition = 5
        return button
    }()
    
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()
        title = "Ithaca Spots"
        view.backgroundColor = .white
        
        // create a default posts
        let default1 = Post(id: UUID.init(), title: "Second Dam", body: "Super cool waterfall with swimming and cliff diving!", poster: "Ravina", timeStamp: Date())
        let default2 = Post(id: UUID.init(), title: "Gorgers", body: "Delicious subs here! Would def recommend!", poster: "Ravina", timeStamp: Date())
        posts = [default1, default2]
        
        // initialize tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: feedReuseIdentifier)
        
        [tableView, newPostButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            newPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPostButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // new post modal
    @objc func presentViewController() {
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
            print("about to configure")
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

