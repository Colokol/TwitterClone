//
//  PresentViewController.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 19.07.23.
//

import UIKit

class PresentViewController: UIViewController {

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue
        button.setTitle("Login", for: .normal)
        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.tintColor = .white
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "See what's happening in the world right now"
        label.textColor = .label
        label.font = .systemFont(ofSize: 30,weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    let promtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account?"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(textLabel)
        view.addSubview(promtLabel)

        setConstraints()
        configureButton()
    }

    func configureButton() {
        signUpButton.addTarget(self, action: #selector(signUpButtonTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)

    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            signUpButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.25),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),

            promtLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            promtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loginButton.leadingAnchor.constraint(equalTo: promtLabel.trailingAnchor, constant: 10),
            loginButton.centerYAnchor.constraint(equalTo: promtLabel.centerYAnchor)

        ])

    }

    @objc func loginButtonTap() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func signUpButtonTap() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
