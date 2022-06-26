//
//  ContentView.swift
//  CoreData_SwiftUI
//
//  Created by Cyrus on 10/6/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc // Retrieve shared context container via @Environment
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student> // Retreive stored data in Core Data
    
    var body: some View {
        VStack {
            List(students) { student in
                Text(student.name ?? "Unknown")
            }
            
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!

                let student = Student(context: moc) // Student() is a NSManagedObject subclass of Core Data Entity "Student"
                // Insert context in context container
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                
                // Save the context container's data to Core Data
                try? moc.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
