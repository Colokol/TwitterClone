    //
    //  ProfileDataFormViewController.swift
    //  Twitter Clone
    //
    //  Created by Uladzislau Yatskevich on 26.07.23.
    //

import UIKit
import PhotosUI
import Combine
import FirebaseAuth

class ProfileDataFormViewController: UIViewController {

    var viewModel = ProfileDataFormViewModel()
    var subscriptions: Set<AnyCancellable> = []

    private var scrollView: UIScrollView = {
        let scrolView = UIScrollView()
        scrolView.alwaysBounceVertical = true
        scrolView.keyboardDismissMode = .onDrag
        scrolView.translatesAutoresizingMaskIntoConstraints = false
        return scrolView
    }()

    private var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Fill in your data"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "photo.circle")
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var userNameTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Entry your username"
        textField.font = .systemFont(ofSize: 18)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor(.gray)])
        return textField
    }()

    private var displayNameTextField:UITextField = {
        let textField = UITextField()
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 18)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Display name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(.gray)])
        return textField
    }()

    private var bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 18)
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Tell all world about yourself"
        textView.textColor = .gray
        return textView
    }()

    private var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)

        bioTextView.delegate = self
        userNameTextField.delegate = self
        displayNameTextField.delegate = self

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTap)))
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarDidTap)))

        view.addSubview(scrollView)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarImageView)
        scrollView.addSubview(userNameTextField)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(submitButton)
        scrollView.addSubview(bioTextView)

        bindView()
        setConstraints()
    }

    func bindView() {
        userNameTextField.addTarget(self, action: #selector(userNameTextFieldEditing), for: .editingChanged)
        displayNameTextField.addTarget(self, action: #selector(displayNameTextFieldEditing), for: .editingChanged)

        viewModel.$isAuthenticationFormValid
            .sink { [weak self] status in
                self?.submitButton.isEnabled = status
            }
            .store(in: &subscriptions)
    }

    @objc func submitButtonDidTap() {
        viewModel.setData()
        self.dismiss(animated: true)    }

    @objc func userNameTextFieldEditing() {
        viewModel.username = userNameTextField.text
        viewModel.vereficationName()
    }

    @objc func displayNameTextFieldEditing() {
        viewModel.displayName = displayNameTextField.text
        viewModel.vereficationName()
    }

    @objc func dismissTap() {
        view.endEditing(true)
    }

    @objc func avatarDidTap() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            avatarImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30),
            avatarImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),

            userNameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 45),

            displayNameTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            displayNameTextField.leadingAnchor.constraint(equalTo:userNameTextField.leadingAnchor),
            displayNameTextField.trailingAnchor.constraint(equalTo:userNameTextField.trailingAnchor),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 45),

            bioTextView.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            bioTextView.leadingAnchor.constraint(equalTo: userNameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: userNameTextField.trailingAnchor),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),

            submitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            submitButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }

}


    //MARK: Text Extension

extension ProfileDataFormViewController: UITextViewDelegate, UITextFieldDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                let image = image as? UIImage
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                    self.viewModel.imageData = image
                    self.viewModel.uploadAvatar()
                }
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.contentOffset = CGPoint(x: 0, y: textView.frame.origin.y - 160)
        if bioTextView.textColor == .gray {
            bioTextView.textColor = .black
            bioTextView.text = ""
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.userBio = textView.text
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)

        if bioTextView.text.isEmpty {
            bioTextView.text = "Tell all world about yourself"
            bioTextView.textColor = .gray
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.contentOffset = CGPoint(x: 0, y: textField.frame.origin.y - 160)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }



}
