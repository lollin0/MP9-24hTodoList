//
//  DoneTableViewController.swift
//  24HTodoList
//
//  Created by 1v1 on 2020/09/11.
//  Copyright © 2020 정정빈. All rights reserved.
//

import UIKit
var doneList:[TodoVO] = []
class DoneTableViewController: UITableViewController {
    
    @IBAction func clearBtn(_ sender: Any) {
        doneList.removeAll()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell")! // return을 위한 셀 변수 셍성
        let row = doneList[indexPath.row] // 행에 맞는 데이터 가져오기
        
        // 레이블을 변수로 받음
        let text = cell.viewWithTag(101) as? UILabel
        let time = cell.viewWithTag(102) as? UILabel
        
        //각 레이블에 가져온 데이터 넣기
        text?.text = row.todoText
        time?.text = row.deadLineString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "삭제 혹은 복구하시겠습니까?", message: "지워진 내용은 복구하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
        
        let recover = UIAlertAction(title: "복구", style: .default) { (action) in
            list.append(doneList[indexPath.row])
            doneList.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            list.append(doneList[indexPath.row])
            doneList.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        alert.addAction(recover)
        alert.addAction(okAction)
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
