//
//  ViewController.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

final class CharacterListViewController: UIViewController {
    
    private var offSet = 0
    
    private var data: CharacterListViewModel?
    
    private var favorites: FavoriteListViewModel?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CharacterTableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        table.tableHeaderView = UIView()
        return table
    }()
    
    private lazy var activityIndicator = LoadingIndicator(scrollView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
    
    private lazy var openingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.center = CGPoint(x: view.center.x, y: view.center.y - 30)
        indicator.color = .darkGray
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Heros"
        setupLayouts()
        getList(String(self.offSet))

    }
    
    init(data: CharacterListViewModel?,favorites: FavoriteListViewModel?) {
        self.data = data
        self.favorites = favorites
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func favoriteTapped(_ button: UIButton) {
        navigationController?.pushViewController(CharacterListBuilder().build(data: FavoriteListViewModel()), animated: true)
    }
    
    private func getList(_ list: String) {
        if data != nil {
            data?.fetchChracters(offSet: "\(list)") { (success) in
                if success {
                    DispatchQueue.main.async { [weak self] in
                        self?.offSet += 30
                        self?.tableView.reloadData()
                        self?.activityIndicator.stop()
                        self?.openingIndicator.stopAnimating()
                        if let empty = self?.data?.characterData.isEmpty {
                            self?.tableView.isHidden = empty
                        }
                    }
                }
            }
        } else if favorites != nil {
            favorites?.fetchChracters(complete: { (success) in
                if success {
                    DispatchQueue.main.async { [weak self] in
                        self?.offSet += 30
                        self?.tableView.reloadData()
                        self?.activityIndicator.stop()
                        self?.openingIndicator.stopAnimating()
                        if let empty = self?.favorites?.favCharacters.isEmpty {
                            self?.tableView.isHidden = empty
                        }
                    }
                }
            })
        }
    }
}
//MARK: - Setup Layouts
extension CharacterListViewController {
    private func setupLayouts() {
        view.backgroundColor = .white
        
        if self.data != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favs", style: .done, target: self, action: #selector(favoriteTapped(_:)))
        }
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(openingIndicator)
    }
}

//MARK: - TableViewDelegate Methods
extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.characterData.count ?? favorites?.favCharacters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        cell.data = self.data?.characterData[indexPath.item]
        cell.favData = self.favorites?.favCharacters[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let characterData = self.data?.characterData[indexPath.item]  {
            let vc = CharacterDetailBuilder().build(characterData: characterData, PersistantManager.shared)
            navigationController?.pushViewController(vc, animated: true)
        }
        if let fav = favorites?.favCharacters[indexPath.item]  {
            let characterData = CharacterResults(id: Int(fav.id), name: fav.name, description: fav.desc, thumbnail: Thumbnail(path: fav.imageURL, extension: fav.imageExt))
            let vc = CharacterDetailBuilder().build(characterData: characterData, PersistantManager.shared)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            DispatchQueue.global(qos: .utility).async {
                self.getList(String(self.offSet))
            }
        }
    }
}


