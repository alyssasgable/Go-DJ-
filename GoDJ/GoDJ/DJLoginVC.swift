//
//  DJLoginVC.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/18.
//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSAuthCore
import AWSAuthUI
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class DJLoginVC: UIViewController {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
//        self.navigationController?.navigationBar.backgroundColor = UIColor.black
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
//        locationManager.delegate = self as! CLLocationManagerDelegate
        setupView()
        
}
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var address = JiroTextField()
    
    @objc func setupView() {
        let logo = UIImageView()
        logo.image = UIImage(named: "djlogo")
        view.addSubview(logo)
        
//        let address = JiroTextField()
        address.borderColor = UIColor.white
        address.placeholder = "Enter Address"
        address.placeholderFontScale = 2
        address.placeholderColor = UIColor.white
        addDoneButtonOnKeyboard(textfield: address)
        view.addSubview(address)
        
        
        let checkInBtn = UIButton()
        checkInBtn.setTitle("Check In", for: .normal)
        checkInBtn.backgroundColor = UIColor.darkGray
        checkInBtn.addTarget(self, action: #selector(checkedIn), for: .touchUpInside)
        view.addSubview(checkInBtn)
        
        logo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.top.equalToSuperview().offset(50)
        }

        checkInBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(logo.snp.bottom).offset(75)
            make.height.equalTo(50)
        }
    }
    
    @objc func checkedIn() {
        //enter address into db
        let lat = (locationManager.location?.coordinate.latitude)!
        let long = (locationManager.location?.coordinate.longitude)!
        
        let url = URL(string: "https://5wt88x02a2.execute-api.us-east-2.amazonaws.com/prod/addSong/Zach/\(lat),\(long)")
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionaryValue
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
        
        let sq = SongQueue(dj: "Zach")
        sq.canDelete = true
        self.navigationController?.pushViewController(sq, animated: true)
        
    }
  
    func addDoneButtonOnKeyboard(textfield: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textfield.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
}
