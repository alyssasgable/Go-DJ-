//
//  DJHomeVC.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/1var//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects
import Alamofire
import SwiftyJSON
import CoreLocation

let cellReuseIdentifier = "TableCellIdentifier"

class SongQueue: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var djName = String()
    var refreshControl = UIRefreshControl()

    var feedArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var canDelete = false
    
    init(dj:String) {
        super.init(nibName: nil, bundle: nil)
        self.djName = dj
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.black
        navigationItem.title = "Song Queue"
        
        let leftswipe = UISwipeGestureRecognizer(target: self, action: #selector(deleteSong))
        leftswipe.direction = .left
        self.view.addGestureRecognizer(leftswipe)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull Down to Refresh", attributes: attributes)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
     
        tableView.estimatedRowHeight = 120.0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.addSubview(refreshControl)
        tableView.refreshControl = refreshControl
        tableView.register(SongCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        getSongNames(dj: djName)
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func setUpView() {
        
        self.view.addSubview(tableView)
        
        let logo = UIImageView()
        logo.image = UIImage(named: "djlogo")
        self.view.addSubview(logo)
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "pluscircle"), for: .normal)
        addButton.addTarget(self, action: #selector(addSong), for: .touchUpInside)
        let imageSize:CGSize = CGSize(width: 150, height: 150)
        addButton.imageEdgeInsets = UIEdgeInsetsMake(addButton.frame.size.height/2 - imageSize.height/2, addButton.frame.size.width/2 - imageSize.width/2, addButton.frame.size.height/2 - imageSize.height/2, addButton.frame.size.width/2 - imageSize.width/2)

        self.view.addSubview(addButton)
        
        logo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.top.equalToSuperview().offset(50)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.height.equalTo(300)
        }
        addButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
//            make.top.equalTo(tableView.snp.bottom).offset(5)
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc func addSong() {
        let alert = UIAlertController(title: "Enter Song",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.white
        alert.addTextField { (textField) in
            // optionally configure the text field
            let textField = JiroTextField()
            textField.keyboardType = .alphabet
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] (action) in
            if let textField = alert.textFields?.first {
                print(textField.text ?? "Nothing entered")
                self.addSongs(dj: self.djName, songName: textField.text!)
                self.getSongNames(dj: self.djName)
                
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    @objc func getSongNames(dj:String) {
        let url = URL(string: "https://5wt88x02a2.execute-api.us-east-2.amazonaws.com/prod/addSong/\(dj)/default")
    
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
    
        switch response.result {
            case .success(let value):
                let json = JSON(value).dictionaryValue
                print("JSON: \(json)")
                
                for song in json["songs"]!.array! {
//                    let dj = location["djName"].stringValue
                    
                    if !self.feedArray.contains(song.stringValue) {
                        self.feedArray.append(song.stringValue)
                    }
                }
            case .failure(let error):
                print(error)
    
                }
            }
    }
    
    @objc func addSongs(dj:String, songName: String) {
        let newSongName = songName.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "https://5wt88x02a2.execute-api.us-east-2.amazonaws.com/prod/addSong/\(dj)/\(newSongName)")
        
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value).dictionaryValue
////                print("JSON: \(json)")
//                }
//            case .failure(let error):
//                print(error)
            
            }
        }

    @objc func deleteSong() {
        if canDelete {
            if self.feedArray.count != 0 {
                let newSongName = feedArray[0].replacingOccurrences(of: " ", with: "+")

                self.feedArray.removeFirst()
                self.tableView.reloadData()
                let url = URL(string: "https://5wt88x02a2.execute-api.us-east-2.amazonaws.com/prod/addSong/\(djName)/$\(newSongName)")
                
                Alamofire.request(url!, method: .get).validate().responseJSON { response in
                    
                    }
                }
        }
    }
    
    @objc func refresh() {
        refreshControl.beginRefreshing()
        getSongNames(dj: djName)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //table view functions
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return feedArray.count
        return feedArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SongCell
        if indexPath.row == 0 {
            cell.cardView.backgroundColor = UIColor(red:0.60, green:1.00, blue:0.60, alpha:1.0)
        }
        cell.songLabel.text = feedArray[indexPath.row]
        
        cell.backgroundColor = .clear
//        cell.songLabel.text = "Song Name"
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
 
}
