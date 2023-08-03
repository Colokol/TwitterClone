//
//  AddTweetViewController.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 3.08.23.
//

import UIKit
import Combine

class AddTweetViewController: UIViewController {

    private let viewModel = AddTweetsViewViewModel()
    var subscriptions: Set<AnyCancellable> = []

    private let tweetTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()

    private let publishTweetButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
            button.layer.cornerRadius = 40
            button.clipsToBounds = true
            button.layer.masksToBounds = true
            button.tintColor = .white
            button.backgroundColor = .systemBlue
            button.translatesAutoresizingMaskIntoConstraints = false
            button.alpha = 0.85
            return button
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tweetTextView.delegate = self

        view.addSubview(tweetTextView)
        view.addSubview(publishTweetButton)

        publishTweetButton.addTarget(self, action: #selector(publishTweetButtonDidTap), for: .touchUpInside)

        setConstraints()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tweetTextView.frame = view.bounds
    }

    func bindView() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getUserData()
    }



    @objc func publishTweetButtonDidTap(){
        viewModel.addTweet()
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            publishTweetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            publishTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            publishTweetButton.heightAnchor.constraint(equalToConstant: 80),
            publishTweetButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }


}


extension AddTweetViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        viewModel.textTweet = textView.text
    }

}
