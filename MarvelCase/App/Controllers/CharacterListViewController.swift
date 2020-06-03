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
        table.backgroundColor = .black
        table.separatorColor = #colorLiteral(red: 0.1239350662, green: 0.1239350662, blue: 0.1239350662, alpha: 1)
        table.tableHeaderView = UIView()
        return table
    }()
    
    private lazy var titleView: UIView = {
        let v = UIView()
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 66))
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "marvel")
        v.addSubview(logo)
        return v
    }()
    
    private lazy var activityIndicator = LoadingIndicator(scrollView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
    
    private lazy var openingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.center = CGPoint(x: view.center.x, y: view.center.y - 30)
        indicator.color = .red
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        getList(self.offSet)
    }
    
    init(data: CharacterListViewModel?,favorites: FavoriteListViewModel) {
        self.data = data
        self.favorites = favorites
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func favoriteTapped(_ button: UIButton) {
        navigationController?.pushViewController(CharacterListBuilder().build(fav: FavoriteListViewModel()), animated: true)
    }
    
    private func getList(_ list: Int) {
        if data != nil && favorites != nil {
            favorites?.fetchChracters(inset: list, complete: { _ in })
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
        } else if data == nil && favorites != nil {
            fetchFavs(list)
        }
    }
    
    private func fetchFavs(_ list: Int) {
        favorites?.fetchChracters(inset: list, complete: { (success) in
            DispatchQueue.main.async { [weak self] in
                if success {
                    self?.offSet += 30
                    self?.tableView.reloadData()
                    self?.activityIndicator.stop()
                    self?.openingIndicator.stopAnimating()
                    if let empty = self?.favorites?.favCharacters.isEmpty {
                        self?.tableView.isHidden = empty
                    }
                } else {
                    self?.openingIndicator.stopAnimating()
                    self?.activityIndicator.remove()
                }
            }
        })
    }
}
//MARK: - Setup Layouts
extension CharacterListViewController {
    private func setupLayouts() {
        view.backgroundColor = .black
        
        if self.data != nil {
            titleView.bounds = CGRect(x: 0, y: 0, width: 100, height: 66)
            navigationItem.titleView = titleView
            let image = #imageLiteral(resourceName: "list").maskWithColor(.white)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(favoriteTapped(_:)))
        } else {
            navigationItem.title = "Favorites"
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
        if data != nil && favorites != nil {
            cell.data = self.data?.characterData[indexPath.item]
            
        } else {
            cell.favData = self.favorites?.favCharacters[indexPath.item]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data != nil && favorites != nil {
            var isFav = false
            guard let int = data?.characterData[indexPath.item].id, let favs = favorites?.favCharacters else { return }
            print(favs)
            
            if favs.contains(where: { Int($0.id) == int }) {
                isFav = true
            } else {
                isFav = false
            }
            let vc = CharacterDetailBuilder().build(viewController: self, characterData: (self.data?.characterData[indexPath.item])!,isFav: isFav)
            navigationController?.pushViewController(vc, animated: true)
        } else if data == nil && favorites != nil {
            if let fav = favorites?.favCharacters[indexPath.item]  {
                let characterData = CharacterResults(id: Int(fav.id), name: fav.name, description: fav.desc, thumbnail: Thumbnail(path: fav.imageURL, extension: fav.imageExt))
                let vc = CharacterDetailBuilder().build(viewController: self, characterData: characterData,isFav: true)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            DispatchQueue.global(qos: .utility).async {
                self.getList(self.offSet)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = favorites?.favCharacters[indexPath.item].id else { return }
            favorites?.deleteLocalStorage(Int(id))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if data == nil {
            return .delete
        } else { return .none }
    }
}
extension CharacterListViewController: CharacterDetailViewControllerDelegate {
    func characterDetailViewController(_ vc: UIViewController, character: CharacterResults) {
        favorites?.addByID(character: character)
        print(character.id!)
        tableView.reloadData()
    }
    
    func characterDetailViewController(_ deleteByID: Int) {
        favorites?.deleteLocalStorage(deleteByID)
        tableView.reloadData()
    }
    
}

