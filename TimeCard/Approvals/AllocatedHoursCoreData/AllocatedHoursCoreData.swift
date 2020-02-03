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
    
    func saveAllocationHour(allocationModel: AllocationModel, withDate date: Date) {
        let offlineUpdate = AllocationOfflineData(context: self.viewContext)
        offlineUpdate.allocationModel = AllocationHoursCoreData.self.archive(allocationModel: allocationModel)
        offlineUpdate.date = date
        offlineUpdate.key = "Allocation"
        self.saveChanges()
    }
    
    func saveAbsenceHour(absenceModel: Absence, withDate date: Date) {
        let offlineUpdate = AllocationOfflineData(context: self.viewContext)
        offlineUpdate.allocationModel = AllocationHoursCoreData.self.archiveAbsence(absenceModel: absenceModel)
        offlineUpdate.date = date
        offlineUpdate.key = "Absence"
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
    
    // Remove offline object using unique id
    func removePreviousDataWithUniqueId(fetchRequest: NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate?, uniqueId: Double = 0.0, isUpdate: Bool = false, absenceModel: Absence = Absence()) {
        fetchRequest.predicate = predicate
        
        if let result = try? self.viewContext.fetch(fetchRequest) as? [AllocationOfflineData], !result.isEmpty {
            
            for object in result {
                guard let dataObj = object.allocationModel else {return}
                if object.key == "Allocation"{
                    let allocationObj = self.unarchive(allocationData: dataObj)
                    if allocationObj.uniqueId == uniqueId{
                        self.removeOldData(object: object as NSManagedObject)
                        return
                    }
                }else{
                    let allocationObj = self.unarchiveAbsence(absenceData: dataObj)
                    if isUpdate{
                        if allocationObj.uniqueId == uniqueId{
                            removeAbsenceModels(referenceData: allocationObj, offlineDatas: result)
                        }
                        
                    }else{
                        if allocationObj.uniqueId == uniqueId{
                            self.removeOldData(object: object as NSManagedObject)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func removeAbsenceModels(referenceData: Absence, offlineDatas: [AllocationOfflineData]) {
        
        for object in offlineDatas{
            guard let dataObj = object.allocationModel else {return}
            let allocationObj = self.unarchiveAbsence(absenceData: dataObj)
            if allocationObj.dateStart == referenceData.dateStart && allocationObj.dateEnd == referenceData.dateEnd{
                self.removeOldData(object: object as NSManagedObject)
            }
        }
        return
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
    
    func updateDataBase(managedObject: NSManagedObject, with data: Any?) {
        var archivedData: Data?
        if let absenceObj = data as? Absence{
           archivedData = AllocationHoursCoreData.archiveAbsence(absenceModel: absenceObj)
        }else if let allocationObj = data as? AllocationModel{
            archivedData = AllocationHoursCoreData.archive(allocationModel: allocationObj)
        }
            managedObject.setValue(archivedData, forKey: "allocationModel")
            self.saveChanges()
    }
    
    func updatePreviousDataWithUniqueId(fetchRequest: NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate?, uniqueId: Double, updatedObj: Any) {
        fetchRequest.predicate = predicate
        
        if let result = try? self.viewContext.fetch(fetchRequest) as? [AllocationOfflineData], !result.isEmpty {
            for object in result {
                
                guard let dataObj = object.allocationModel else {return}
                if object.key == "Allocation"{
                    let allocationObj = self.unarchive(allocationData: dataObj)
                    if allocationObj.uniqueId == uniqueId{
                        self.updateDataBase(managedObject: object as NSManagedObject, with: updatedObj as Any)
                        return
                    }
                }else{
                    let absenceObj = self.unarchiveAbsence(absenceData: dataObj)
                    if absenceObj.uniqueId == uniqueId{
                        self.updateDataBase(managedObject: object as NSManagedObject, with: updatedObj as Any)
                        return
                    }
                }
            }
        }
    }
}

extension AllocationHoursCoreData{
    static func archive(allocationModel: AllocationModel) -> Data {
        var allocation = Data()
        do{
            allocation = try JSONEncoder().encode(allocationModel)
        }catch{
            print("Encoding error !")
        }
        return allocation
    }
    
    static func archiveAbsence(absenceModel: Absence) -> Data {
        var absence = Data()
        do{
            absence = try JSONEncoder().encode(absenceModel)
        }catch{
            print("Encoding error !")
        }
        return absence
    }

    func unarchive(allocationData: Data) -> AllocationModel {
        var allocationModel = AllocationModel()
        do{
            allocationModel = try JSONDecoder().decode(AllocationModel.self, from: allocationData)
        }catch{
            print("Decoding error !")
        }
        return allocationModel
    }
    
    func unarchiveAbsence(absenceData: Data) -> Absence {
        var absenceModel = Absence()
        do{
            absenceModel = try JSONDecoder().decode(Absence.self, from: absenceData)
        }catch{
            print("Decoding error !")
        }
        return absenceModel
    }
}
