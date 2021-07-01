//
//  MySwiftClass.swift
//  GroceryStore
//
//  Created by Admin on 04/11/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//


import Foundation
import UIKit


import UserNotifications
import FirebaseAuth





class MySwiftClass: NSObject {
    
    @objc public func notify_push(){
      
        
    let content = UNMutableNotificationContent()
           content.title = "Title"
           content.body = "Body"
        content.sound = UNNotificationSound.default
           
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
           
           let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
           UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
           
    }

    @objc public func prentmsg(str:String){
        print(str );
    }
  
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        print("test_token")
        print(token)
    }
    
    
    @objc public func showNotyfy(){
       
       
        
    /*
        let center = UNUserNotificationCenter.current()
               
               center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
               }
               
               // Step 2: Create the notification content
               let content = UNMutableNotificationContent()
               content.title = "Hey I'm a notification!"
               content.body = "Look at me!"
               
               // Step 3: Create the notification trigger
               let date = Date().addingTimeInterval(10)
               
               let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
               
               let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
               
               // Step 4: Create the request
               
               let uuidString = UUID().uuidString
               
               let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
               
               // Step 5: Register the request
               center.add(request) { (error) in
                   // Check the error parameter and handle any errors
               }
 */
        print("notify")
        
     
     
        
    }
   
    
    var response = [String: Any]()
    var str = String()
    var verifiyID = String()
    var txt_code = String()
    

    
    @objc public func logphone(phone:String){
      //  Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
         //  let phoneNumber = "+9647503033342"
         //  let phoneNumber = "+16505553555"
         // let phoneNumber = "+9647503033342"
         // let phoneNumber = "+9647501519009"
          
         // let phoneNumber = "+9647504213110"
         // Auth.auth().settings.isAppverificationDisabledForTesting = true
        
        
       // Auth.auth()
      
        /*
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("==== This is device token ",token)
        let data = Data(token.utf8)
        Auth.auth().setAPNSToken(data, type: AuthAPNSTokenType.unknown)
     */
          
          PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
              if error != nil {
                  print("eror: \(String(describing: error?.localizedDescription))")
              } else {
                  let defaults = UserDefaults.standard
                  defaults.set(verificationID, forKey: "authVerificationID")
                   print("verificationID: \(verificationID)")
                  DispatchQueue.main.async { // Correct
                    self.isCodeSend = true;
                    print("Code send to : \(phone)")
                    //  self.bt_login.setTitle("Virefy code", for: .normal)
                    //  self.text.text = "Code send to : \(phoneNumber)"
                  }
                //  self.performSegue(withIdentifier: "code", sender: Any?.self)
              }
          }
        
        
          

      }
      
 
 @objc public  var islogin:Bool = false;
 @objc public  var isCodeSend:Bool = false;
    
     @objc public func viryfy(code:String) -> Bool{
        txt_code = code
          let verificationCode:String = txt_code
          print(verificationCode)
     
          
          if(verificationCode.count > 0){
          
          let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
          if verificationID != nil {
        
          let credential = PhoneAuthProvider.provider().credential(
              withVerificationID: verificationID!,verificationCode: verificationCode)
          
          Auth.auth().signIn(with: credential) { (authResult, error) in
              if let error = error {
                  print(error)
                 self.islogin = false;
                  return
              }
            //  print(authResult?.phoneNumber)
            self.islogin = true;
           
              
              }
              
          }
          }else{
              DispatchQueue.main.async { // Correct
               //   self.text.text = "Please Input Code Virification"
                print("Please Input Code Virification")
                  self.islogin = false;
              }
          }
        return self.islogin;
          
      }
      
    
     @objc public func logout()  {
          let firebaseAuth = Auth.auth()
          do {
             
              try firebaseAuth.signOut()
          } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
          }
      }

    
    @objc public func onUserLogin()  {
          let firebaseAuth = Auth.auth()
        
              if (firebaseAuth.currentUser != nil){
              
                print ("phoneNumber: %@", firebaseAuth.currentUser?.phoneNumber)
              }
            
              //  try firebaseAuth.signOut()
          
      }
      
 
    
    

}



