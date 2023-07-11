//
//  HomeViewController.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 9.07.23.
//

import UIKit

class HomeViewController: UIViewController {

    private let timeLineTableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identificator)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self

        view.addSubview(timeLineTableView)

        configureNavigationBar()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timeLineTableView.frame = view.bounds
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

    }

    @objc func profileDidTap() {
        DispatchQueue.main.async {
            let vc = ProfileViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        11
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identificator) as? TweetTableViewCell else { return UITableViewCell()}
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
