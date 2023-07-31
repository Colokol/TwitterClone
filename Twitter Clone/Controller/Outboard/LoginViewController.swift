    //
    //  LoginViewController.swift
    //  Twitter Clone
    //
    //  Created by Uladzislau Yatskevich on 19.07.23.
    //

import UIKit
import Combine

class LoginViewController: UIViewController {

    private var viewModel = AuthenticationViewViewModel()
    private var subscriprions: Set<AnyCancellable> = []

    private let loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login in your account"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Entry you email", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.gray
        ])
        textField.layer.cornerRadius = 10
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Entry you password", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.gray
        ])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numbersAndPunctuation
        textField.backgroundColor = .secondarySystemBackground
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(loginTitleLabel)

        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)

        setConstraints()
        bindView()
    }

    @objc func emailTextFieldChanged() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }

    @objc func passwordTextFieldChanged() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }

    private func bindView() {
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        viewModel.$isAuthenticationFormValid
            .sink(receiveValue: { [weak self] active in
                self?.loginButton.isEnabled = active
            })
            .store(in: &subscriprions)

        viewModel.$user
            .sink(receiveValue: { [weak self] user in
                guard user != nil else {return}
                guard let vc = self?.navigationController?.viewControllers.first as? PresentViewController else {return}
                vc.dismiss(animated: true)
            })
            .store(in: &subscriprions)

        viewModel.$error
            .sink { [weak self] errorString in
                guard let error = errorString else {return}
                self?.presentError(with: error)
            }
            .store(in: &subscriprions)
    }

    @objc func loginDidTap() {
        viewModel.loginUser()
    }

    private func presentError(with error: String) {
                let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel)
                alertVC.addAction(alertAction)
                present(alertVC, animated: true)
    }


    func setConstraints(){
        NSLayoutConstraint.activate([
            loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 50),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            loginButton.heightAnchor.constraint(equalToConstant: 60)


        ])

    }

}
