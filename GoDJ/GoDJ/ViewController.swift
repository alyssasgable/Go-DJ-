//
//  ViewController.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/18.
//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects
import AWSAuthCore
import AWSAuthUI
import AWSCognitoIdentityProvider
import AWSCore
import AWSCognito

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2, identityPoolId:"us-east-2:c87a91b8-3fcc-425a-95d5-9c719d382e76")
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        self.pool = AWSCognitoIdentityUserPool(forKey: "us-east-2:c87a91b8-3fcc-425a-95d5-9c719d382e76")
        self.user = self.pool?.currentUser()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor.black
        setupView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
   
    
    @objc func setupView() {
        let title = UILabel()
        title.text = "Go DJ"
        title.textColor = UIColor(red:0.65, green:0.62, blue:0.02, alpha:1.0)
//        title.font = title.font.withSize(50)
        title.font = UIFont(name: "NovaSOLID-SOLID", size: 140)
        view.addSubview(title)
        
        let logo = UIImageView()
        logo.image = UIImage(named: "djlogo")
        view.addSubview(logo)
        
        
        let requestBtn = UIButton()
        requestBtn.setTitle("Request A Song", for: .normal)
        requestBtn.tintColor = UIColor(red:0.65, green:0.62, blue:0.02, alpha:1.0)
        requestBtn.backgroundColor = UIColor.darkGray
        requestBtn.addTarget(self, action: #selector(request), for: .touchUpInside)
        view.addSubview(requestBtn)
        
        let DJBtn = UIButton()
        DJBtn.setTitle("DJ Login", for: .normal)
        DJBtn.tintColor = UIColor(red:0.65, green:0.62, blue:0.02, alpha:1.0)
        DJBtn.backgroundColor = UIColor.darkGray
        
        let djLogin = UserDefaults.standard.dictionary(forKey: "djLogin")
        
        if djLogin != nil {
            DJBtn.addTarget(self, action: #selector(request), for: .touchUpInside)
        } else {
            DJBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
        view.addSubview(DJBtn)
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(150)
//            make.width.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
        }
        
        logo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(75)
            make.width.equalTo(250)
            make.height.equalTo(300)
            make.top.equalTo(title.snp.bottom)
        }
        
        requestBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(logo.snp.bottom).offset(15)
        }
        
        DJBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(requestBtn.snp.bottom).offset(15)
        }
        
    }
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?

    @objc func login() {
        self.pool = AWSCognitoIdentityUserPool(forKey: "godj_MOBILEHUB_1893991142")
       
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.backgroundColor = UIColor.black
        config.font = UIFont(name: "Helvetica Neue", size: 12)
        config.isBackgroundColorFullScreen = true
        config.canCancel = true
        config.logoImage = UIImage(named: "djlogo")
        
        AWSAuthUIViewController.presentViewController(with: self.navigationController!,configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
            if error == nil {
                self.navigationController?.pushViewController(DJLoginVC(), animated: true)
            } else {
                print("error")
            }})
    }
    
    @objc func request() {
        self.navigationController?.pushViewController(UserCheckIn(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

