//  ViewController.swift
//  iTask
//
//  Created by Milanie Bano on 2024-03-21.

import UIKit

class ViewController: UIViewController {
    
    // Define a struct to represent each task
    struct Task {
        var title: String
        var description: String
        var completed: Bool
    }
    
    // Array to store tasks
    var tasks = [Task]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        // Add new Task alert
        var nameTextField = UITextField()
        var descriptionTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in }
        
        let save = UIAlertAction(title:"Save", style: .default) { (save) in
            if let name = nameTextField.text, !name.isEmpty,
               let description = descriptionTextField.text, !description.isEmpty {
                
                let newTask = Task(title: name, description: description, completed: false)
                self.tasks.append(newTask)
                self.table.reloadData()
            }
        }
        
        alert.addTextField { (textField) in
            nameTextField = textField
            textField.placeholder = "Task Name"
        }
        
        alert.addTextField { (textField) in
            descriptionTextField = textField
            textField.placeholder = "Task Description"
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        // Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
}

// Table View and Cells
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        
        // Set task title with dark text color and description with light text color
        cell.textLabel?.text = task.completed ? "\(task.title) (Completed)" : "\(task.title) - \(task.description)"

        // Set text color and accessory type based on task completion status
        if task.completed {
            cell.textLabel?.textColor = .green // Set text color to green for completed tasks
            cell.accessoryType = .checkmark
        } else {
            cell.textLabel?.textColor = .black // Set text color to black for incomplete tasks
            cell.accessoryType = .none
        }
        
        return cell
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Toggle task completion status
        tasks[indexPath.row].completed.toggle()
        
        // Reload the table view to reflect the changes
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove task from the array
            tasks.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Edit Action
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editTask(at: indexPath)
        }
        editAction.backgroundColor = .blue // Set edit button color to blue
        
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteTask(at: indexPath)
        }
        
        return [deleteAction, editAction]
    }
    
    func editTask(at indexPath: IndexPath) {
        // Retrieve the task to be edited
        let task = tasks[indexPath.row]
        
        // Present an alert to edit the task
        let alert = UIAlertController(title: "Edit Task", message: "", preferredStyle: .alert)
        
        // Add text fields for task name and description
        var nameTextField: UITextField!
        var descriptionTextField: UITextField!
        
        alert.addTextField { textField in
            textField.text = task.title
            nameTextField = textField
            textField.placeholder = "Task Name"
        }
        
        alert.addTextField { textField in
            textField.text = task.description
            descriptionTextField = textField
            textField.placeholder = "Task Description"
        }
        
        // Add save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newName = nameTextField.text, !newName.isEmpty,
                  let newDescription = descriptionTextField.text, !newDescription.isEmpty else {
                // Show an alert if either name or description is empty
                let emptyFieldsAlert = UIAlertController(title: "Error", message: "Task name and description cannot be empty", preferredStyle: .alert)
                emptyFieldsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(emptyFieldsAlert, animated: true, completion: nil)
                return
            }
            
            // Update the task with new data
            self.tasks[indexPath.row].title = newName
            self.tasks[indexPath.row].description = newDescription
            
            // Reload the table view to reflect the changes
            self.table.reloadData()
        }
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        // Remove the task from the array
        tasks.remove(at: indexPath.row)
        
        // Delete the row from the table view
        table.deleteRows(at: [indexPath], with: .automatic)
    }
}

