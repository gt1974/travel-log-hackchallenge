//
//  PostTableViewCell.swift
//  hack-challenge
//
//  Created by ravina patel on 5/1/22.
//

import UIKit

class PostTableViewCell: UITableViewCell  {
    
    var delegate: ViewController?
    var id: UUID
    var post: Post?
    
    // setup
    func configure(post: Post) {
        if let idPost = post.id {
            id = idPost
        }
        if let poster = post.poster {
            posterLabel.text = poster
        }
        if let title = post.title {
            titleLabel.text = title
        }
        if let body = post.body {
            bodyLabel.text = body
        }
        if let rating = post.rating {
            let imgFile = "rating-" + String(rating)
            ratingImage.image = UIImage(named: imgFile)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d | hh:mm"
        if let date = post.timeStamp {
            timeStampLabel.text = dateFormatter.string(from: date)
        }
        self.post = post
    }
    
    // components
    var posterLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = .gray
        return lab
    }()
    var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .boldSystemFont(ofSize: 22)
        return lab
    }()
    var bodyLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 16)
        return lab
    }()
    var timeStampLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    var ratingImage: UIImageView = {
        return UIImageView()
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.id = UUID()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [posterLabel, titleLabel, bodyLabel, ratingImage].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        
        setupConstraints()
    }
    
    let padding: CGFloat = 15
    let iconSize: CGFloat = 18
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -padding*2),
            
            posterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding/2),
            posterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -padding*2),
            
            ratingImage.topAnchor.constraint(equalTo: posterLabel.bottomAnchor, constant: padding/2),
            ratingImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            bodyLabel.topAnchor.constraint(equalTo: ratingImage.bottomAnchor, constant: padding),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            bodyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -padding*2),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
