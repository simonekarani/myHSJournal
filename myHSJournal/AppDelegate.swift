//
//  AppDelegate.swift
//  myHSJournal
//
//  Created by Simone Karani on 10/25/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var modelName: String = "myHSJournalModel"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    /*init(modelName xcdataModel: String){
        modelName = xcdataModel as String
    }*/

    // MARK: - Core data stack
    lazy var managedObjectContext: NSManagedObjectContext = {
        let _moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        _moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
        return _moc
    }()

    lazy var backgroundContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        let coordinator = self.persistentStoreCoordinator
        var _backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _backgroundContext.persistentStoreCoordinator = coordinator
        _backgroundContext.performAndWait({ () -> Void in
            _backgroundContext.parent = self.managedObjectContext
        })
        
        return _backgroundContext
    }()

    lazy var saveObjectContext: NSManagedObjectContext = {
        var _moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
        return _moc
    }()

    // MARK: - Core Data stack (generic)
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    // MARK: - URLs
    lazy var storeURL: NSURL = {
        return (self.applicationDocumentsDirectoryURL).appendingPathComponent("\(self.modelName).sqlite")! as NSURL
    }()

    // MARK: - utility routines
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL as URL, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            //dict[NSUnderlyingErrorKey] = error as! NSError //ignore the warning. trying to fix it will cause an error.
            let wrappedError = NSError(domain: "com.name.app", code: 9999, userInfo: dict)
            debugPrint("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        return coordinator
    }()

    // MARK: - Core Data stack (iOS 10)
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "myHSJournal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data context
    lazy var databaseContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            return self.persistentContainer.viewContext
        } else {
            return self.managedObjectContext
        }
    }()

    // MARK: - SAVE
    public class func saveContext(managedObjectContext context:NSManagedObjectContext){
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
        }
    }
    
    func saveContext () {
        return AppDelegate.saveContext(managedObjectContext: self.managedObjectContext)
    }
    
    func saveBackGroundContext () {
        return AppDelegate.saveContext(managedObjectContext: self.backgroundContext!)
    }

    func deleteAllRecords() {
        do {
            if databaseContext.hasChanges {
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "myHSJournal")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

                try databaseContext.execute(deleteRequest)
                try databaseContext.save()
            }
        } catch {
            let nserror = error as NSError
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Convenience
    lazy var applicationDocumentsDirectoryURL: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "research.softway.sync.coredata_sample" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
}

