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
    
    private var data = CharacterListViewModel()
    
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
    
    private func getList(_ list: String) {
        data.fetchChracters(offSet: "\(list)") { (success) in
            if success {
                  DispatchQueue.main.async { [weak self] in
                    self?.offSet += 30
                    self?.tableView.reloadData()
                    self?.activityIndicator.stop()
                    self?.openingIndicator.stopAnimating()
                        if let empty = self?.data.characterData.isEmpty {
                        self?.tableView.isHidden = empty
                    }
                }
            }
        }
    }
}
//MARK: - Setup Layouts
extension CharacterListViewController {
    private func setupLayouts() {
        view.backgroundColor = .white
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
        return data.characterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        cell.data = self.data.characterData[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CharacterDetailBuilder().build(characterData: self.data.characterData[indexPath.item], PersistantManager.shared)
        navigationController?.pushViewController(vc, animated: true)
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


