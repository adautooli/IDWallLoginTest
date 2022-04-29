//
//  ViewController2.swift
//  IdWallLogin
//
//  Created by Adauto Oliveira on 24/04/22.
//

import UIKit


enum Categories: String {
    case husky = "husky"
    case hound = "hound"
    case pug = "pug"
    case labrador = "labrador"
}

class ViewController2: UIViewController {
    
    lazy var tabbar: UITabBar = {
        let tab = UITabBar(frame: .zero)
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.items = tabItens
        return tab
    }()
    
    lazy var tabItem: UITabBarItem = {
        let item = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), selectedImage: UIImage(systemName: "plus"))
        return item
        
    }()
    lazy var tabItem2: UITabBarItem = {
        let item = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), selectedImage: UIImage(systemName: "plus"))
        return item
        
    }()
    
    var tabItens: [UITabBarItem] = []
    var user: String?
    var queryApi: [URLQueryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        addIntens()
        self.view.addSubview(tabbar)
        configConstraints()
        callApi()
        
        
    }
    
    
    private func addIntens() {
        tabItens = [tabItem, tabItem2]
    }
    
    private func configConstraints() {
        
        NSLayoutConstraint.activate([
            self.tabbar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tabbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tabbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tabbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        
        ])
        
    }
    
    private func callApi() {
        
        let user = UserDefaults.standard.value(forKey: "token")
        let categories = ["husky","hound","pug", "labrador"]
        
        for category in categories {
            let queryCat = URLQueryItem(name: "category", value: "\(category)")
            let apiLayer = ApiLayer(URL_BASE: ParamsServices.url)
            let headers = ["Authorization" : "\(user ?? "")"]
            apiLayer.customHeader.append(headers)
            apiLayer.callApi(Method: .GET, endpoint: Endpoints.feed.rawValue, postData: nil, query: [queryCat]) { response, error in
                if error != nil {
                    print(error?.localizedDescription)
                }else {
                    guard let response = response else {return}
                    do{
                        let feed = try JSONDecoder().decode(FeedResponse.self, from: response)
                        print(feed)
                    }catch{
                        print(error.localizedDescription)
                    }

                }
            }
        }
        
    }
    
}
