//
//  ViewController.swift
//  IdWallLogin
//
//  Created by Adauto Oliveira on 24/04/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    lazy var textFieldEmail: UITextField = {
        let tfEmail = UITextField(frame: .zero)
        tfEmail.translatesAutoresizingMaskIntoConstraints = false
        tfEmail.keyboardType = .emailAddress
        tfEmail.placeholder = "Digite aqui seu email"
        tfEmail.borderStyle = .roundedRect
        tfEmail.font = UIFont.systemFont(ofSize: 14)
        tfEmail.delegate = self
        
        return tfEmail
    }()
    
    lazy var buttonLogin: UIButton = {
        let btnLogin = UIButton(frame: .zero)
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.setTitle("Entrar", for: .normal)
        btnLogin.addTarget(self, action: #selector(signup), for: .touchUpInside)
        btnLogin.backgroundColor = .blue
        btnLogin.layer.cornerRadius = 3.0
        return btnLogin
    }()
    
    private var validEmail: String?
    private var model: Codable?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = .lightGray
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(self.textFieldEmail)
        self.view.addSubview(self.buttonLogin)
        self.configConstraints()
    }
    
    private func configConstraints() {
        
        NSLayoutConstraint.activate([
            self.textFieldEmail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldEmail.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.textFieldEmail.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.textFieldEmail.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            
            self.buttonLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonLogin.centerYAnchor.constraint(equalTo: self.textFieldEmail.bottomAnchor, constant: 32),
            self.buttonLogin.widthAnchor.constraint(equalToConstant: 100),
            self.buttonLogin.heightAnchor.constraint(equalToConstant: 40)
                        
            
        ])
        
    }
    
    @objc func signup() {
        self.validEmail = textFieldEmail.text
        let validEmail = self.validEmail?.isValidEmail
        switch validEmail {
        case true:
            guard let email = self.validEmail else {return}
            callApi(email: email) { response, error in
                if error != nil {
                    self.showAlert()
                }else {
                    let defaults = UserDefaults()
                    defaults.set(response, forKey: "token")
                    DispatchQueue.main.sync {
                        
                        let vc = ViewController2()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
        default:
            showAlert()
            break
        }
        
    }
    private func showAlert() {
        let alert = UIAlertController(title: "Opps!", message: "O email digitado não é validado", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendi", style: .default))
        self.present(alert, animated: true)
    }
 
   private func callApi(email: String, completion: @escaping (String?, Error?)-> Void) {
        
        let apiLayer = ApiLayer(URL_BASE: ParamsServices.url)
        
        let params = ["email": "\(email)"]
        let postData = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        apiLayer.callApi(Method: .POST, endpoint: Endpoints.login.rawValue, postData: postData, query: nil) { response, error in
            if error != nil {
                
            }else {
                guard let response = response else {return}
                do{
                    let user = try JSONDecoder().decode(SignupResponse.self, from: response)
                    completion(user.user?.token, nil)
                }catch{
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
        
}

public extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}





