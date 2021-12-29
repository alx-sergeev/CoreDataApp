//
//  StorageManager.swift
//  CoreDataApp
//
//  Created by Сергеев Александр on 29.12.2021.
//

import UIKit
import CoreData

class StorageManager {
    private init() {}
    
    static var shared = StorageManager()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entityName = "Task"
    
    // Получить список задач
    func fetchDataTasks(to tasks: inout [Task]) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
    }
    
    // Добавить задачу
    func addTask(taskToDo: String, to taskList: inout [Task]) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        guard let taskObject = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        taskObject.taskToDo = taskToDo
        
        do {
            try context.save()
            taskList.append(taskObject)
        } catch let error {
            print(error)
        }
    }
    
    // Удалить задачу
    func deleteTask(_ task: Task) -> Bool {
        context.delete(task)
        
        do {
            try context.save()
        } catch let error {
            print(error)
            
            return false
        }
        
        return true
    }
}
