//
//  DJLoginVC.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/18.
//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit
import TextFieldEffects

class DJLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func setupView() {
        let logo = UIImageView()
        logo.image = UIImage(named: "djlogo")
        view.addSubview(logo)
        
        let username = JiroTextField()
        username.borderColor = UIColor.white
        username.placeholder = "Username"
        username.placeholderColor = UIColor.white
        addDoneButtonOnKeyboard(textfield: username)
        view.addSubview(username)
        
        let password = JiroTextField()
        password.borderColor = UIColor.white
        password.placeholder = "Password"
        password.placeholderColor = UIColor.white
        addDoneButtonOnKeyboard(textfield: password)
        view.addSubview(password)
        
        let loginBtn = UIButton()
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.backgroundColor = UIColor.darkGray
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        view.addSubview(loginBtn)
        
        logo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.top.equalToSuperview()
        }
    
        username.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(logo.snp.bottom).offset(15)
        }
        
        password.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(username.snp.bottom).offset(15)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(password.snp.bottom).offset(75)
            make.height.equalTo(50)
        }
    }
    
    @objc func login() {
        
        //authentification stuff
        
        self.navigationController?.pushViewController(SongQueue(), animated: true)
        
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
