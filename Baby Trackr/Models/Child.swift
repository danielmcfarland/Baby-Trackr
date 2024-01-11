//
//  Child.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import Foundation
import SwiftData

@Model
final class Child {
    var name: String = ""
    var dob: Date = Date()
    var gender: String = ""
    
    @Relationship(deleteRule: .cascade, inverse: \Change.child)
    var changes: [Change]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \Feed.child)
    var feeds: [Feed]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \Measurement.child)
    var measurements: [Measurement]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \Sleep.child)
    var sleeps: [Sleep]? = []
    
    init(name: String, dob: Date, gender: String) {
        self.name = name
        self.dob = dob
        self.gender = gender
    }
    
    var initials: String {
        get {
            let words = self.name.split(separator: " ")
            
            var initials = words.first?.prefix(1) ?? ""
            
            if words.count > 1 {
                initials += words.last?.prefix(1) ?? ""
            }
            
            return String(initials)
        }
    }
}
