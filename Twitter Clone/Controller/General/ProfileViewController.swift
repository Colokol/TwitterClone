//
//  ProfileViewController.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 10.07.23.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {

    private var viewModel = ProfileDataFormViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private var statusBarIsHiden = true

    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    private let tweetTableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identificator)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self

        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tweetTableView.frame.width, height: 350))
        tweetTableView.tableHeaderView = headerView
        tweetTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true

        view.addSubview(tweetTableView)
        view.addSubview(statusBar)

        setConstraints()
    }
    

    func setConstraints() {
        NSLayoutConstraint.activate([
            tweetTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tweetTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tweetTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tweetTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.frame.height > 800 ? 40 : 20)

        ])
    }

}


//MARK:  TableView Delegate

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identificator, for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition > 120 && statusBarIsHiden {
            statusBarIsHiden = false
            UIView.animate(withDuration: 0.3) {
                self.statusBar.alpha = 1
            }
        }else if yPosition < 120 && !statusBarIsHiden {
            statusBarIsHiden = true
            UIView.animate(withDuration: 0.3) {
                self.statusBar.alpha = 0
            }
        }
    }


}


//MARK: Tweet Delegate
extension ProfileViewController: TweetTableViewCellDelegate {
    func replyBottonDidTap() {
        print("Reply")
    }

    func retweetBottonDidTap() {
        print("retweet")

    }

    func likeBottonDidTap() {
        print("Like")

    }

    func shareBottonDidTap() {
        print("Share")

    }

}
