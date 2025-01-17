//
//  EditScreen.swift
//  UserManageClient
//
//  Created by Techmaster on 9/24/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Alamofire
import SwiftyJSON

class EditScreen: FormViewController  {
    
    var id: String!
    var name: String!
    var pass: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit User"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onSave))
        form +++ TextRow("user") { row in
                row.title = "Username"
                row.value = self.name
                }.onChange({ (row) in
                    self.name = row.value != nil ? row.value! : ""
                })
            <<< EmailRow("email") { row in
                row.title = "Email"
                row.value = self.email
                }.onChange({ (row) in
                    self.email = row.value != nil ? row.value! : ""
                })
            <<< PasswordRow("pass") { row in
                row.title = "Password"
                row.value = self.pass
                }.onChange({ (row) in
                    self.pass = row.value != nil ? row.value! : "" 
                })
    }
    
    
    @objc func onSave() {
        let queue = DispatchQueue(label: "vn.techmaster.api", qos: .background, attributes: .concurrent)
        
        let base_url = Server.shared.baseURL()
        
        let parameters: Parameters = [
            "id": Int(self.id)!,
            "name": self.name!,
            "password": self.pass!,
            "email": self.email!
        ]
        Alamofire.request(base_url + "user",
                          method:.put,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody).responseJSON(queue: queue) { response in
                            switch response.result {
                            case .success(let value):
                                let bvalue = value as! Bool
                                if (bvalue==true) {
//                                    self.json!.arrayObject?.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
//                                        self.tableView.deleteRows(at: [indexPath], with: .fade)
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




