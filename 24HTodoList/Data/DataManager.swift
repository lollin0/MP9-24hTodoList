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
    var allList = [TodoVO]()
    var todoList = [TodoVO]()
    var todayList = [TodoVO]()
    var tommorowList = [TodoVO]()
    var doneList = [TodoVO]()
    
    func fetchTodo() {
        let request: NSFetchRequest<TodoVO> = TodoVO.fetchRequest()
        
        //정렬
        let sortByDateDesc = NSSortDescriptor(key: "deadLine", ascending: true)
        request.sortDescriptors = [sortByDateDesc]
        

        do {
            allList = try mainContext.fetch(request)

        } catch  {
            print(error)
        }
        setAllList()
    }
    
    func setAllList() {
        todoList.removeAll() // 리스트 재구성 할 때 초기화를 다 해 줘야 데이터가 2개씩 안 생긴다...***
        todayList.removeAll()
        tommorowList.removeAll()
        doneList.removeAll()
        let calendar = Calendar.current // 캘린더 선언(오늘)
        let today = Date()  // 오늘 날짜 변수 선언 (오늘+9시간 = 한국시간)
        let midnight = calendar.startOfDay(for: today) + (3600*9) + 86400 // 오늘 날짜의 시작 (00시) + 9시간
        print("####################E@###########@##",today)
        print("####################E@###########@##",midnight)
        for one in allList{
            if one.isDone == true{
                doneList.append(one)
            }
            else{
                todoList.append(one)
            }
        }
        
        for one in todoList{
            if one.deadLine! < midnight - 86400 {
                doneList.append(one)
            }
            else if one.deadLine! < midnight { // 마감 시간이 내일 00시 이전일 때(오늘 끝마칠 일일 때)
                todayList.append(one)
                print(todayList)
            }
            else{
                tommorowList.append(one)
                print(tommorowList)
            }
        }
        //saveContext()
    }
    
    
    func addNewTodo(_ todos: String?, _ deadLines: Date, _ deadLineStrings: String?){
        let newTodo = TodoVO(context: mainContext)
        newTodo.todoText = todos
        newTodo.deadLine = deadLines
        newTodo.deadLineString = deadLineStrings
        newTodo.isDone = false
        allList.append(newTodo)
        
        saveContext()
    }
    

    func deleteTodo(_ todo: TodoVO?){
        if let todo = todo{
            mainContext.delete(todo)
            fetchTodo()
            saveContext()
        }
    }
    func clearDoneList(){
        for one in doneList{
            deleteTodo(one)
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
