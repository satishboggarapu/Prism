//
//  LikesAndRepostsViewController.swift
//  Prism
//
//  Created by Shiv Shah on 5/27/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import MaterialComponents
import Material

class LikesAndRepostsViewController: UIViewController {
    
    private var backButton: FABButton!
    private var NavigationView: UIView!
    var onDoneBlock : ((Bool) -> Void)?
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    var tableViewHeight: CGFloat = 64




    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    private func setupView(){
        initializeTableView()

        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        
    }
    
    private func initializeTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .collectionViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.dropShadow()

        
        // initialize refresh control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
        
        
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        print("refreshed")
       
    }
}

extension LikesAndRepostsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LikesAndRepostsTableViewCell(style: .default, reuseIdentifier: "cell")

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight
    }

}
