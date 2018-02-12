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
    var classesToday = [Class]()

    var currentWeekDay = -1
    var currentWeek = -1
    
    
    func getRealWeekDay() -> Int {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var dateComponents: DateComponents = DateComponents()
        dateComponents = calendar.dateComponents([.weekday,.weekOfYear], from: Date())
        currentWeek = 9//dateComponents.weekOfYear! // current week settes already
        let weekday = dateComponents.weekday!
        if weekday == 1 {
            return 7
        } else {
            return weekday - 1
        }
    }
    
    
    @IBOutlet weak var weekDaySegmentControl: UISegmentedControl!
    
    func initWeekDaySegmentControl() {
        currentWeekDay = getRealWeekDay() - 1 //init as today in reality
        weekDaySegmentControl.selectedSegmentIndex = currentWeekDay
        updateClassesToday()
        Class.weekDay = currentWeekDay
    }
    
    @IBAction func weekDayChanged(_ sender: UISegmentedControl) {
        currentWeekDay = weekDaySegmentControl.selectedSegmentIndex
        updateClassesToday()
        tableView.reloadData()
        Class.weekDay = currentWeekDay
    }
    
    func updateClassesToday() {
        classesToday.removeAll()
        let rightWeek = currentWeek - Class.firstWeek
        for singleClass in classes {
            if singleClass.week.contains(rightWeek) {
                if singleClass.time[0] == currentWeekDay {
                    classesToday.append(singleClass)
                
                }
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
        return classesToday.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCellIdentifier") as? ClassCell else {
            fatalError("Could not dequeue a cell")
        }
        let singleClass = classesToday[indexPath.row]
        cell.nameLabel.text = singleClass.name
        cell.teacherLabel.text = singleClass.teacher
        cell.locationLabel.text = singleClass.location
        cell.timeLabel.text = timeDescribe(for: singleClass.time)
        cell.noteLabel.text = singleClass.note
        //cell.delegate = self
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let classToDelete = classesToday[indexPath.row]
            guard let index = classes.index(of: classToDelete) else { return }
            classes.remove(at: index)
            updateClassesToday()
            tableView.reloadData()
            Class.saveClasses(classes)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let classToMove = classesToday.remove(at: fromIndexPath.row)
        guard let removePosition = classes.index(of: classToMove) else { return }
        classes.remove(at: removePosition)
        
        let insertPositionClass = classesToday[to.row]
        guard let insertPosition = classes.index(of: insertPositionClass) else {return}
        classes.insert(classToMove, at: insertPosition)
        
        classesToday.insert(classToMove, at: to.row)
        tableView.reloadData()
        Class.saveClasses(classes)
        
        
        
        
    
        /*
        let movedEmoji = emojis.remove(at: fromIndexPath.row)
        emojis.insert(movedEmoji, at: to.row)
        saveToFile(emojis: emojis)
        tableView.reloadData()
        */
    }
    
    
    @IBAction func unwindToClassList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ClassViewController
        
        if let newClass = sourceViewController.singleClass {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let oriClass = classesToday[selectedIndexPath.row]
                guard let index = classes.index(of: oriClass) else { return }
                classes[index] = newClass
            } else {
                classes.append(newClass)
            }
            updateClassesToday()
            tableView.reloadData()
            
        }
        Class.saveClasses(classes)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "showDetails" {
            let classViewController = segue.destination as! ClassViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedClass = classesToday[indexPath.row]
            classViewController.singleClass = selectedClass
        }
    }
    
    func timeDescribe(for time: [Int]) -> String {
        let times = ["上午1-2","上午3-4","下午5-6","下午7-8","晚上9-10"]
        return times[time[1]]
    }

}
