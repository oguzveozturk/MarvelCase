//
//  ComicTableViewCell.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit
import Kingfisher

final class ComicTableViewCell: UITableViewCell {
    
    var data: ComicResults? {
        didSet {
            guard let data = data else { return }
            nameLabel.text = data.title
            dateLabel.text = "On sale date: \(data.orderedDate ?? Date())"
            if let url = URL(string: (data.thumbnail?.path ?? "") + ImageSizes.small + (data.thumbnail?.extension ?? "")) {
                photo.kf.setImage(with: url, options: [ .scaleFactor(UIScreen.main.scale), .transition(.fade(0.3)), .cacheOriginalImage])
            }
            
            
        }
    }
    
    private lazy var photo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 0.8604507446, green: 0.8553362489, blue: 0.8643824458, alpha: 1)
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirMedium, size: 13)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirMedium, size: 11)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedView = UIView()
        backgroundColor = .black
        selectedView.backgroundColor = #colorLiteral(red: 0.109942995, green: 0.109942995, blue: 0.109942995, alpha: 1)
        selectedBackgroundView = selectedView
        
        addSubview(photo)
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            photo.widthAnchor.constraint(equalTo: photo.widthAnchor),
            photo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50)
        ])
        
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
