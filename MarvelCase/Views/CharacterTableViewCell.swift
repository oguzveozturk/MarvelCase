//
//  TableViewCell.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit
import Kingfisher

final class CharacterTableViewCell: UITableViewCell {
        
    var data: Results? {
        didSet {
            guard let data = data else { return }
            nameLabel.text = data.name
            if let url = URL(string: (data.thumbnail?.path ?? "") + ImageSizes.small + (data.thumbnail?.extension ?? "")) {
                photo.kf.setImage(with: url, options: [ .scaleFactor(UIScreen.main.scale), .transition(.fade(0.4)), .cacheOriginalImage])
            }
        }
    }
    
    lazy var photo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 0.8604507446, green: 0.8553362489, blue: 0.8643824458, alpha: 1)
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirMedium, size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(photo)
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            photo.widthAnchor.constraint(equalTo: photo.widthAnchor),
            photo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.65),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
