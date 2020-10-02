//
//  DataManager.swift
//  24HTodoList
//
//  Created by 1v1 on 2020/09/25.
//  Copyright © 2020 정정빈. All rights reserved.
//

import Foundation
import CoreData

class DataManager{
    static let shared = DataManager()
    private init(){
        //Singleton
    }
    
    var mainContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    var doneContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var todayList = [TodoVO]()
    var tommorowList = [TodoVO]()
    var doneList = [TodoVO]()
    
    func fetchToday() {
        let request: NSFetchRequest<TodoVO> = TodoVO.fetchRequest()
        
        //정렬
        let sortByDateDesc = NSSortDescriptor(key: "deadLine", ascending: true)
        request.sortDescriptors = [sortByDateDesc]
        

        do {
            todayList = try mainContext.fetch(request)

        } catch  {
            print(error)
        }
        
    }
    func fetchDone() {
        let request: NSFetchRequest<TodoVO> = TodoVO.fetchRequest()
        
        //정렬
        let sortByDateDesc = NSSortDescriptor(key: "deadLine", ascending: true)
        request.sortDescriptors = [sortByDateDesc]
        
        
        do {
            doneList = try mainContext.fetch(request)

        } catch  {
            print(error)
        }
        
    }
    
    func addNewTodo(_ todos: String?, _ deadLines: Date, _ deadLineStrings: String?){
        let newTodo = TodoVO(context: mainContext)
        newTodo.todoText = todos
        newTodo.deadLine = deadLines
        newTodo.deadLineString = deadLineStrings
        
        todayList.append(newTodo)
        
        saveContext()
    }
    
    func addNewDone(_ todos: String?, _ deadLines: Date, _ deadLineStrings: String?){
        let newTodo = TodoVO(context: mainContext)
        newTodo.todoText = todos
        newTodo.deadLine = deadLines
        newTodo.deadLineString = deadLineStrings
        
        doneList.append(newTodo)
        
        saveContext()
    }
    func invisilbleTodo(_ index: Int){
        todayList.remove(at: index)
        saveContext()
    }
    func deleteTodo(_ todo: TodoVO?){
        if let todo = todo{
            mainContext.delete(todo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "_4HTodoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
