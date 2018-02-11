//
//  MondayTableViewController.swift
//  Stundenplan
//
//  Created by Cheio Wright on 2017/10/31.
//  Copyright © 2017年 Cheio Wright. All rights reserved.
//
import UIKit

class ClassTableViewController: UITableViewController {
    var classes = [Class]()
    var currentWeekDay = -1
    var currentWeek = -1
    
    @IBOutlet weak var weekDaySegmentControl: UISegmentedControl!
    
    func initWeekDaySegmentControl() {
        currentWeekDay = 2 //init as today in reality
        weekDaySegmentControl.selectedSegmentIndex = currentWeekDay
    }
    
    @IBAction func weekDayChanged(_ sender: UISegmentedControl) {
        currentWeekDay = weekDaySegmentControl.selectedSegmentIndex
        updateClassesVisiable()
    }
    
    func updateClassesVisiable() {
        //not today then invisiable
        for singleClass in classes {
            if singleClass.time[0] != currentWeekDay {
                let indexPath = IndexPath(row: classes.index(of: singleClass)!, section: 0)
                tableView.cellForRow(at: indexPath)?.isHidden = true
                
                print(singleClass.name + "在周")
                print(singleClass.time[0] + 1)
                print(indexPath)
                //print(tableView.cellForRow(at: indexPath)!.isHidden)
                print(tableView.visibleCells)
                print("////////////////")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedClasses = Class.loadClasses() {
            classes = savedClasses
        } else {
            classes = Class.loadSampleClasses()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        initWeekDaySegmentControl()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCellIdentifier") as? ClassCell else {
            fatalError("Could not dequeue a cell")
        }
        let singleClass = classes[indexPath.row]
        cell.nameLabel.text = singleClass.name
        cell.teacherLabel.text = singleClass.teacher
        cell.locationLabel.text = singleClass.location
        cell.weekLabel.text = weekDescribe(for: singleClass.week)
        cell.noteLabel.text = singleClass.note
        //cell.delegate = self
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            classes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Class.saveClasses(classes)
        }
    }
    
    @IBAction func unwindToClassList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ClassViewController
        
        if let singleClass = sourceViewController.singleClass {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                classes[selectedIndexPath.row] = singleClass
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: classes.count, section: 0)
                
                classes.append(singleClass)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
        Class.saveClasses(classes)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "showDetails" {
            let classViewController = segue.destination as! ClassViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedClass = classes[indexPath.row]
            classViewController.singleClass = selectedClass
        }
    }
    
    func weekDescribe(for week: [Int]) -> String {
        return String.init(week.count) + "weeks"
    }
}
