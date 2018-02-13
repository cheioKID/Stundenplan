 //
//  ClassViewController.swift
//  Stundenplan
//
//  Created by Cheio Wright on 2018/2/8.
//  Copyright © 2018年 Cheio Wright. All rights reserved.
//

import UIKit

class ClassViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var singleClass: Class?
    var time = [Int]()
    var week = [Int]()
    
    let milk = UIColor.init(red: 1, green: 0.99, blue: 0.88, alpha: 1)
    let mocha = UIColor.init(red: 0.57, green: 0.32, blue: 0.06, alpha: 1)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var weekButtons: [UIButton]!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let teacher = teacherTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let time = self.time
        let week = self.week
        if singleClass == nil {
            saveButton.isEnabled = !(name.isEmpty || teacher.isEmpty || location.isEmpty || time.isEmpty || week.isEmpty)
        } else {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
  /*  @IBAction func returnPressed(_ sender: UITextField) {
        nameTextField.resignFirstResponder()
    }
   */
    var isTimePickerHidden = true
    
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let timeCellHeight = CGFloat(260)
        let weekCellHeight = CGFloat(198)
        let noteCellHeight = CGFloat(107)
        
        switch(indexPath) {
        case [3,0]: //note Cell
            return noteCellHeight
            
        case [4,0]: //Notes Cell
            return isTimePickerHidden ? normalCellHeight : timeCellHeight
            
        case [5,0]: //week cell
            return weekCellHeight
            
        default: return normalCellHeight
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [4,0]:
            isTimePickerHidden = !isTimePickerHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
        
    }
    
   /* override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.visibleCells[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let name = nameTextField.text!
        let teacher = teacherTextField.text!
        let location = locationTextField.text!
        var time = self.time
        var week = self.week
        let note = noteTextView.text
        
        if time.isEmpty {
            time = singleClass!.time
        }
        if week.isEmpty {
            week = singleClass!.week
        }
        saveButton.isEnabled = !(name.isEmpty || teacher.isEmpty || location.isEmpty || time.isEmpty || week.isEmpty)
        singleClass = Class(name: name, location: location, teacher: teacher, time: time, week: week, note: note)

    }
  
    //            _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/
    //         _/        _/    _/  _/          _/     _/    _/
    //        _/        _/_/_/_/  _/_/_/      _/     _/    _/
    //       _/        _/    _/  _/          _/     _/    _/
    //        _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/ 
    
    //time picker

    func initPickerView(for pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let rowweek = singleClass == nil ? Class.weekDay : singleClass!.time[0]
        let rowtime = singleClass == nil ? 0 : singleClass!.time[1]
        
        pickerView.selectRow(rowweek,inComponent:0,animated:true)
        pickerView.selectRow(rowtime,inComponent:1,animated:true)

        let message = "☑︎" + weeks[rowweek] + "☑︎" + times[rowtime]
        timeLabel.text = message
        
        updateSaveButtonState()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 7
        } else {
            return 5
        }
    }
    
    let weeks = ["周一","周二","周三","周四","周五","周六","周日"]
    let times = ["上午1-2","上午3-4","下午5-6","下午7-8","晚上9-10"]
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return weeks[row]
        } else {
            return times[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //更新Label值
        let rowweek = pickerView.selectedRow(inComponent: 0)
        let rowtime = pickerView.selectedRow(inComponent: 1)
        let message = "☑︎" + weeks[rowweek] + "☑︎" + times[rowtime]
        
        timeLabel.text = message
        
        if self.time.isEmpty {
            self.time.append(rowweek)
            self.time.append(rowtime)
        } else {
            self.time[0] = rowweek
            self.time[1] = rowtime
        }
        
        
        updateSaveButtonState()
        
        print(self.time)
        
        /*let alertController = UIAlertController(title: "选择了课程的时间",message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
         */
    }

    
    //            _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/
    //         _/        _/    _/  _/          _/     _/    _/
    //        _/        _/_/_/_/  _/_/_/      _/     _/    _/
    //       _/        _/    _/  _/          _/     _/    _/
    //        _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/
    
    //week button select

    var isTheWeekSeleted:[Bool] = [false]
    
    func initWeekButtonNonSelected() {
        var i = 19
        while(i > 0) {
            isTheWeekSeleted.append(false)
            i -= 1
        }
    }
    
    func initWeekButtons() {
        initWeekButtonNonSelected()
        var message = ""
        if let selectedButtons = singleClass?.week {
            for i in selectedButtons {
                isTheWeekSeleted[i] = true
                weekButtons[i].backgroundColor = milk
                message += "☑︎" + String.init(i+1)
            }
            
            weekLabel.text = message
        } else {
            weekLabel.text = "Vergiss nicht, mir die Wochen zu erzählen"
        }
        
        updateSaveButtonState()
    }
    
    
    @IBAction func weekButtonTapped(_ sender: UIButton) {
        guard let ori = Int.init(sender.titleLabel!.text!) else { return }
        let index = ori - 1 // index start from 0
        isTheWeekSeleted[index] = !isTheWeekSeleted[index]
        sender.backgroundColor = isTheWeekSeleted[index] ? milk : UIColor.clear
        
        var selectedButtons = [Int]()
        var message = ""
        var i = 0
        while i < 20 {
            if isTheWeekSeleted[i] {
                selectedButtons.append(i)
            }
            i += 1
        }
        for i in selectedButtons {
            message += "☑︎" + String.init(i+1)
        }
        
        weekLabel.text = message
        self.week = selectedButtons
        
        if weekLabel.text == "" {
            weekLabel.text = "Vergiss nicht, mir die Wochen zu erzählen"
        }
        
        updateSaveButtonState()
    }
    

    
    
    
    //            _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/
    //         _/        _/    _/  _/          _/     _/    _/
    //        _/        _/_/_/_/  _/_/_/      _/     _/    _/
    //       _/        _/    _/  _/          _/     _/    _/
    //        _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/

    //view init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let singleClass = singleClass {
            navigationItem.title = "Class"
            nameTextField.text = singleClass.name
            teacherTextField.text = singleClass.teacher
            locationTextField.text = singleClass.location
            timeLabel.text = String.init(describing: singleClass.time)
            //Picker
            weekLabel.text = String.init(describing: singleClass.week)
            //buttons
            noteTextView.text = singleClass.note
            
        } else {
            //
        }
        
        initPickerView(for: timePickerView)
        initWeekButtons()
        updateSaveButtonState()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
