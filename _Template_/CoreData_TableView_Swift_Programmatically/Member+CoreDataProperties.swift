//
//  Member+CoreDataProperties.swift
//  CoreData_TableView
//
//  Created by Cyrus on 8/6/2022.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var department: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?

}

extension Member : Identifiable {

}
