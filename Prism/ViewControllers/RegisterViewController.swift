//
//  RegisterViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/25/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

// TODO: Use minY and maxY

import UIKit
import Material
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    // MARK: UIElements

    private var statusBarBackground: UIView!
    private var scrollView: UIScrollView!
    private var iconImageView: UIImageView!
    private var fullNameTextField: ErrorTextField!
    private var usernameTextField: ErrorTextField!
    private var emailTextField: ErrorTextField!
    private var passwordTextField: ErrorTextField!
    private var registerButton: UIButton!
    private var alreadyMemberButton: UIButton!

    var onDoneBlock : ((Bool) -> Void)?

    // MARK: Constraints

    private let defaultMargin: CGFloat = 16
    private let textFieldHeight: CGFloat = 30
    private let buttonHeight: CGFloat = 35
    private let iconToFullNameTextFieldOffset: CGFloat = 60
    private let passwordToRegisterButtonOffset: CGFloat = 45
    private let textFieldsOffset: CGFloat = 50
    private let textFieldActiveDividerHeight: CGFloat = 1.3
    private let textFieldNormalDividerHeight: CGFloat = 1
    private var defaultWidth: CGFloat!

    private let textFieldFont: UIFont = RobotoFont.regular(with: 18)
    private let buttonFont: UIFont = RobotoFont.regular(with: 18)

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Variables
        defaultWidth = Constraints.screenWidth() - 2*defaultMargin
        self.view.backgroundColor = UIColor.loginBackground
        ref = Database.database().reference()
        self.hideKeyboardWhenTappedAround()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.addObservers()
        initializeUIElements()
        self.view.bringSubview(toFront: statusBarBackground)
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("inside viewWillDisappear")
        self.removeObservers()
        try! Auth.auth().signOut()
    }

    /**
     Initializes all UIElements for the view controller
     */
    private func initializeUIElements() {
        initializeStatusBarBackground()
        initializeScrollView()
        initializeIconImageView()
        animateIconImageView()
        initializeFullNameTextField()
        initializeUsernameTextField()
        initializeEmailTextField()
        initializePasswordTextField()
        initializeRegisterButton()
        initializeAlreadyMemberButton()
    }

    private func initializeStatusBarBackground() {
        statusBarBackground = UIView()
        statusBarBackground.frame = CGRect(x: 0, y: 0, width: Constraints.screenWidth(), height: Constraints.statusBarHeight())
        statusBarBackground.backgroundColor = UIColor.statusBarBackground
        self.view.addSubview(statusBarBackground)

    }

    private func initializeScrollView() {
        scrollView = UIScrollView()
        let height: CGFloat = self.view.frame.height - Constraints.statusBarHeight() - Constraints.RegisterViewController.getAlreadyMemberButtonYOffset() - 10
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(scrollView)
    }

    private func initializeIconImageView() {
        iconImageView = UIImageView(image: UIImage(icon: .SPLASH_SCREEN_ICON))
        iconImageView.frame = Constraints.LoginViewController.getIconFrame()
        iconImageView.frame.origin.y += Constraints.statusBarHeight()
        iconImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(iconImageView)
    }

    private func initializeFullNameTextField() {
        fullNameTextField = ErrorTextField()
        let y: CGFloat = iconImageView.frame.origin.y + iconImageView.frame.height + iconToFullNameTextFieldOffset
        fullNameTextField.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: textFieldHeight)
        fullNameTextField.placeholder = "Full Name"
        fullNameTextField.detail = "Name can only contain letters, space, and apostrophe"
        fullNameTextField.isClearIconButtonAutoHandled = true
        fullNameTextField.delegate = self
        fullNameTextField.textColor = UIColor.white
        fullNameTextField.font = textFieldFont
        fullNameTextField.autocapitalizationType = .none
        fullNameTextField.dividerNormalHeight = textFieldNormalDividerHeight
        fullNameTextField.dividerActiveHeight = textFieldActiveDividerHeight
        fullNameTextField.placeholderNormalColor = UIColor.lightGray
        fullNameTextField.placeholderActiveColor = UIColor.materialBlue
        fullNameTextField.dividerNormalColor = UIColor.white
        fullNameTextField.dividerActiveColor = UIColor.materialBlue
        fullNameTextField.alpha = 0.0
        fullNameTextField.tag = 0
        scrollView.addSubview(fullNameTextField)
    }

    private func initializeUsernameTextField() {
        usernameTextField = ErrorTextField()
        let y: CGFloat = fullNameTextField.frame.origin.y + fullNameTextField.frame.height + textFieldsOffset
        usernameTextField.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: textFieldHeight)
        usernameTextField.placeholder = "Username"
        usernameTextField.detail = "Username must be at least 5 characters long"
        usernameTextField.isClearIconButtonAutoHandled = true
        usernameTextField.delegate = self
        usernameTextField.textColor = UIColor.white
        usernameTextField.font = textFieldFont
        usernameTextField.autocapitalizationType = .none
        usernameTextField.dividerNormalHeight = textFieldNormalDividerHeight
        usernameTextField.dividerActiveHeight = textFieldActiveDividerHeight
        usernameTextField.placeholderNormalColor = UIColor.lightGray
        usernameTextField.placeholderActiveColor = UIColor.materialBlue
        usernameTextField.dividerNormalColor = UIColor.white
        usernameTextField.dividerActiveColor = UIColor.materialBlue
        usernameTextField.alpha = 0.0
        usernameTextField.tag = 1
        scrollView.addSubview(usernameTextField)
    }

    private func initializeEmailTextField() {
        emailTextField = ErrorTextField()
        let y: CGFloat = usernameTextField.frame.origin.y + usernameTextField.frame.height + textFieldsOffset
        emailTextField.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: textFieldHeight)
        emailTextField.placeholder = "Email"
        emailTextField.detail = "Invalid email"
        emailTextField.isClearIconButtonAutoHandled = true
        emailTextField.delegate = self
        emailTextField.textColor = UIColor.white
        emailTextField.font = textFieldFont
        emailTextField.autocapitalizationType = .none
        emailTextField.dividerNormalHeight = textFieldNormalDividerHeight
        emailTextField.dividerActiveHeight = textFieldActiveDividerHeight
        emailTextField.placeholderNormalColor = UIColor.lightGray
        emailTextField.placeholderActiveColor = UIColor.materialBlue
        emailTextField.dividerNormalColor = UIColor.white
        emailTextField.dividerActiveColor = UIColor.materialBlue
        emailTextField.alpha = 0.0
        emailTextField.tag = 2
        scrollView.addSubview(emailTextField)
    }

    private func initializePasswordTextField() {
        passwordTextField = ErrorTextField()
        let y: CGFloat = emailTextField.frame.origin.y + emailTextField.frame.height + textFieldsOffset
        passwordTextField.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: textFieldHeight)
        passwordTextField.placeholder = "Password"
        passwordTextField.detail = "Password must be at least 6 characters long"
        passwordTextField.delegate = self
        passwordTextField.textColor = UIColor.white
        passwordTextField.font = textFieldFont
        passwordTextField.autocapitalizationType = .none
        passwordTextField.dividerNormalHeight = textFieldNormalDividerHeight
        passwordTextField.dividerActiveHeight = textFieldActiveDividerHeight
        passwordTextField.placeholderNormalColor = UIColor.lightGray
        passwordTextField.placeholderActiveColor = UIColor.materialBlue
        passwordTextField.dividerNormalColor = UIColor.white
        passwordTextField.dividerActiveColor = UIColor.materialBlue
        passwordTextField.isVisibilityIconButtonEnabled = true
        passwordTextField.isVisibilityIconButtonAutoHandled = false
        passwordTextField.visibilityIconButton?.tintColor = UIColor.white
        passwordTextField.visibilityIconButton?.addTarget(self, action: #selector(passwordVisibilityButtonAction(_:)), for: .touchUpInside)
        passwordTextField.rightViewMode = .always
        passwordTextField.alpha = 0.0
        passwordTextField.tag = 3
        scrollView.addSubview(passwordTextField)
    }

    private func initializeRegisterButton() {
        registerButton = UIButton()
        let y: CGFloat = passwordTextField.frame.origin.y + passwordTextField.frame.height + passwordToRegisterButtonOffset
        registerButton.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: buttonHeight)
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.backgroundColor = UIColor.materialBlue
        registerButton.titleLabel?.font = buttonFont
        registerButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        registerButton.alpha = 0.0
        scrollView.addSubview(registerButton)
        toggleRegisterButton()
        // set scrollview content size
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: y + buttonHeight + 20)
    }

    private func initializeAlreadyMemberButton() {
        alreadyMemberButton = UIButton()
        let y: CGFloat = self.view.frame.height - buttonHeight - Constraints.RegisterViewController.getAlreadyMemberButtonYOffset()
        alreadyMemberButton.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: buttonHeight)
        alreadyMemberButton.setTitle("Already a member? Login", for: .normal)
        alreadyMemberButton.backgroundColor = UIColor.clear
        alreadyMemberButton.setTitleColor(UIColor.white, for: .normal)
        alreadyMemberButton.titleLabel?.font = buttonFont
        alreadyMemberButton.addTarget(self, action: #selector(alreadyMemberButtonAction(_:)), for: .touchUpInside)
        alreadyMemberButton.alpha = 0.0
        self.view.addSubview(alreadyMemberButton)
    }

    /**
     Runs the animation for the icon, along with the rest of the uielements
     */
    private func animateIconImageView() {
        UIView.animate(withDuration: 0.75, animations: {
            self.iconImageView.frame = Constraints.RegisterViewController.getIconFrame()
        }, completion: { finished in
            UIView.animate(withDuration: 0.25, animations: {
                self.fullNameTextField.alpha = 1.0
                self.usernameTextField.alpha = 1.0
                self.emailTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
                self.registerButton.alpha = 1.0
                self.alreadyMemberButton.alpha = 1.0
            })
        })
    }


    // MARK: Button Actions

    /**
     Password TextField visibility icon action. Toggles the text entry for the password view.
     */
    @objc private func passwordVisibilityButtonAction(_ sender: IconButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.visibilityIconButton?.setImage(Icon.visibility?.tint(with: .white), for: .normal)
        } else {
            passwordTextField.visibilityIconButton?.setImage(Icon.visibilityOff?.tint(with: .white), for: .normal)
        }
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        // fixes cursor placement
        let tempText = passwordTextField.text
        passwordTextField.text = " ";
        passwordTextField.text = tempText
    }

    @objc private func registerButtonAction(_ sender: UIButton) {
        print("saveButton pressed")
        if (isFullNameValid(fullName: fullNameTextField.text!) &&
                isUsernameValid(username: usernameTextField.text!) &&
                isEmailValid(emailAddress: emailTextField.text!) &&
                isPasswordValid(password: passwordTextField.text!)){
            let myUser = MyUser(userName: usernameTextField.text!, fullName: fullNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, profilePic: generateProfilePicture())
            registerUserIfUserNameDoesNotExist(myUser: myUser)
        }  else {
            // TODO: UI for general error

            print("Registration Error")
        }
    }

    @objc private func alreadyMemberButtonAction(_ sender: UIButton) {
//        print("alreadyMemberButton pressed")
        onDoneBlock!(true)
        self.dismiss(animated: false, completion: nil)
    }

    /**
     Check if point is inside the password visibility icon touchable area.

     - parameters:
     - point: Tap gesture location as CGPoint

     - returns: Boolean (true if point inside icon touchable area)
     */
    private func isTapInPasswordVisibleIconArea(point: CGPoint) -> Bool {
        let minX: CGFloat = self.view.bounds.width - defaultMargin - passwordTextField.frame.height
        let maxX: CGFloat = self.view.bounds.width - defaultMargin
        let minY: CGFloat = passwordTextField.frame.origin.y
        let maxY: CGFloat = minY + passwordTextField.frame.height
        if (minX ... maxX ~= point.x) && (minY ... maxY ~= point.y) {
            return true
        }
        return false
    }

    // MARK: Register Functions

    /**
    Checks if username exists in the database, if so throws an error else creates a new user.

    -parameters:
    -myUser: new user of MyUser object

    - returns: None
    */
    func registerUserIfUserNameDoesNotExist(myUser : MyUser) {
        ref.child("ACCOUNTS").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(myUser.userName) {
                self.showErrorForTextField(self.usernameTextField, message: "Username exists")
            } else {
                self.registerUser(myUser: myUser)
            }
        })
    }

    /**
    Creates a new user with email and password. If user creation successful, user is added to Users and Accounts nodes

    - parameters:
    - myUser: MyUser object trying to add
    */
    func registerUser(myUser: MyUser) {
        Auth.auth().createUser(withEmail: myUser.email, password: myUser.password) { (user, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        self.showErrorForTextField(self.emailTextField, message: "Email already in use")
                    case .invalidEmail:
                        self.showErrorForTextField(self.emailTextField, message: "Invalid email")
//                    case .weakPassword:
//                        print("weak password")
                    default:
                        print("Create User Error: \(error!)")
                    }
                }

                print("could not save username")
                // TODO: UI for general error, possibly a snackbar
                return
            }
            self.addChildToUsers(userChild: user!, myUser: myUser)
            self.addChildToAccounts(myUser: myUser)
            print("Successfully Authenticated user")
        }
    }

    func addChildToUsers(userChild: User?, myUser : MyUser) {
        guard let uid = userChild?.uid else {
            return
        }
        let usersRef = ref.child("USERS").child(uid)
        let values: [String: String] = ["fullname": myUser.fullName,
                                        "profilepic" : myUser.profilePic,
                                        "username": myUser.userName]
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Successfully saved user child to users")
        })
    }

    func addChildToAccounts(myUser : MyUser) {
        let accountsRef = ref.child("ACCOUNTS")
        let values: [String: String] = [myUser.userName: myUser.email]
        accountsRef.updateChildValues(values, withCompletionBlock: {  (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Successfully saved userName child to Accounts")
        })
    }

    func generateProfilePicture() -> String {
        print("Inside randomProfilePicGenerator")
        // Random int between 1-10
        let profilePic = arc4random_uniform(10)
        return String(profilePic)
    }

    // MARK: TextField Error Functions

    func isFullNameValid(fullName: String) -> Bool {
        if fullName.count < 2 {
            fullNameTextField.detail = "Name must be at least 2 characters long"
            return false
        }
        if fullName.count > 70 {
            fullNameTextField.detail = "Name cannot be longer than 70 characters"
            return false
        }
        if !(String(fullName[fullName.startIndex])).isAlpha {
            fullNameTextField.detail = "Name must start with a letter"
            return false
        }
        if !(String(fullName.last!).isAlpha) && (fullName.last! != " ") {
            fullNameTextField.detail = "Name must end with a letter"
            return false
        }
        if !(fullName.range(of: "[^'a-zA-Z ]+", options: .regularExpression) == nil) {
            fullNameTextField.detail = "Name can only contain letters, space, and apostrophe"
            return false
        }
        if !(fullName.range(of: ".*(.)\\1{3,}.*", options: .regularExpression) == nil) {
            fullNameTextField.detail = "Name cannot contain more than 3 repeating characters"
            return false
        }
        if !(fullName.range(of: ".*(['])\\1{1,}.*", options: .regularExpression) == nil) {
            fullNameTextField.detail = "Name cannot contain more than 1 repeating apostrophe"
            return false
        }
        return true
    }


    func isUsernameValid(username: String) -> Bool{
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if username.count < 5 {
            usernameTextField.detail = "Username must be at least 5 characters long"
            return false
        }
        if username.count > 30 {
            usernameTextField.detail = "Username cannot be longer than 30 characters long"
            return false
        }
        if !(username.range(of: "[^a-z0-9._']+", options: .regularExpression) == nil) {
            usernameTextField.detail = "Username can only contain lowercase letters, numbers, period, and underscore"
            return false
        }
        if !(username.range(of: ".*([a-z0-9])\\1{5,}.*", options: .regularExpression) == nil) {
            usernameTextField.detail = "Username cannot contain more than 3 repeating characters"
            return false
        }
        if !(username.range(of: ".*([._]){2,}.*", options: .regularExpression) == nil) {
            usernameTextField.detail = "Username cannot contain more than 1 repeating symbol"
            return false
        }
        if !(String(username[username.startIndex])).isAlpha {
            usernameTextField.detail = "Username must start with a letter"
            return false
        }
        if !(String(username.last!).isAlpha || String(username.last!).isNumeric) {
            usernameTextField.detail = "Username must end with a letter or number"
            return false
        }
        return true
    }

    func isEmailValid(emailAddress: String) -> Bool {
        if !(NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: emailAddress)) {
            return false
        }
        return true
    }

    func isPasswordValid(password: String) -> Bool {
        if password.count > 5 {
            return true
        }
        return false
    }

    func areInputsValid() -> Bool {
        return isFullNameValid(fullName: fullNameTextField.text!) &&
                isUsernameValid(username: usernameTextField.text!) &&
                isEmailValid(emailAddress: emailTextField.text!) &&
                isPasswordValid(password: passwordTextField.text!)
    }

    // MARK: TextField Error Toggle Functions

    func toggleFullNameTextFieldError() {
        fullNameTextField.isErrorRevealed = !isFullNameValid(fullName: fullNameTextField.text!)
    }

    func toggleUsernameTextFieldError() {
        usernameTextField.isErrorRevealed = !isUsernameValid(username: usernameTextField.text!)
    }

    func toggleEmailTextFieldError() {
        emailTextField.isErrorRevealed = !isEmailValid(emailAddress: emailTextField.text!)
    }

    func togglePasswordTextFieldError() {
        passwordTextField.isErrorRevealed = !isPasswordValid(password: passwordTextField.text!)
    }

    func toggleRegisterButton() {
        let backgroundColor = areInputsValid() ? UIColor.materialBlue : Color.lightGray
        registerButton.backgroundColor = backgroundColor
    }

    func showErrorForTextField(_ textField: ErrorTextField, message: String) {
        textField.detail = message
        textField.isErrorRevealed = true
        animateTextFields()
    }

    func toggleTextFieldDividerColor() {

        if fullNameTextField.isErrorRevealed {
            fullNameTextField.dividerNormalColor = Color.red.base
            fullNameTextField.dividerActiveColor = Color.red.base
        } else {
            fullNameTextField.dividerNormalColor = UIColor.white
            fullNameTextField.dividerActiveColor = UIColor.materialBlue
        }

        if usernameTextField.isErrorRevealed {
            usernameTextField.dividerNormalColor = Color.red.base
            usernameTextField.dividerActiveColor = Color.red.base
        } else {
            usernameTextField.dividerNormalColor = UIColor.white
            usernameTextField.dividerActiveColor = UIColor.materialBlue
        }

        if emailTextField.isErrorRevealed {
            emailTextField.dividerNormalColor = Color.red.base
            emailTextField.dividerActiveColor = Color.red.base
        } else {
            emailTextField.dividerNormalColor = UIColor.white
            emailTextField.dividerActiveColor = UIColor.materialBlue
        }

        if passwordTextField.isErrorRevealed {
            passwordTextField.dividerNormalColor = Color.red.base
            passwordTextField.dividerActiveColor = Color.red.base
        } else {
            passwordTextField.dividerNormalColor = UIColor.white
            passwordTextField.dividerActiveColor = UIColor.materialBlue
        }
    }

    func computeYValues() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let usernameOffset: CGFloat = fullNameTextField.isErrorRevealed ? 15.0 : 0.0
        let emailOffset: CGFloat = usernameTextField.isErrorRevealed ? 15.0 : 0.0
        let passwordOffset: CGFloat = emailTextField.isErrorRevealed ? 15.0 : 0.0

        let usernameY: CGFloat = fullNameTextField.frame.maxY + textFieldsOffset + usernameOffset
        let emailY: CGFloat = usernameY + textFieldHeight + textFieldsOffset + emailOffset
        let passwordY: CGFloat = emailY + textFieldHeight + textFieldsOffset + passwordOffset
        let registerY: CGFloat = passwordY + textFieldHeight + passwordToRegisterButtonOffset

        return (usernameY, emailY, passwordY, registerY)
    }

    func animateTextFields() {
        // TODO: fullNameTextField animates for no reason
        let (usernameY, emailY, passwordY, registerY) = computeYValues()
        UIView.animate(withDuration: 0.25, animations: {
            self.fullNameTextField.frame.origin.y = self.fullNameTextField.frame.origin.y + 0
            self.usernameTextField.frame.origin.y = usernameY
            self.emailTextField.frame.origin.y = emailY
            self.passwordTextField.frame.origin.y = passwordY
            self.registerButton.frame.origin.y = registerY
            self.toggleRegisterButton()
            self.toggleTextFieldDividerColor()
        })
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: registerY + buttonHeight + 20)
    }

}

