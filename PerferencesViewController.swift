//
//  PerferencesViewController.swift
//  Stundenplan
//
//  Created by Cheio Wright on 2018/2/12.
//  Copyright © 2018年 Cheio Wright. All rights reserved.
//

import UIKit

class PerferencesViewController: UITableViewController {

    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationMessage: UITextField!

    
    //            _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/
    //         _/        _/    _/  _/          _/     _/    _/
    //        _/        _/_/_/_/  _/_/_/      _/     _/    _/
    //       _/        _/    _/  _/          _/     _/    _/
    //        _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/

    //date picker
    
    let keyForStartDate = "startDate"
    let keyForFirstWeek = "firstWeek"
    
    
    func initStartDatePicker() {
        startDatePicker.datePickerMode = .date
        
        dateFormatter.dateStyle = .medium
        if let startDate = defaults.object(forKey: keyForStartDate) as? Date {
            startDatePicker.date = startDate
            startDateLabel.text = dateFormatter.string(from: startDate)
        } else {
            startDateLabel.text = dateFormatter.string(from: Date())
        }
        
        
        
    }
    
    let calendar: Calendar = Calendar(identifier: .gregorian)
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()

    @IBAction func startDatePickerChanged(_ sender: UIDatePicker) {
        let seletedDate = startDatePicker.date
        startDateLabel.text = dateFormatter.string(from: seletedDate)
        let dateComponent = calendar.dateComponents([.weekOfYear], from: seletedDate)
        
        defaults.set(seletedDate, forKey: keyForStartDate)
        defaults.set(dateComponent.weekOfYear, forKey: keyForFirstWeek)
    }
    
    var isStartDatePickerHidden = true
    
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let startDateCellHeight = CGFloat(260)
        let frameCellHeight = CGFloat(167)
        
        switch(indexPath) {
        case [0,0]:
            return frameCellHeight
            
        case [1,0]:
            return isStartDatePickerHidden ? normalCellHeight : startDateCellHeight
            
        default: return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isStartDatePickerHidden = !isStartDatePickerHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
        
    }


    //            _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/
    //         _/        _/    _/  _/          _/     _/    _/
    //        _/        _/_/_/_/  _/_/_/      _/     _/    _/
    //       _/        _/    _/  _/          _/     _/    _/
    //        _/_/_/  _/    _/  _/_/_/_/  _/_/_/     _/_/

    //notification picker
    let keyForNotification = "notification"
    
    func initNotificationSwitch() {
                                //Returns the Boolean value associated with the specified key.
        if let notificationIsOn = defaults.object(forKey: keyForNotification) as? Bool {
            notificationSwitch.isOn = notificationIsOn
            notificationMessage.isEnabled = notificationIsOn
        } else {
            notificationSwitch.isOn = true
            notificationMessage.isEnabled = true
        }
    }
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            notificationLabel.text = "Notification ON"
            notificationMessage.isEnabled = true
            defaults.set(true, forKey: keyForNotification)

        } else {
            notificationLabel.text = "Notification OFF"
            notificationMessage.isEnabled = false
            defaults.set(false, forKey: keyForNotification)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStartDatePicker()
        
        initNotificationSwitch()

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
