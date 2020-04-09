//
//  ViewController.swift
//  RealmSwift5
//
//  Created by 酒井専冴 on 2020/04/03.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var toDoList: Results<ToDo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.separatorStyle = .none
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("画面の幅: \(self.view.frame.width)")
        print("tableViewの幅: \(tableView.frame.width)")

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.isEditing = false
        getToDoData()
        
    }
    @IBAction func doneAction(_ sender: Any) {
        
        if searchTextField.text == "" {
            
            return
        }
        do{
            let  realm = try! Realm()
            
            guard realm.objects(ToDo.self).filter("ToDo == %@",searchTextField.text!).first != nil else {
                
                doneLabel.text = "一致するデータがありません。"
                return
            }
            
            let results = realm.objects(ToDo.self).filter("ToDo == %@",searchTextField.text!).first!
            
            doneLabel.text = results.ToDo
            createLabel.text = results.createdAt
           
            
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
    @IBAction func editButtonTaped(_ sender: Any) {
        
        if tableView.isEditing == false {
            
            tableView.isEditing = true
            
        }else if tableView.isEditing == true {
            
            tableView.isEditing = false
            
        }
        
        
    }
    @IBAction func addButtonTaped(_ sender: Any) {
        
        showAlert()
        
    }
    func showAlert(){
        
        let alertVC = UIAlertController(title: "ToDoList", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            
            textField.placeholder = "ToDoList"
            
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            if let textField = alertVC.textFields?.first {
                
                guard let text = textField.text else{
                    return
                }
                
                let ToDoText = ToDo()
                
                ToDoText.createdAt = self.getNowDate()
                ToDoText.ToDo = text
                
                do{
                    let realm = try! Realm()
                    
                    try! realm.write{
                        
                        realm.add(ToDoText)
                        self.tableView.reloadData()
                    }
                    
                }catch let error{
                    
                    print(error.localizedDescription)
                }
                
            }
            
            //MARK: Test
            do{
                let realm = try! Realm()
                let todo: Results<ToDo> = realm.objects(ToDo.self)
                
                print(type(of: todo))
            }catch let error {
                print(error.localizedDescription)
            }
            
        }
        let cancal = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(action)
        alertVC.addAction(cancal)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    fileprivate func getNowDate() -> String{
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        
        let currentDate = formatter.string(from: date)
        
        return currentDate
        
    }
    fileprivate func getToDoData(){
        
        do{
            let realm = try! Realm()
            
            toDoList = realm.objects(ToDo.self).sorted(byKeyPath: "createdAt", ascending: true)
            
        }catch let error{
            
            print(error.localizedDescription)
        }
        
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = toDoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.createdLabel.text = item.createdAt
        cell.todoLabel.text = item.ToDo
        cell.todoLabel.numberOfLines = 0
        cell.todoLabel.adjustsFontSizeToFitWidth = true
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.height/6
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        //3番目は削除させない。
//        if indexPath.row == 3{
//            return false
//        }
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            
            do{
                let realm =  try! Realm()
                try! realm.write{
                    
                    realm.delete(toDoList[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
                
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

