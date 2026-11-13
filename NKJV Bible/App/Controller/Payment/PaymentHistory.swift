//
//  PaymentHistory.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 30/04/21.
//

import UIKit
import CoreData




class PaymentHistory: NSObject {
  static let sharedInstance = PaymentHistory()
    
    var PayList:Array<NSDictionary> = []
    var WholeList:Dictionary<String, AnyObject> = [:]
    
    var Enddate: String = ""
    var TransactionId: String = ""
    var StartDate: String = ""
    var product_id:String = ""
    
    
    var Appdate: Array<String> = []
    
    
    func paymentInfo() -> Bool {
        var date = CoreDataModel.sharedInstance.GetEndDate(entity: CDPaymentdateAPI)
                if date == "" {
                    date = Date().string(format: "dd-MM-yyyy")
                }
                let showDate1 = GetReceptKey.shared.convertData(date: date)
        
        if showDate1.isGreaterThan(Date()) || (IS_SUBSCRIPTION_ENABLE == 1 && SUBSCRIPTIONID_LifeTime != "" && UserDefaults.standard.string(forKey: "PaymentId") ?? "" == SUBSCRIPTIONID_LifeTime) || ADS_TYPE == 0 {
                    return false
                } else {
                    return true
                }
    }
    
    
    
    func paymentInfoVerify() -> Bool {
        var date = CoreDataModel.sharedInstance.GetEndDate(entity: CDPaymentdateAPI)
                if date == "" {
                    date = Date().string(format: "dd-MM-yyyy")
                }
                let showDate1 = GetReceptKey.shared.convertData(date: date)
            
           if showDate1.isGreaterThan(Date()) || (IS_SUBSCRIPTION_ENABLE == 1 && SUBSCRIPTIONID_LifeTime != "" && UserDefaults.standard.string(forKey: "PaymentId") ?? "" == SUBSCRIPTIONID_LifeTime) {
               return false
            } else {
                return true
            }
    }
    
    
    
    func Getpayment(completion:@escaping () -> ()) {
        NetworkManager.sharedInstance.GetPay_History(url: API_VERIFY_RECEIPT, completion:{ (resultDictionary, error) -> () in
            
            
            if resultDictionary != nil {
                if resultDictionary!.count > 3 {
                    self.product_id.removeAll()
                    self.Appdate.removeAll()
                    var product:[String] = []
                    if resultDictionary != nil  {
                          self.WholeList = resultDictionary?["receipt"] as! Dictionary<String, AnyObject>
                          self.PayList = self.WholeList["in_app"] as! Array<NSDictionary>
                                        
                        for i in 0..<self.PayList.count {
                            let dic = self.PayList[i] as! Dictionary<String, AnyObject>
                            let purchacedate = dic.stringValueForKey("original_purchase_date").components(separatedBy: " ")
                            
                            if dic.stringValueForKey("product_id") == SUBSCRIPTIONID_LifeTime {
                                UserDefaults.standard.setValue(SUBSCRIPTIONID_LifeTime, forKey: "PaymentId")
                                self.product_id = dic.stringValueForKey("product_id")
                            } else {
                                self.product_id = dic.stringValueForKey("product_id")
                            }
                            self.TransactionId = dic.stringValueForKey("original_transaction_id")
                            self.StartDate = dic.stringValueForKey("original_purchase_date")
                            product.append(self.product_id)
                            self.Appdate.append(purchacedate[0])
                          }
                        self.DateOrder(DateArray: self.Appdate)
                        completion()
                    }
                } else {
                    completion()
                }
            } else {
                completion()
            }
            
        })
    }
        
    func DateConvert(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    

    func DateOrder(DateArray:Array<String>) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let Current_Date = DateArray.sorted(by: { dateFormatter.date(from:$0)!.compare(dateFormatter.date(from:$1)!) == .orderedDescending })
        
        let next1Year = Calendar.current.date(byAdding: .day, value: 365, to: self.DateConvert(dateString: Current_Date[0]))
        self.Enddate = next1Year!.string(format: "dd-MM-yyyy")
        self.saveEndDAte()
        NotificationCenter.default.post(name: Notification.Name("ReloadTable"), object: nil)
    }
    
    func saveEndDAte() {
         CoreDataModel.sharedInstance.deleteAllData(CDPaymentdateAPI)
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appdelegate.persistentContainer.viewContext
            let userEntity = NSEntityDescription.entity(forEntityName: CDPaymentdateAPI, in: managedContext)
            let user = NSManagedObject(entity: userEntity!, insertInto: managedContext)
                           
                    user.setValue(self.Enddate, forKey: "endDate")
                    user.setValue(self.TransactionId, forKey: "transactionId")
                    user.setValue(self.StartDate, forKey: "startDate")
                    user.setValue(self.product_id, forKey: "productId")
        
                   let parameters = ["udid":Udid,
                                     "dev_app_id":push_appid,
                                     "dev_type":dev_id_type,
                          "receipt_data": GetReceptKey.shared.ReceptId() ] as [String : AnyObject]
                    do {
                        try managedContext.save()
                        NetworkManager.sharedInstance.requestPOSTTestData(urlString: SUBSCRIPTION_API,params:parameters,  completion:
                            { (resultDictionary, error) -> () in
                             
                            })
                } catch let error  as NSError {
                        print("Could not save: \(error),\(error.userInfo)")
            }
    }
    

    
    
}



