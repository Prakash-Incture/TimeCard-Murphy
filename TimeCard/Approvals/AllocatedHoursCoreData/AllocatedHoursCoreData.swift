//
//  AllocatedHoursCoreData.swift
//  TimeCard
//
//  Created by PremKumar on 09/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation
import CoreData

class AllocationHoursCoreData: CoreDataProtocol{
    
    var persistantContainer: NSPersistentContainer
    var isSyncInprogress: Bool = false
    
    required init(modelName: String) {
        self.persistantContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()-> Void)? = nil) {
        self.persistantContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else { fatalError("unable to initialise") }
            completion?()
        }
    }
    
    func saveRequest(_ request: URLRequest, for purpose: String? = nil) {
//        let offlineUpdate = AllocationOfflineData(context: self.viewContext)
//        offlineUpdate.urlRequest = request
//        offlineUpdate.requestType = purpose
//        self.saveChanges()
    }
    
    func saveAllocationHour(allocationModel: AllocationModel, withDate date: String) {
        let offlineUpdate = AllocationOfflineData(context: self.viewContext)
        offlineUpdate.allocationModel = AllocationHoursCoreData.self.archive(allocationModel: allocationModel)
        offlineUpdate.date = date
        self.saveChanges()
    }
    
    func removePreviousData(fetchRequest: NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate?) {
        fetchRequest.predicate = predicate
        
        if let result = try? self.viewContext.fetch(fetchRequest), !result.isEmpty {
            for object in result {
                self.removeOldData(object: object as! NSManagedObject)
            }
        }
    }
    
    func fetchAllFrequesntSeraches(with predicate: NSPredicate) -> [NSManagedObject] {
        return get(withPredicate: predicate, entity: "AllocationOfflineData")
    }
    
    func get(withPredicate queryPredicate: NSPredicate, entity: String) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = queryPredicate
        do {
            let response = try self.viewContext.fetch(fetchRequest)
            return response as! [AllocationOfflineData]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [AllocationOfflineData]()
        }
    }
}

extension AllocationHoursCoreData{
    static func archive(allocationModel: AllocationModel) -> Data {
        var allocation = allocationModel
        return Data(bytes: &allocation, count: MemoryLayout<AllocationModel>.stride)
    }

    func unarchive(allocationData: Data) -> AllocationModel {
        guard allocationData.count == MemoryLayout<AllocationModel>.stride else {
            fatalError("Error!")
        }

        var allocationModel: AllocationModel?
        allocationData.withUnsafeBytes({(bytes: UnsafePointer<AllocationModel>) -> Void in
            allocationModel = UnsafePointer<AllocationModel>(bytes).pointee
        })
        return allocationModel!
    }
}