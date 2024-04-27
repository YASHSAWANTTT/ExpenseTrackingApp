//  ActivityViewModel.swift
//  ExpenseTrackingApp
//  Created by Yash Sawant on 4/3/24.

import Foundation
import CoreData
import UserNotifications

class ActivityViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    @Published var activities: [Activity] = []
    var threshold: Double {
        didSet {
            UserDefaults.standard.set(threshold, forKey: "threshold")
            checkThreshold()
        }
    }

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        self.threshold = UserDefaults.standard.double(forKey: "threshold")
        fetchActivities()
    }

    func fetchActivities(from startDate: Date? = nil, to endDate: Date? = nil) {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        var predicates: [NSPredicate] = []
        
        if let startDate = startDate, let endDate = endDate {
            predicates.append(NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            activities = try managedObjectContext.fetch(request)
            checkThreshold()
        } catch {
            print("Error fetching activities: \(error)")
        }
    }

    func addActivity(description: String, amount: Double, date: Date, category: String) {
        let newActivity = Activity(context: managedObjectContext)
        newActivity.id = UUID()
        newActivity.descriptionText = description
        newActivity.amount = amount
        newActivity.date = date
        newActivity.category = category
        
        saveContext()
        fetchActivities()
    }

    func deleteActivity(at offsets: IndexSet) {
        offsets.forEach { index in
            let activity = activities[index]
            managedObjectContext.delete(activity)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
            fetchActivities() // Refresh the list after any change
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func checkThreshold() {
        let sum = activities.reduce(0) { $0 + $1.amount }
        if sum >= threshold {
            sendNotification(sum: sum)
        }
    }
    
    private func sendNotification(sum: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Threshold Alert"
        content.body = "Your spending has reached \(sum). This is over your threshold of \(threshold)."
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}



