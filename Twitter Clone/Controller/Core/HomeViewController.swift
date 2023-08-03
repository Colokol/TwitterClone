//
//  HomeViewController.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 9.07.23.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {

    private var viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private var tweetsArray: [Tweet] = []

    private let timeLineTableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identificator)
        return table
    }()

    private let addTweetButton :UIButton = {
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

        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self

        addTweetButton.addTarget(self, action: #selector(addTweetButtonDidTap), for: .touchUpInside)

        view.addSubview(timeLineTableView)
        view.addSubview(addTweetButton)

        configureNavigationBar()
        setConstraints()
        bindView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timeLineTableView.frame = view.bounds
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            addTweetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTweetButton.heightAnchor.constraint(equalToConstant: 80),
            addTweetButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    @objc func addTweetButtonDidTap() {
        let vc = AddTweetViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: false)
    }

    func configureNavigationBar() {
        let size: CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size) )
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "logo")

        let midleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        midleView.addSubview(logoImageView)
        navigationItem.titleView = midleView

        let profileImage = UIImage(named: "profile")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(profileDidTap))

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "door.left.hand.open"), style: .plain, target: self, action: #selector(logOutDidTap))

    }

    private func createuserProfile(){
        let vc = ProfileDataFormViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func bindView(){
        viewModel.$twitterUser
            .sink { [weak self] user in
                guard let user = user else { return}
                if user.isFirstEntry == true {
                    self?.createuserProfile()
                }
            }
            .store(in: &subscriptions)

        viewModel.$tweetsArray
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.timeLineTableView.reloadData()
                }
            }
            .store(in: &subscriptions)
    }


    private func checkAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: PresentViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        checkAuthentication()
        viewModel.retrieveUser()
        viewModel.retrievTweets()
    }

    @objc func profileDidTap() {
        DispatchQueue.main.async {
            let vc = ProfileViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    @objc func logOutDidTap() {
        try? Auth.auth().signOut()
        checkAuthentication()
    }

}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tweetsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identificator) as? TweetTableViewCell else { return UITableViewCell()}
        cell.configureTweets(tweet: viewModel.tweetsArray[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }


}


extension HomeViewController: TweetTableViewCellDelegate {
    func replyBottonDidTap() {
        print("Reply")
    }

    func retweetBottonDidTap() {
        print("Retweet")
    }

    func likeBottonDidTap() {
        print("Like")
    }

    func shareBottonDidTap() {
        print("Share")
    }

}
