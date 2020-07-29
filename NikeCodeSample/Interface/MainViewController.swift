//
//  MainViewController.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/21/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

enum State {
    case empty
    case loading
    case viewing
}

class MainViewController: UITableViewController {
    
    let networkService = NetworkService()
        
    var state: State = .empty {
        didSet {
            
            if state == .loading {
                refreshContent()
            }
            
            DispatchQueue.main.async { [unowned self] in
                if let error = self.error {
                    self.errorLabel.text = error.localizedDescription
                }
                self.tableView.reloadData()
                self.configureViews()
            }
        }
    }
    
    fileprivate var error: Error?
    
    fileprivate var albumList: [AlbumModel] = []

    fileprivate lazy var errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 20, height: 70.0))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .gray
        label.font = .italicSystemFont(ofSize: 14.0)
        return label
    }()
    
    fileprivate lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 20, height: 70.0))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .italicSystemFont(ofSize: 14.0)
        label.backgroundColor = .gray
        label.text = "No albums retrieved."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.register(AlbumCell.classForCoder(), forCellReuseIdentifier: "AlbumCellId")
        
        self.tableView.rowHeight = 70.0
        
        self.clearsSelectionOnViewWillAppear = true
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        self.state = .empty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if state == .empty {
            state = .loading
        }
    }
    
    func configureViews() {
        switch state {
        case .empty:
            self.tableView.tableFooterView = emptyLabel
        case .viewing:
            self.tableView.tableHeaderView = nil
            self.tableView.tableFooterView = nil

        case .loading:
            self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil
        }
        if self.error != nil{
            self.tableView.tableHeaderView = errorLabel
        }
    }

        
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {	
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCellId", for: indexPath) as? AlbumCell  else {
            let badCell = UITableViewCell()
            badCell.textLabel?.text = "Unhandled cell class dequeued!!!"
            return badCell
        }
        
        cell.viewModel = AlbumViewModel(model: albumList[indexPath.row])

        return cell
    }
        
    @objc func handleRefreshControl() {
        state = .loading
    }

    private func refreshContent() {
        DispatchQueue.main.async { [unowned self] in
            self.refreshControl?.beginRefreshing()
        }
        
        DispatchQueue.global(qos: .background).async {
            self.networkService.fetchRecords { [unowned self] (fetchResult) in
                
                defer {
                    DispatchQueue.main.async { [unowned self] in
                        self.refreshControl?.endRefreshing()
                    }
                }
                
                if let error = fetchResult.error {
                    self.error = error
                } else {
                    self.error = nil
                }
                
                if let list = fetchResult.results,
                    list.count > 0 {
                    self.albumList = list
                    self.state = .viewing
                    print("Refresh successful")
                } else {
                    print("Refresh failed to acquire results.")
                    self.state = .empty
                }
            }
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < albumList.count else {
            print("Selected indexPath row greater than size fo album list!")
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? AlbumCell else { return }
        let model = cell.viewModel
     
        let detailvc = DetailViewController()
        detailvc.viewModel = model
        
        navigationController?.pushViewController(detailvc, animated: true)
    }
}



