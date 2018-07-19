//
//  ViewController.swift
//  FBCategorySearch
//
//  Created by Shanth L on 23/05/18.
//  Copyright © 2018 Shanth L. All rights reserved.
//

import UIKit
import FacebookCore




class ViewController: UIViewController {
    var aryPlaceList = NSArray()
    @IBOutlet weak var txtfld_seach: UITextField!
    
    @IBOutlet weak var tblvw_search: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblvw_search.tableFooterView = UIView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func SearchApiCallAction() -> Void{
            if self.txtfld_seach.text!.count > 1{
                let str_search = "\(self.txtfld_seach.text!)"
                DispatchQueue.main.async {
                    let connection = GraphRequestConnection()
                    //&distance=1000 // if u need distance means add this key on the graph path 
                connection.add(GraphRequest(graphPath: "/search?q=\(str_search)&type=place&center=11.008909,76.981553&fields=name,location,description,photos,picture.type(large),Address,user_events")) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        if ((response.dictionaryValue! as NSDictionary).object(forKey: "data") as! NSArray).count != 0 {
                            self.aryPlaceList = (response.dictionaryValue! as NSDictionary).object(forKey: "data") as! NSArray
                            self.tblvw_search.reloadData()
                        }else{
                            print("Nodata found")
                            self.aryPlaceList = NSArray()
                            self.tblvw_search.reloadData()
                        }
                        print("Graph Request Succeeded: \(response)")
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                }
            }else{
                self.aryPlaceList = NSArray()
                self.tblvw_search.reloadData()
            }
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     //   DispatchQueue.main.async {
            self.perform(#selector(self.SearchApiCallAction), with: nil, afterDelay: 0.0)
        //}
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        DispatchQueue.main.async {
            self.perform(#selector(self.SearchApiCallAction), with: nil, afterDelay: 0.1)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryPlaceList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_Search") as! CELL_Search
        cell.lbl_title.text = "\((aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name")!)"
        
        let str_street = (aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.street") == nil ? "" : "\((aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.street")!) "
        let str_city = (aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.city") == nil ? "" : "\((aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.city")!) "
        let str_zip = (aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.zip") == nil ? "" : "\((aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.zip")!) "
        let str_country = (aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.country") == nil ? "" : "\((aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.country")!)"
        cell.lbl_subtitle.text = "\(str_street)\(str_city)\(str_zip)\(str_country)"
        do {
            let imageData = try Data(contentsOf: URL(string: "\(((aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKey: "picture") as! NSDictionary).value(forKeyPath: "data.url")!)")!)
            cell.imgvw_place.image = UIImage(data: imageData)
        } catch {
            print("Unable to load data: \(error)")
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        //(aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKey: "picture") as! NSDictionary).value(forKeyPath: "data.url")!
        //(aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.city")!
        //(aryPlaceList.object(at: indexPath.row) as! NSDictionary).value(forKeyPath: "location.zip")!
        return cell
    }
    
    
    
    
    
}
