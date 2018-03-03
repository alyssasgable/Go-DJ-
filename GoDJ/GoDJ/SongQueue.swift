//
//  DJHomeVC.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/1var//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit

let cellReuseIdentifier = "TableCellIdentifier"

class SongQueue: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    
    var feedArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var djName = ""
    
//    init(djNameIn: String) {
//        djName = djNameIn
//        super.init(nibName: nil, bundle: nil)
//    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SongCell
        cell.songLabel.text = feedArray[indexPath.row]
        return cell
    }
 
}