// MARK: ScrollView Functions for Keyboard
extension RegisterViewController {
    /**
     Adds UIKeyboardWillShow and UIKeyboardWillHide observers to the view.
     Called in viewWillAppear method.
     */
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }

        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification: notification)
        }
    }

    /**
     Removes UIKeyboardWillShow and UIKeyboardWillHide observers from the view
     Called in viewWillDisappear method.
     */
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    /**
     UIKeyboardWillShow action. Makes the view scrollable if the TextFields are hidden under the keyboard.
     */
    private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 5, right: 0)
        scrollView.contentInset = contentInset
    }

    /**
     UIKeyboardWillHide action. Removes the contentInset for the scrollView.
     */
    private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
}

// MARK: TextField Delegate
extension RegisterViewController: TextFieldDelegate {

    func textField(textField: TextField, didChange text: String?) {
        switch textField.tag {
        case 0:
            toggleFullNameTextFieldError()
        case 1:
            toggleUsernameTextFieldError()
        case 2:
            toggleEmailTextFieldError()
        case 3:
            togglePasswordTextFieldError()
        default:
            (textField as? ErrorTextField)?.isErrorRevealed = false
        }
        animateTextFields()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: View Tap Gesture
extension RegisterViewController {
    /**
     Tap Gesture for the view controller to hide keyboard.
     */
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /**
     Tap gesture recognizer. Checks if the password visibility icon is pressed, if so keyboard is not dismissed.
     If tapped anywhere else except for the textfield, keyboard is dismissed.
     */
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.scrollView)
        if !isTapInPasswordVisibleIconArea(point: point) {
            self.view.endEditing(true)
        }
    }
}