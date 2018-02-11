//
//  Class.swift
//  Stundenplan
//
//  Created by Cheio Wright on 2017/11/7.
//  Copyright © 2017年 Cheio Wright. All rights reserved.
//

import Foundation
class Class: NSObject, NSCoding{
    var name: String
    var location: String
    var teacher: String
    var time: [Int]
    var week: [Int]
    var note: String?
    
    
    init(name: String, location: String, teacher: String, time: [Int], week: [Int], note: String?) {
        guard !(name.isEmpty || location.isEmpty || teacher.isEmpty || time.isEmpty || week.isEmpty) else {
            fatalError("All except note are essential.")
        }
        
        self.name = name
        self.location = location
        self.teacher = teacher
        self.time = time
        self.week = week
        self.note = note
    }
    
    static func loadClasses() -> [Class]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Class.ArchiveURL.path) as? [Class]
    }
    
    static func loadSampleClasses() -> [Class] {
        let Class1 = Class(name: "C/C++", location: "yuzhou318", teacher: "Lehrer Eins", time: [1,1], week: [1,2,3,4,5,6,7,8], note: "4 credit")
        let Class2 = Class(name: "JAVA", location: "yuzhou318", teacher: "Lehrer Zwei", time: [1,2], week: [1,2,3,4,5,6,7,8], note: "4 credit")
        let Class3 = Class(name: "Swift", location: "yuzhou318", teacher: "Lehrer Drei", time: [2,3], week: [1,2,3,4,5,6,7,8], note: "0 credit")
        
        return [Class1,Class2,Class3]
    }
    
    
    struct PropertyKey {
        static let name = "name"
        static let location = "location"
        static let teacher = "teacher"
        static let time = "time"
        static let week = "week"
        static let note = "note"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String,
            let teacher = aDecoder.decodeObject(forKey: PropertyKey.teacher) as? String,
            let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? [Int],
            let week = aDecoder.decodeObject(forKey: PropertyKey.week) as? [Int],
            let note = aDecoder.decodeObject(forKey: PropertyKey.note) as? String
        else {return nil}
        
        self.init(name: name, location: location, teacher: teacher, time: time, week: week, note: note)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(teacher, forKey: PropertyKey.teacher)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(week, forKey: PropertyKey.week)
        aCoder.encode(note, forKey: PropertyKey.note)
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("classes")
    
    static func saveClasses(_ classes: [Class]) {
        NSKeyedArchiver.archiveRootObject(classes, toFile: Class.ArchiveURL.path)
    }

}
