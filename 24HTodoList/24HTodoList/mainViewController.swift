//
//  MainViewController.swift
//  24HTodoList
//
//  Created by 1v1 on 2020/09/07.
//  Copyright © 2020 정정빈. All rights reserved.
//

import UIKit
import UserNotifications
var list: [TodoVO] = []
var sections = ["오늘", "내일"]
class MainViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var daySeg: UISegmentedControl!
    @IBOutlet weak var alarmSeg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    
    @IBAction func didEndOnExit(sender: AnyObject) {
    }
    let datePicker = UIDatePicker()
    @IBAction func checkBtn(_ sender: Any) { // 완료 버튼 누르면 새로운 dataset 생성 및 list에 추가
        if  inputTime.text != "tap here" && textLabel.text != "tap here"{ // textField 비어 있으면 추가 안 됨
            print(inputTime.text)
            let tvo = TodoVO() //새로운 tVO 생성, 임시용
            tvo.todoText = textLabel.text!
            
            tvo.alarmCount = alarmSeg.selectedSegmentIndex // 세그먼트 값을 alarmCount에 저장
            tvo.deadLineString = inputTime.text!
            if daySeg.selectedSegmentIndex == 0{ // 날짜 선택에서 '오늘'을 선택했을 때
                tvo.deadLine = datePicker.date + (3600*9) // 우리나라는 표준시가 +9이므로 3600초*9 = 32400초를 더해 준다!
            }else{ //내일을 선택했을 때
                tvo.deadLine = datePicker.date + 86400 + (3600*9) // 32400초 더해 준 것에다가 다음날(86400)초를 더해 주기
            }
            list.append(tvo)
            list.sort(by: { $0.deadLine < $1.deadLine }) //배열 정렬
            tableView.reloadData() //테이블 뷰 갱신
            textLabel.text = "tap here" // 추가했으니 textLabel 비우기
            inputTime.text = "tap here"
            daySeg.selectedSegmentIndex = 0 //추가했으니 기본 상태로 복귀
            alarmSeg.selectedSegmentIndex = 0 //추가했으니 기본 상태로 복귀
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    func timeSet(setD: Int, setH: Int, setM: Int){
        
    }
    func createDatePicker(){
        
        inputTime.textAlignment = .center
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        // assign tollbar
        inputTime.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        inputTime.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 30
    }
    
    @objc func donePressed(){
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
       
            inputTime.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        
    }
    
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count // 섹션 개수 2개
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return newTodayArray(array: list).count //'오늘'리스트의 개수를 셀 개수로 반환
        }else{
            return newTomorrowArray(array: list).count //'내일'리스트의 개수를 셀 개수로 반환
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")! // return을 위한 셀 변수 셍성
        let row: TodoVO
        if indexPath.section == 0{
            row = newTodayArray(array: list)[indexPath.row] // '오늘' 배열 데이터 가져오기
        } else{
            row = newTomorrowArray(array: list)[indexPath.row]
        }
        
        
        // 레이블을 변수로 받음
        let text = cell.viewWithTag(101) as? UILabel
        let time = cell.viewWithTag(102) as? UILabel
        
        //각 레이블에 가져온 데이터 넣기
        text?.text = row.todoText
        time?.text = row.deadLineString
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doneList.append(list[indexPath.row])
        list.remove(at: indexPath.row)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func newTodayArray(array: [TodoVO]) -> [TodoVO]{ // 오늘까지인 투두리스트를 새로운 배열로 만들어 반환하는 함수
        var newArray:[TodoVO] = [] // 반환할 새로운 배열
        var calendar = Calendar.current // 캘린더 선언(오늘)
        let today = Date() + (3600*9) // 오늘 날짜 변수 선언 (오늘+9시간 = 한국시간)
        let midnight = calendar.startOfDay(for: today) + (3600*9) // 오늘 날짜의 시작 (00시) + 9시간
        
        for one in array{
            if one.deadLine < midnight { // 마감 시간이 내일 00시 이전일 때(오늘 끝마칠 일일 때)
                newArray.append(one)
            }
        }
        return newArray
    }
    
    func newTomorrowArray(array: [TodoVO]) -> [TodoVO]{ // 내일까지인 투두리스트를 새로운 배열로 만들어 반환하는 함수
        var newArray:[TodoVO] = []
        var calendar = Calendar.current
        let today = Date() + (3600*9)
        let midnight = calendar.startOfDay(for: today) + (3600*9)
        for one in array{ // 마감 시간이 내일 00시 이후일 때 (내일 끝마칠 일일 때)
            if one.deadLine >= midnight{
                newArray.append(one)
            }
        }
        return newArray
    }
}
