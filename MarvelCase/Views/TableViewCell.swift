//
//  TableViewCell.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    lazy var photo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Black", size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var favButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "star"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(photo)
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            photo.widthAnchor.constraint(equalTo: photo.widthAnchor),
            photo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        ])
        
        addSubview(characterNameLabel)
        NSLayoutConstraint.activate([
            characterNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            characterNameLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.6),
            characterNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 55)
        ])
        
        addSubview(favButton)
        NSLayoutConstraint.activate([
            favButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
