//
//  ViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/21/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AreInputsValid(_ sender: Any) {
//        registerButtonClicked()
        try! Auth.auth().signOut()
//         Inputs need to be formatted
//        getEmailFromFirebaseWithUsername(userName: "mikechoch")
    }

    func registerButtonClicked(){

        if (isFullNameValid(fullname: fullNameTextField.text!) && isUsernameValid(username: userNameTextField.text!) && isEmailValid(emailAddress: emailTextField.text!) && isPasswordValid(password: passwordTextField.text!)){
            let myUser = MyUser(userName: userNameTextField.text!, fullName: fullNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, profilePic: randomProfilePicGenerator())
            registerUserIfUserNameDoesNotExist(myUser: myUser)
        }
        else{
            print("Registration Error")
        }

    }

    func registerUserIfUserNameDoesNotExist(myUser : MyUser){
        print("Inside registerUserIfUserNameDoesNotExist")
//        let accountsRef = ref.child("ACCOUNTS")
        ref.child("ACCOUNTS").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(myUser.userName){
                print("Username exists")
                // TODO: Display error to screen
            }else{
                print("Username doesn't exist")
                self.registerUser(myUser: myUser)
            }
        })
    }

    func registerUser(myUser: MyUser) {
        print("Inside registerUser")
        Auth.auth().createUser(withEmail: myUser.email, password: myUser.password) { (user, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        print("email is already in use")
                    // TODO: Email error UI
                    case .invalidEmail:
                        print("invalid email")
                    case .weakPassword:
                        print("weak password")
                    default:
                        print("Create User Error: \(error!)")
                    }
                }

                print("could not save username")
                // TODO: UI for general error
                return
            }
            self.addUserChildtoUsers(userChild: user!, myUser: myUser)
            self.addUsernameChildtoAccounts(myUser: myUser)
            print("Successfully Authenticated user")
        }
    }

    func addUserChildtoUsers(userChild: User?, myUser : MyUser){
        print("Inside addUserChildtoUsers")
        guard let uid = userChild?.uid else {
            return
        }
        let usersRef = ref.child("USERS").child(uid)
        let values = ["fullname": myUser.fullName,
                      "profilepic" : myUser.profilePic,
                      "username": myUser.userName]
        usersRef.updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("Successfully saved user child to users")
        })
    }

    func addUsernameChildtoAccounts(myUser : MyUser){
        print("Inside addUsernameChildtoAccounts")
        let accountsRef = ref.child("ACCOUNTS")
        let values = [myUser.userName: myUser.email]
        accountsRef.updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("Successfully saved userName child to Accounts")
        })
    }

    func randomProfilePicGenerator() -> String {
        print("Inside randomProfilePicGenerator")
        // Random int between 1-10
        let profilePic = arc4random_uniform(10)
        return String(profilePic)
    }

    func isFullNameValid(fullname: String) -> Bool{
        print("Inside isFullNameValid")
        if fullname.count < 2 {
            print("Name must be at least 2 characters long")
            return false
        }
        if fullname.count > 70 {
            print("Name cannot be longer than 70 characters")
            return false
        }
        if !(String(fullname[fullname.startIndex])).isAlpha {
            print("Name must start with a letter")
            return false
        }
        if !(String(fullname.last!).isAlpha) {
            print("Name must end with a letter")
            return false
        }
        if !(fullname.range(of: "[^'a-zA-Z ]+", options: .regularExpression) == nil) {
            print("Name can only contain letters, space, and apostrophe")
            return false
        }
        if !(fullname.range(of: ".*(.)\\1{3,}.*", options: .regularExpression) == nil) {
            print("Name cannot contain more than 3 repeating characters")
            return false
        }
        if !(fullname.range(of: ".*(['])\\1{1,}.*", options: .regularExpression) == nil) {
            print("Name cannot contain more than 1 repeating apostrophe")
            return false
        }
        return true
    }


    func isUsernameValid(username: String) -> Bool{
        print("Inside isUsernameValid")
        if username.count < 5 {
            print("Username must be at least 5 characters long")
            return false
        }
        if username.count > 30 {
            print("Username cannot be longer than 30 characters long")
            return false
        }
        if !(username.range(of: "[^a-z0-9._']+", options: .regularExpression) == nil) {
            print("Username can only contain lowercase letters, numbers, period, and underscore")
            return false
        }
        if !(username.range(of: ".*([a-z0-9])\\1{5,}.*", options: .regularExpression) == nil) {
            print("Username cannot contain more than 3 repeating characters")
            return false
        }
        if !(username.range(of: ".*([._]){2,}.*", options: .regularExpression) == nil) {
            print("Username cannot contain more than 1 repeating symbol")
            return false
        }
        if !(String(username[username.startIndex])).isAlpha {
            print("Username must start with a letter")
            return false
        }
        if !(String(username.last!).isAlpha || String(username.last!).isNumeric) {
            print("Username must end with a letter or number")
            return false
        }
        return true
    }

    func isEmailValid(emailAddress: String) -> Bool{
        print("Inside isEmailValid")
        if !(NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: emailAddress))
        {
            print("Invalid email")
            return false
        }
        return true
    }

    func isPasswordValid(password: String) -> Bool{
        print("Inside isPasswordValid")
        if password.count > 5 {
            return true
        }
        print("Password must be at least 6 characters long")
        return false
    }


    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // LOG IN FUNCTIONS (Back End)
        // Inputs need to be formatted
    
    func logInButtonPressed() {
        print("Inside logInButtonPressed")
        if isLoginPasswordValid(password: passwordTextField.text!){
            if (isInputAnEmail(input: userNameTextField.text!)){
                attemptSignInWithEmail(email: userNameTextField.text!, password: passwordTextField.text!)
            }
            else{

                attemptSignInWithUserName(userName: userNameTextField.text!, password: passwordTextField.text!)
            }
        }
        else{
            print("Error: Invalid Login")
        }
    }
    
    func getEmailFromFirebaseWithUsername(userName: String, password : String) {
        print("Inside getEmailFromFirebaseWithUsername")
        let usernameKey = ref.child("ACCOUNTS").child(userName)
        usernameKey.observeSingleEvent(of: .value, with: { snapshot in
            let email = String(describing: snapshot.value!)
            self.attemptSignInWithEmail(email: email, password: password)
        })
    }

    func isLoginPasswordValid(password: String) -> Bool {
        print("Inside isLoginPasswordValid")
        if password.count > 5 {
            return true
        }
        return false
    }

    func attemptSignInWithUserName(userName : String, password : String) {
        print("Inside attemptSignInWithUserName")
        let accountsRef = ref.child("ACCOUNTS").child(userName)
        accountsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.getEmailFromFirebaseWithUsername(userName: userName, password: password)
            } else {
                print("Username does not exist")
            }
        })
    }

    func isInputAnEmail (input : String) -> Bool{
        print("Inside isInputAnEmail" )
        if !(NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: input))
        {
            return false
        }
        return true
    }

    func attemptSignInWithEmail(email: String, password: String) {
        print("Inside attemptSignInWithEmail")
        print(email)
        print(password)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("invalid login")
                return
            }
            print("User logged in")
        }
    }

}


extension String {
    var isAlpha: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
extension String {
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
}

