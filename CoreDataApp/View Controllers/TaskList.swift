//
//  TaskList.swift
//  CoreDataApp
//
//  Created by Сергеев Александр on 29.12.2021.
//

import UIKit

class TaskList: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let cellName = "taskCell"
    private var taskList: [Task] = []
    private weak var storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        storageManager?.fetchDataTasks(to: &taskList)
        
        // Стилизация панели навигации через код
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = UIColor(red: 21/255, green: 100/255, blue: 190/255, alpha: 190/255)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
    }
    
    // Alert сообщение для добавления задачи
    @IBAction func addTaskButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Новая задача", message: "Введите название задачи", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            
            self.storageManager?.addTask(taskToDo: taskName, to: &self.taskList)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alert.addTextField { UITextField in
            UITextField.autocapitalizationType = .sentences
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension TaskList: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        var configurator = cell.defaultContentConfiguration()
        
        let task = taskList[indexPath.row]
        configurator.text = task.taskToDo

        cell.contentConfiguration = configurator

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let taskToDelete = taskList[indexPath.row]
        
        if let isDelete = storageManager?.deleteTask(taskToDelete), isDelete == true {
            taskList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

// MARK: - Table view delegate
extension TaskList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
