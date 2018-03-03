//
//  ViewController.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/18.
//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = UIColor.black
        setupView()
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        
//    }
    
    @objc func setupView() {
        let title = UILabel()
        title.text = "Go DJ!"
        title.textColor = UIColor.white
        title.font = title.font.withSize(50)
        view.addSubview(title)
        
        let logo = UIImageView()
        logo.image = UIImage(named: "djlogo")
        view.addSubview(logo)
        
        
        let requestBtn = UIButton()
        requestBtn.setTitle("Request A Song", for: .normal)
        requestBtn.backgroundColor = UIColor.darkGray
        requestBtn.addTarget(self, action: #selector(request), for: .touchUpInside)
        view.addSubview(requestBtn)
        
        let DJBtn = UIButton()
        DJBtn.setTitle("DJ Login", for: .normal)
        DJBtn.backgroundColor = UIColor.darkGray
        
        let djLogin = UserDefaults.standard.dictionary(forKey: "djLogin")
        
        if djLogin != nil {
            DJBtn.addTarget(self, action: #selector(request), for: .touchUpInside)
        } else {
            DJBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
        view.addSubview(DJBtn)
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.left.equalToSuperview().offset(115)
            make.top.equalToSuperview().offset(30)
        }
        
        logo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.width.equalTo(200)
            make.height.equalTo(250)
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
    

    @objc func login() {
        self.navigationController?.pushViewController(DJLoginVC(), animated: true)
    }
    
    @objc func request() {
        self.navigationController?.pushViewController(SongQueue(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

