//
//  swiftlogin.swift
//  GroceryStore
//
//  Created by alaa on 4/13/20.
//  Copyright © 2020 Way. All rights reserved.
//

import UIKit
import FirebaseUI

class swiftlogin: UIViewController {
    
    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth: Auth?
    fileprivate(set) var authUI: FUIAuth?
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        
       
     auth = Auth.auth()
            authUI = FUIAuth.defaultAuthUI()

        authUI?.delegate = self
            let phoneProvider = FUIPhoneAuth.init(authUI: authUI!)
            authUI?.providers = [phoneProvider]
        DispatchQueue.main.async {
            phoneProvider.signIn(withPresenting: self, phoneNumber: nil);
        }
    }
    
   
}

extension swiftlogin:FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            return
        }
        
        //authDataResult?.user.uid
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.isToolbarHidden = true
           self.navigationController?.isNavigationBarHidden = true
       }
  
    
    
}
