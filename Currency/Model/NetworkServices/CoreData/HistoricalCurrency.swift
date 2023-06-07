//
//  HistoricalCurrency.swift
//  Currency
//
//  Created by Sohila on 06/06/2023.
//

import CoreData
import UIKit

class CoreDataManager
{
    static var context : NSManagedObjectContext?
    static var appDelegate : AppDelegate?
    
    static func saveToCoreData(currencyAmount: String , currencyFrom: String, currencyTo: String , currencyResult: String)
    {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        
        guard let myContext = context else{return}
        
        let entity = NSEntityDescription.entity(forEntityName: "HistoricalCurrency", in: myContext)
        
        guard let myEntity = entity else{return}
        
        do{
            let historicalCurrencies = NSManagedObject(entity: myEntity, insertInto: myContext)
            historicalCurrencies.setValue(currencyAmount, forKey: "amount")
            historicalCurrencies.setValue(currencyFrom, forKey: "from")
            historicalCurrencies.setValue(currencyTo, forKey: "to")
            historicalCurrencies.setValue(currencyResult, forKey: "result")
            print("Saved Successfully")
            
            try myContext.save()
            
        }catch let error{
            
            print(error.localizedDescription)
        }
    }
    
    static func fetchFromCoreData() ->[HistoricalCurrencyModel]
    {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "HistoricalCurrency")
        var arrayOfHistoricalCurrency : [HistoricalCurrencyModel] = []
        
        do{
            let historicalCurrency = try context?.fetch(fetch)
            
            guard let historicalCurrencies = historicalCurrency else{return []}
            
            for item in historicalCurrencies
            {
                let currencyAmount = item.value(forKey: "amount")
                let currencyFrom = item.value(forKey: "from")
                let currencyTo = item.value(forKey: "to")
                let currencyResult = item.value(forKey: "result")
                
                let historicalCurr = HistoricalCurrencyModel(amount: currencyAmount as! String, from: currencyFrom as! String, to: currencyTo as! String, result: currencyResult as! String)
                
                arrayOfHistoricalCurrency.append(historicalCurr)
            }
            
        }catch let error
        {
            print(error.localizedDescription)
        }
        print(arrayOfHistoricalCurrency)
        return arrayOfHistoricalCurrency
    }
    
}
