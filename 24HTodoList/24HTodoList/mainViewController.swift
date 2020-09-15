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

class MainViewController: UIViewController{
    
    @IBOutlet weak var daySeg: UISegmentedControl!
    @IBOutlet weak var alarmSeg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    
    let datePicker = UIDatePicker()
    @IBAction func doneBtn(_ sender: Any) { // 완료 버튼 누르면 새로운 dataset 생성 및 list에 추가
        
        let tvo = TodoVO() //새로운 tVO 생성, 임시용
        tvo.todoText = textLabel.text
        
        tvo.alarmCount = alarmSeg.selectedSegmentIndex // 세그먼트 값을 alarmCount에 저장
        tvo.deadLineString = inputTime.text
        list.append(tvo)
        tableView.reloadData() //테이블 뷰 갱신
        textLabel.text = "" // 추가했으니 textLabel 비우기
        daySeg.selectedSegmentIndex = 0 //추가했으니 기본 상태로 복귀
        alarmSeg.selectedSegmentIndex = 0 //추가했으니 기본 상태로 복귀
        
        //notification
//        if #available(iOS 10, *){
//            //UserNotification 프레임워크를 사용한 로컬 알림
//            //알림 동의 여부 확인
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                if settings.authorizationStatus == UNAuthorizationStatus.authorized{
//                    // 알림 설정
//                    DispatchQueue.main.async {
//                        //알림 콘텐츠 정의
//                        let nContent = UNMutableNotificationContent()
//                        nContent.body = (self.textLabel.text)!
//                        nContent.title = "미리 알림"
//                        nContent.sound = UNNotificationSound.default
//
//
//                        let time = self.datePicker.date.timeIntervalSinceNow // 발송 시각을 '지금으로부터 *초 형식'으로 변환
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false) // 발송 조건 정의
//                        let request = UNNotificationRequest(identifier: "alarm", content: nContent, trigger: trigger) // 발송 요청 객체 정의
//                        UNUserNotificationCenter.current().add(request) // Notification 센터에 추가
//                    }
//                } else{
//                    let alert = UIAlertController(title: "알림 등록", message: "알림이 허용되어 있지 않습니다", preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "확인", style: .default)
//                    alert.addAction(ok)
//
//                    self.present(alert, animated: true)
//                    return
//                }
//            }
//
//        } else{
//            //LocalNotification 객체를 사용한 로컬 알림
//        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.rowHeight = 40
        return list.count // list의 개수만큼 테이블 뷰 셀 개수 지정
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")! // return을 위한 셀 변수 셍성
        let row = list[indexPath.row] // 행에 맞는 데이터 가져오기
        
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
}
