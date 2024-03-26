//  ViewController.swift
//  iTask
//
//  Created by Milanie Bano on 2024-03-21.

import UIKit

/*
    To Do:
 
    - Implement an editing page where the user can edit the date/time, input status, and add notes for the task
    - Add a delete/trash button to delete the task
    - Possibly create a page that displays whether the task is complete, incomplete, or in progress
 */

class ViewController: UIViewController {

    // Items in the To-Do list
    var items = [String]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        //Add new Item alert
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
        }
        
        let save = UIAlertAction(title:"Save", style: .default) { (save) in
            
            self.items.append(textField.text!)
            self.table.reloadData()
        }
        
        alert.addTextField { (text) in
            textField = text
            textField.placeholder = "Add new task"
        }
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// Table View and Cells
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Perform the deletion from your data source here
            
            // Example: Assuming you have an array named items as your data source
            items.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
