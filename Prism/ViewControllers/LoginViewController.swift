//
//  ViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/21/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

// TODO: Login Button to loading spinner animation
// TODO: Too many requests error

import UIKit
import Material
import Motion
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: UIElements
    private var statusBarBackground: UIView!
    private var scrollView: UIScrollView!
    private var iconImageView: UIImageView!
    private var emailTextField: ErrorTextField!
    private var passwordTextField: ErrorTextField!
    private var loginButton: UIButton!
    private var registerButton: UIButton!

    // MARK: Constraints
    private let defaultMargin: CGFloat = 16
    private let textFieldHeight: CGFloat = 30
    private let buttonHeight: CGFloat = 35
    private let iconEmailTextFieldOffset: CGFloat = 60
    private let emailPasswordTextFieldOffset: CGFloat = 75
    private let passwordLoginButtonOffset: CGFloat = 45
    private let textFieldActiveDividerHeight: CGFloat = 1.3
    private let textFieldNormalDividerHeight: CGFloat = 1
    private var defaultWidth: CGFloat!

    private let textFieldFont: UIFont = RobotoFont.regular(with: 18)
    private let buttonFont: UIFont = RobotoFont.regular(with: 18)

    // Mark: Database Reference
    private var auth: Auth!

    var animateFromRegister: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Variables
        defaultWidth = Constraints.screenWidth() - 2*defaultMargin

        self.view.backgroundColor = UIColor.loginBackground

        self.hideKeyboardWhenTappedAround()
        initializeUIElements()

        auth = Auth.auth()

        isMotionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if Auth.auth().currentUser != nil {
            self.navigationController?.pushViewController(MainViewController(), animated: false)
        } else {
            self.addObservers()
            if animateFromRegister {
                animateIconImageViewFromRegister()
                animateFromRegister = false
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
        iconImageView.frame = Constraints.RegisterViewController.getIconFrame()
        self.emailTextField.alpha = 0.0
        self.passwordTextField.alpha = 0.0
        self.loginButton.alpha = 0.0
        self.registerButton.alpha = 0.0
    }

    /**
        Initializes all UIElements for the view controller
    */
    private func initializeUIElements() {
        initializeStatusBarBackground()
        initializeScrollView()
        initializeIconImageView()
        animateIconImageViewFromSplashScreen()
        initializeEmailTextField()
        initializePasswordTextField()
        initializeLoginButton()
        initializeRegisterButton()
    }

    private func initializeStatusBarBackground() {
        statusBarBackground = UIView()
        statusBarBackground.frame = CGRect(x: 0, y: 0, width: Constraints.screenWidth(), height: Constraints.statusBarHeight())
        statusBarBackground.backgroundColor = UIColor.statusBarBackground
        self.view.addSubview(statusBarBackground)
    }

    private func initializeScrollView() {
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: Constraints.statusBarHeight(), width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - buttonHeight - Constraints.LoginViewController.getRegisterButtonYOffset() - 20)
        self.view.addSubview(scrollView)
    }

    private func initializeIconImageView() {
        iconImageView = UIImageView(image: Icons.SPLASH_SCREEN_ICON)
        let size = Constraints.LoginViewController.getIconSize()
        iconImageView.frame.origin = CGPoint(x: (self.view.frame.width - size.width)/2, y: ((self.view.frame.height - size.height)/2) - Constraints.statusBarHeight())
        iconImageView.frame.size = size
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.motionIdentifier = "v1"
        scrollView.addSubview(iconImageView)
    }

    private func initializeEmailTextField() {
        emailTextField = ErrorTextField()
        let y: CGFloat = iconImageView.frame.origin.y + iconImageView.frame.height + iconEmailTextFieldOffset
        emailTextField.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: textFieldHeight)
        emailTextField.placeholder = "Email/Username"
        emailTextField.detail = "Invalid email/username"
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
        scrollView.addSubview(emailTextField)
    }

    private func initializePasswordTextField() {
        passwordTextField = ErrorTextField()
        let y: CGFloat = emailTextField.frame.origin.y + emailTextField.frame.height + emailPasswordTextFieldOffset
        passwordTextField.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: textFieldHeight)
        passwordTextField.placeholder = "Password"
        passwordTextField.detail = "Invalid password"
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
        scrollView.addSubview(passwordTextField)
    }

    private func initializeLoginButton() {
        loginButton = UIButton()
        let y: CGFloat = passwordTextField.frame.origin.y + passwordTextField.frame.height + passwordLoginButtonOffset
        loginButton.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: buttonHeight)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.backgroundColor = UIColor.materialBlue
        loginButton.titleLabel?.font = buttonFont
        loginButton.addTarget(self, action: #selector(loginButtonAction(_:)), for: .touchUpInside)
        loginButton.alpha = 0.0
        scrollView.addSubview(loginButton)
    }

    private func initializeRegisterButton() {
        registerButton = UIButton()
        let y: CGFloat = self.view.frame.height - buttonHeight - Constraints.LoginViewController.getRegisterButtonYOffset()
        registerButton.frame = CGRect(x: defaultMargin, y: y, width: defaultWidth, height: buttonHeight)
        registerButton.setTitle("Don't have an account? Register", for: .normal)
        registerButton.backgroundColor = UIColor.clear
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.titleLabel?.font = buttonFont
        registerButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        registerButton.alpha = 0.0
        self.view.addSubview(registerButton)
    }

    /**
        Runs the animation for the icon when transitioning from splash screen, along with the rest of the UIElements
    */
    private func animateIconImageViewFromSplashScreen() {
        UIView.animate(withDuration: 0.5, animations: {
            self.iconImageView.frame = Constraints.LoginViewController.getIconFrame()
        }, completion: { finished in
            UIView.animate(withDuration: 0.15, animations: {
                self.emailTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
                self.loginButton.alpha = 1.0
                self.registerButton.alpha = 1.0
            })
        })
    }

    /**
        Runs the animation for the icon when transitioning from RegisterViewController, along with the rest of the uielements
     */
    private func animateIconImageViewFromRegister() {

        UIView.animate(withDuration: 0.5, animations: {
            self.iconImageView.frame = Constraints.LoginViewController.getIconFrame()
        }, completion: { finished in
            UIView.animate(withDuration: 0.15, animations: {
                self.emailTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
                self.loginButton.alpha = 1.0
                self.registerButton.alpha = 1.0
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
        // fix cursor placement
        let tempText = passwordTextField.text
        passwordTextField.text = " ";
        passwordTextField.text = tempText
    }

    /**
        Login button action. Checks if the entered email/username and password are valid and login.

        When the login button is clicked, this should check whether it is a username or email
        Error handle for invalid credentials and otherwise go to MainActivity
    */
    @objc private func loginButtonAction(_ sender: UIButton) {
        print("Inside logInButtonPressed")
        var emailOrUsername = getFormattedEmailOrUsername()
        let password = getFormattedPassword()
        if (!isEmailOrUsernameValid(email: emailOrUsername) || !isPasswordValid(password: password)) {
            return
        }
        // If input is username, extract email from database
        if (!isInputOfTypeEmail(emailOrUsername: emailOrUsername)) {
            let accountReference = Default.ACCOUNT_REFERENCE.child(emailOrUsername)
            accountReference.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    emailOrUsername = String(describing: snapshot.value!)
//                    print(emailOrUsername)
                    self.attemptLogin(email: emailOrUsername, password: password)
                } else {
                    print("Username does not exist")
                    self.displayEmailTextFieldError()
                }
            })
        } else {
            self.attemptLogin(email: emailOrUsername, password: password)
        }
    }

    /**
        Register button action. Segues to the RegisterViewController to create a new account.
    */
    @objc private func registerButtonAction(_ sender: UIButton) {
        print("registerButton pressed")
        let viewController = RegisterViewController()
        viewController.onDoneBlock = { result in
            print("RegisterViewController Dismissed")
            self.animateFromRegister = true
        }
        self.navigationController?.pushViewController(viewController, animated: false)

//        performSegue(withIdentifier: "LoginToRegisterVIewController", sender: nil)
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

    /**

     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationViewController = segue.destination as? RegisterViewController {
//            destinationViewController.onDoneBlock = { result in
//                print("view dismissed")
//                self.animateFromRegister = true
//            }
//        }
    }

    // MARK: Login Button Functions
    
    /**
     * Perform validation checks before attempting sign in
     */
    private func attemptLogin(email: String, password: String){
        print("Inside attemptLogin")
//        print(email)
//        print(password)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    print(error!)
                    switch errorCode {
                    case .wrongPassword:
                        self.displayPasswordTextFieldError()
                        self.hideEmailTextFieldError()
                    default:
                        self.displayEmailTextFieldError()
                        self.displayPasswordTextFieldError()
                    }
                }
                return
            }
            print("User logged in")
            self.showMainViewController()
        }
    }
    
    //    /**
    //     * Email/Username validation check
    //     */
    private func isEmailOrUsernameValid(email: String) -> Bool {
        let isValid = (isInputOfTypeEmail(emailOrUsername: email) || (email.count >= 5 && email.count <= 30))
        if (!isValid) {
            print("Invalid username/email")
        }
        return isValid
    }
    
    /**
     * Checks to see if what FirebaseUser typed in the username/email editText
     * is of type email or username. The purpose is that if the firebaseUser
     * enters an email, we can directly attemptLogin otherwise for username,
     * we have to go to the database and extract the email for the given
     * username
     * @param emailOrUsername text from the email/username editText
     * @return True if input is an email and False if it's a username
     */
    private func isInputOfTypeEmail(emailOrUsername: String) -> Bool{
        print("Inside isEmailValid")
        return (NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: emailOrUsername))
    }
    
    /**
     * Password validation check
     */
    private func isPasswordValid(password: String) -> Bool{
        print("Inside isPasswordValid")
        return (password.count > 5)
    }
    
    /**
     * Cleans the email or username entered and returns the clean version
     */
    private func getFormattedEmailOrUsername() -> String {
        return emailTextField.text!.trimmingCharacters(in: .whitespaces)
    }
    
    /**
     * Cleans the password entered and returns the clean version
     */
    private func getFormattedPassword() -> String {
        return passwordTextField.text!.trimmingCharacters(in: .whitespaces)
    }

    // MARK: Error Functions

    func displayEmailTextFieldError() {
        emailTextField.isErrorRevealed = true
        emailTextField.dividerNormalColor = Color.red.base
        emailTextField.dividerActiveColor = Color.red.base
    }

    func hideEmailTextFieldError() {
        emailTextField.isErrorRevealed = false
        emailTextField.dividerNormalColor = UIColor.white
        emailTextField.dividerActiveColor = UIColor.materialBlue
    }

    func displayPasswordTextFieldError() {
        passwordTextField.isErrorRevealed = true
        passwordTextField.dividerNormalColor = Color.red.base
        passwordTextField.dividerActiveColor = Color.red.base
    }

    func hidePasswordTextFieldError() {
        passwordTextField.isErrorRevealed = false
        passwordTextField.dividerNormalColor = UIColor.white
        passwordTextField.dividerActiveColor = UIColor.materialBlue
    }

    func showMainViewController() {
        let viewController = MainViewController()
        viewController.onDoneBlock = { result in
            self.animateFromRegister = true
        }
        self.navigationController?.pushViewController(viewController, animated: false)
//        present(viewController, animated: false, completion: nil)
    }
}


// MARK: ScrollView Functions for Keyboard
extension LoginViewController {
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

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 30, right: 0)
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
extension LoginViewController: TextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: View Tap Gesture
extension LoginViewController {
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
        If tapped anywhere else except for the textField, keyboard is dismissed.
    */
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.scrollView)
        if !isTapInPasswordVisibleIconArea(point: point) {
            self.view.endEditing(true)
        }
    }
}
