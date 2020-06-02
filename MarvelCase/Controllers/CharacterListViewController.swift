//
//  ViewController.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

final class CharacterListViewController: UIViewController {
    
    fileprivate var activityIndicator: LoadingIndicator!
    
    private var offSet = 0
    
    private var data = [Results]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stop()
                self?.openingIndicator.stopAnimating()
                if let empty = self?.data.isEmpty {
                    self?.tableView.isHidden = empty
                }
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        table.tableHeaderView = UIView()
        return table
    }()
    
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
        activityIndicator = LoadingIndicator(scrollView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        APIManager.shared.requestForCharacterList(sender: self, selector: #selector(response(data:)), offset: "\(offSet)")
    }
    
    @objc func response(data: Any) {
        if let response = data as? CharacterListResponseModel {
            self.data += response.data.results
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.data = self.data[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            DispatchQueue.global(qos: .utility).async {
                self.offSet += 30
                APIManager.shared.requestForCharacterList(sender: self, selector: #selector(self.response(data:)), offset: "\(self.offSet)")
            }
        }
    }
}


