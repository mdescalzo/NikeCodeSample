//
//  MainViewController.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/21/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

enum State {
    case error
    case empty
    case loading
    case viewing
}

class MainViewController: UITableViewController {
    
    let networkService = NetworkService()
    
    private var thumbnailCache = NSCache<NSString,UIImage>()
    
    fileprivate var albumList: [AlbumModel] = []
    
    var state: State = .viewing {
        didSet {
            if state == .loading {
                refreshContent()
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
                //                self.configureFooterView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(AlbumCell.classForCoder(), forCellReuseIdentifier: "AlbumCellId")
        
        self.tableView.rowHeight = 70.0
        
        self.clearsSelectionOnViewWillAppear = true
        
        refreshContent()
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
        
        configure(cell: cell, for: albumList[indexPath.row])
        
        return cell
    }
    
    fileprivate func configure(cell: AlbumCell, for model: AlbumModel) {
        
        cell.nameLabel.text = model.name
        cell.artistLabel.text = model.artistName
        cell.accessoryType = .disclosureIndicator
        
        if let image = self.thumbnailCache.object(forKey: model.id as NSString) {
            cell.thumbnailImage = image
            cell.state = .viewing
        } else {
            cell.state = .loading
            DispatchQueue.global(qos: .background).async {
                
                if let image = UIImage(urlString: model.artworkUrl100) {
                    self.thumbnailCache.setObject(image, forKey: model.id as NSString)
                    cell.thumbnailImage = image
                } else {
                    
                }
                cell.state = .viewing
            }
        }
    }
    
    private func refreshContent() {
        DispatchQueue.main.async { [unowned self] in
            self.refreshControl?.beginRefreshing()
        }
        
        networkService.fetchRecords { [unowned self] (fetchResult) in
            
            defer {
                DispatchQueue.main.async { [unowned self] in
                    self.refreshControl?.endRefreshing()
                }
            }
            
            if let list = fetchResult.results {
                self.albumList = list
                self.state = .viewing
                print("Refresh successful")
            } else {
                print("Refresh failed to acquire results.")
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
        
        let model = self.albumList[indexPath.row]
     
        let detailvc = DetailViewController()
        detailvc.albumViewModel = model
        
        self.navigationController?.pushViewController(detailvc, animated: true)
    }
}



