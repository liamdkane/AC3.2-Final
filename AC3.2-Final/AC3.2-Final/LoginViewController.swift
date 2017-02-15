//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {

    var user: FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViewHierarchy()
        configureConstraints()
    }
    
    //MARK: -  View Hierarchy and Constraints
    
    func setUpViewHierarchy () {
        _ = [emailTextField, passwordTextField, logoImageView, loginButton, registerButton].map { self.view.addSubview($0) }
    }
    
    func configureConstraints () {
        self.edgesForExtendedLayout = []
        
        logoImageView.snp.makeConstraints { (view) in
            view.top.equalToSuperview().offset(36)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.6)
            view.height.equalTo(logoImageView.snp.width)
        }
        
        emailTextField.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
            view.width.equalTo(logoImageView.snp.width).multipliedBy(0.8)
        }
        
        passwordTextField.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(emailTextField.snp.bottom).offset(16)
            view.width.equalTo(emailTextField.snp.width)
        }
        
        loginButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        
        registerButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(loginButton.snp.bottom).offset(16)
        }
    }
    
    
    //MARK: - Views
    
    
    var logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "meatly_logo")
        return view
    }()
    
    var emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email...."
        view.backgroundColor = UIColor.cyan.withAlphaComponent(0.3)
        return view
    }()
    
    var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Password...."
        view.backgroundColor = UIColor.cyan.withAlphaComponent(0.3)
        view.isSecureTextEntry = true
        return view
    }()
    
    var loginButton: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.setTitle("LOG IN", for: .normal)
        view.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return view
    }()
    
    var registerButton: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.setTitle("REGISTER", for: .normal)
        view.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return view
    }()
    
    
    //MARK: - Actions
    
    
    func loginButtonPressed () {
        if let username = emailTextField.text,
            let password = passwordTextField.text{
            loginButton.isEnabled = false
            FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("Erro \(error)")
                }
                if user != nil {
                    print("SUCCESS.... \(user!.uid)")
                    self.showAlert(title: "Welcome? Back", message: "Enjoy....")
                } else {
                    self.showAlert(title: "Log In Failed", message: error?.localizedDescription)
                }
                self.loginButton.isEnabled = true
            })
        }

    }
    
    func registerButtonPressed () {
        if let email = emailTextField.text, let password = passwordTextField.text {
            registerButton.isEnabled = false
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("error with completion while creating new Authentication: \(error!)")
                }
                if user != nil {
                    self.showAlert(title: "Welcome?", message: "Enjoy....")
                    self.user = user
                    self.present(FeedViewController(), animated: true, completion: nil)
                } else {
                    self.showAlert(title: "Error", message: error?.localizedDescription)
                }
                self.registerButton.isEnabled = true
            })
        }
    }
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action -> Void in
            if let _ = self.user {
                self.present(FeedViewController(), animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("WOAH THERE BUDDY YOURE ALMOST OUTTA MEMORY")
    }
}
