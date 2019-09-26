//
//  AddVC.swift
//  UserManageClient
//
//  Created by Trung Le on 9/26/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class AddVC: FormViewController {
    var name: String!
    var pass: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New User"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onSave))
        
        
        form +++ TextRow("user") { row in
            row.title = "Username"
            row.placeholder = "Username"
            }.onChange({ (row) in
                self.name = row.value != nil ? row.value! : "" //updating the value on change
            })
            <<< EmailRow("email") { row in
                row.title = "Email"
                row.placeholder = "Email"
                }.onChange({ (row) in
                    self.email = row.value != nil ? row.value! : "" //updating the value on change
                })
            <<< PasswordRow("pass") { row in
                row.title = "Password"
                row.placeholder = "Password"
                }.onChange({ (row) in
                    self.pass = row.value != nil ? row.value! : "" //updating the value on change
                })
        
    }
    @objc func onSave() {
        let queue = DispatchQueue(label: "vn.techmaster.api", qos: .background, attributes: .concurrent)
        
        let base_url = Server.shared.baseURL()
        
        let parameters: Parameters = [
            "name": self.name!,
            "password": self.pass!,
            "email": self.email!
        ]
        Alamofire.request(base_url + "user",
                          method:.post,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody).responseJSON(queue: queue) { response in
                            switch response.result {
                            case .success(let value):
                                let bvalue = value as! Bool
                                if (bvalue==true) {
                                    DispatchQueue.main.async {
                                        
                                        let mainVC = self.navigationController?.topViewController as? MainScreen
                                        mainVC?.tableView.reloadData()
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
}
