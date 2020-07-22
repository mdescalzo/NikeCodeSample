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
        
        refreshContent()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.albumList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCellId", for: indexPath) as? AlbumCell  else {
            let badCell = UITableViewCell()
            badCell.textLabel?.text = "Unhandled cell class dequeued!!!"
            return badCell
        }

        // Configure the cell...
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
        
        /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshContent() {
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

}
