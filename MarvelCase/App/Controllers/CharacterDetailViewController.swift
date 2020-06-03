//
//  CharacterDetailViewController.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit
import Kingfisher

protocol CharacterDetailViewControllerDelegate:class {
    func characterDetailViewController(_ deleteByID: Int)
    func characterDetailViewController(_ vc: UIViewController, character: CharacterResults)
}

final class CharacterDetailViewController: UIViewController {
    
    var characterData: CharacterResults?
    weak var delegate:CharacterDetailViewControllerDelegate?
    let isFav:Bool!
    
    let generator = UISelectionFeedbackGenerator()
    
    private var data = ComicListViewModel()
        
    private lazy var favoriteAdd: UIBarButtonItem = {
        let image = #imageLiteral(resourceName: "heart").maskWithColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let button = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(favAddTapped(_:)))
        return button
    }()

    private lazy var favoriteRemove: UIBarButtonItem = {
        let image = #imageLiteral(resourceName: "heartFilled").maskWithColor(#colorLiteral(red: 1, green: 0.2545840519, blue: 0.1990211341, alpha: 1))
        let button = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(favRemoveTapped(_:)))
        return button
    }()
    
    private lazy var image: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 14
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirBlack, size: 21)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.text = self.characterData?.name
        return label
    }()
    
    private lazy var characterDescription: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: Fonts.AvenirLight, size: 13)
        tv.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.isScrollEnabled = false
        if characterData?.description?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            tv.text = Errors.noInfo
        } else {
            tv.text = "\(characterData?.description ?? Errors.noInfo)"
        }
        return tv
    }()
    
    private lazy var titleView: UIView = {
        let v = UIView()
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 66))
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "marvel")
        v.addSubview(logo)
        return v
    }()
    
    private lazy var comicsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirBlack, size: 20)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = .black
        label.text = "Last 10 comics after 2005"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bottomBorder: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        return v
    }()
    
    private lazy var openingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.center = CGPoint(x: view.center.x, y: view.center.y + 60)
        indicator.color = .red
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ComicTableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        table.isUserInteractionEnabled = false
        table.isHidden = true
        table.tableFooterView = UIView()
        table.separatorColor = #colorLiteral(red: 0.1239350662, green: 0.1239350662, blue: 0.1239350662, alpha: 1)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        getHeroImage(path: characterData?.thumbnail?.path, ext: characterData?.thumbnail?.extension)
        getList("\(characterData?.id ?? 0)")
        favoriteCheck()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.rowHeight = tableView.frame.height/10
    }
    
    private func getList(_ characterID: String) {
        data.fetchChracters(characterID: characterID) { (success) in
            DispatchQueue.main.async { [weak self] in
                if success {
                    self?.tableView.reloadData()
                    self?.openingIndicator.stopAnimating()
                    if let empty = self?.data.orderedComicData.isEmpty {
                        self?.tableView.isHidden = empty
                    }
                }
            }
        }
    }
    
    private func getHeroImage(path: String?, ext: String?) {
        if let safePath = path, let safeExt = ext, let url = URL(string: safePath + ImageSizes.incredible + safeExt) {
            image.kf.setImage(with: url, options: [ .scaleFactor(UIScreen.main.scale), .transition(.fade(0.4)), .cacheOriginalImage])
        }
    }
    
    init(result: CharacterResults,isFav: Bool) {
        self.characterData = result
        self.isFav = isFav
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func favoriteCheck() {
        self.isFav ? (self.navigationItem.rightBarButtonItem = self.favoriteRemove) : (self.navigationItem.rightBarButtonItem = self.favoriteAdd)
    }
    
    @objc func favAddTapped(_ button: UIButton) {
        generator.prepare()
        generator.selectionChanged()
        delegate?.characterDetailViewController(self, character: characterData!)
        self.navigationItem.rightBarButtonItem = self.favoriteRemove
    }
    
    @objc func favRemoveTapped(_ button: UIButton) {
        generator.prepare()
        generator.selectionChanged()
        delegate?.characterDetailViewController((characterData?.id)!)
        self.navigationItem.rightBarButtonItem = self.favoriteAdd
    }
}

//MARK: - TableViewDelegate Methods
extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.orderedComicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ComicTableViewCell else { return UITableViewCell() }
        cell.data = self.data.orderedComicData[indexPath.item]
        return cell
    }
}
//MARK: - Setup Layouts
extension CharacterDetailViewController {
    private func setupLayouts() {
        view.backgroundColor = .black
        self.navigationItem.rightBarButtonItem = self.favoriteAdd
        titleView.bounds = CGRect(x: 0, y: 0, width: 100, height: 66)
        navigationItem.titleView = titleView
        
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            image.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.38),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.2)
        ])
        
        view.addSubview(name)
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: image.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            name.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        view.addSubview(characterDescription)
        NSLayoutConstraint.activate([
            characterDescription.topAnchor.constraint(equalTo: name.bottomAnchor),
            characterDescription.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -1),
            characterDescription.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            characterDescription.trailingAnchor.constraint(equalTo: name.trailingAnchor),
        ])
        
        view.addSubview(comicsLabel)
        NSLayoutConstraint.activate([
            comicsLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            comicsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            comicsLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            comicsLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        view.addSubview(bottomBorder)
        NSLayoutConstraint.activate([
            bottomBorder.topAnchor.constraint(equalTo: comicsLabel.bottomAnchor),
            bottomBorder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBorder.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bottomBorder.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
        
        view.addSubview(openingIndicator)
    }
}
