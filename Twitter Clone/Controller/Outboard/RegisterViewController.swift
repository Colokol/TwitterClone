    //
    //  RegisterViewController.swift
    //  Twitter Clone
    //
    //  Created by Uladzislau Yatskevich on 19.07.23.
    //

import UIKit
import Combine

class RegisterViewController: UIViewController {

    var viewModel = AuthenticationViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []

    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
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
        textField.attributedPlaceholder = NSAttributedString(string: "   Entry you email", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.gray
        ])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "   Entry you password", attributes: [
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

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle("Create account", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(registerTitleLabel)

        registerButton.addTarget(self, action: #selector(registerDidtap), for: .touchUpInside)

        setConstraints()
        bindView()
    }

    @objc func registerDidtap() {
        viewModel.createUser()
    }

    @objc func didChangeEmailTextField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()

    }

    @objc func didChangePasswordTextField() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()


    }

    func bindView() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordTextField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink { valid in
            self.registerButton.isEnabled = valid
        }
        .store(in: &subscriptions)

        viewModel.$user
            .sink(receiveValue: { [weak self] user in
                guard user != nil else {return}
                guard let vc = self?.navigationController?.viewControllers.first as? PresentViewController else {return}
                vc.dismiss(animated: true)
            })
            .store(in: &subscriptions)

        viewModel.$error
            .sink { [weak self] errorString in
                guard let error = errorString else {return}
                self?.presentError(with: error)
            }
            .store(in: &subscriptions)

    }

    private func presentError(with error: String) {
        let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }

    func setConstraints(){
        NSLayoutConstraint.activate([
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 50),
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

            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            registerButton.heightAnchor.constraint(equalToConstant: 60)

        ])

    }

}
