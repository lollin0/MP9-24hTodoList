//
//  MainViewController.swift
//  24HTodoList
//
//  Created by 1v1 on 2020/09/07.
//  Copyright © 2020 정정빈. All rights reserved.
//

import UIKit
var datalist = [TodoVO]()
class MainViewController: UIViewController{
    var dataset = [
        ("장 보기", 19, 30, 2), // 장보기, 19:30까지, 2시간 전부터 알람
        ("알고리즘 강의 듣기", 12, 00, 3),
        ("교재 주문", 15, 30, 0)
    ]
    @IBOutlet weak var daySeg: UISegmentedControl!
    @IBOutlet weak var alarmSeg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UITextField!
    lazy var list: [TodoVO] = { // 데이터 넣을 리스트 생성
        
        for (todoText, deadLineH, deadLineM, alarmCount) in self.dataset{ // 각 요소들을 하나하나 매칭하여 데이터 묶음 생성
            let tvo = TodoVO()
            tvo.todoText = todoText
            tvo.deadLineH = deadLineH
            tvo.deadLineM = deadLineM
            tvo.alarmCount = alarmCount
            
            var H: String = String(deadLineH)
            var M: String = String(deadLineM)
            tvo.deadLineString = H + " : " + M
            datalist.append(tvo) // datalist에 추가
        }
        return datalist
    }()
    
    @IBAction func doneBtn(_ sender: Any) { // 완료 버튼 누르면 새로운 dataset 생성 및 list에 추가
        
        let tvo = TodoVO() //새로운 tVO 생성, 임시용
        tvo.todoText = textLabel.text
        tvo.deadLineH = 0 // 시간은 나중에 추가
        tvo.deadLineM = 0
        tvo.alarmCount = alarmSeg.selectedSegmentIndex // 세그먼트 값을 alarmCount에 저장
        var H: String = String(tvo.deadLineH!)
        var M: String = String(tvo.deadLineM!)
        tvo.deadLineString = H + " : " + M
        list.append(tvo)
        tableView.reloadData() //테이블 뷰 갱신
        textLabel.text = "" // 추가했으니 textLabel 비우기
        daySeg.selectedSegmentIndex = 0 //추가했으니 기본 상태로 복귀
        alarmSeg.selectedSegmentIndex = 0 //추가했으니 기본 상태로 복귀
        
    }
    
    @IBAction func checkBtn(_ sender: Any) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected == true{
//            isAutoLogin = true
//        }else{
//            isAutoLogin = false
//        }
    }

    

    override func viewDidLoad() {
//        super.viewDidLoad()
    }
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.rowHeight = 40
        print(self.list.count)
        return self.list.count // list의 개수만큼 테이블 뷰 셀 개수 지정
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = self.list[indexPath.row] // 행에 맞는 데이터 가져오기
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")! // return을 위한 셀 변수 셍성
        
        // 레이블을 변수로 받음
        let text = cell.viewWithTag(101) as? UILabel
        let time = cell.viewWithTag(102) as? UILabel
        
        //각 레이블에 가져온 데이터 넣기
        text?.text = row.todoText
        time?.text = row.deadLineString
        
        return cell
        
    }
    
}
