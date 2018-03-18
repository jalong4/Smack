//
//  Utils.swift
//  Smack
//
//  Created by Jim Long on 3/18/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import Foundation

class Utils {
    static func isEmailValid(_ email: String?) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
    
    static func isUsernameValid(_ username: String?) -> Bool {
        // "0-9 a-z A-Z _ between 6 and 18 characters in length
        return NSPredicate(format:"SELF MATCHES %@", "^[0-9a-zA-Z\\_]{6,18}$").evaluate(with: username)
    }
    
    static func isPasswordValid(_ password: String?) -> Bool {
        
        //          1 - Password length is 6 or greater.
        return NSPredicate(format:"SELF MATCHES %@", "^[0-9a-zA-Z\\_]{6,}$").evaluate(with: password)
        
        /*
         1 - Password length is 6 or greater.
         2 - At least one letter in Password.
         3 - at least one Special Character in Password.
         
         */
        
//        return NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}").evaluate(with: password)
    }
}
