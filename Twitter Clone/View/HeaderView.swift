    //
    //  HeaderView.swift
    //  Twitter Clone
    //
    //  Created by Uladzislau Yatskevich on 10.07.23.
    //

import UIKit

class HeaderView: UIView {

    private enum SectionsTabs: String {
        case tweets = "Tweets"
        case tweetsAndReply = "Tweets & Replice"
        case media = "Media"
        case likes = "Likes"


        var index:Int {
            switch self {
                case .tweets:
                    return 0
                case .tweetsAndReply:
                    return 1
                case .media:
                    return 2
                case .likes:
                    return 3
            }
        }
    }

    private var sectionNumber = 0 {
        didSet{
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
                    self?.stackButton.arrangedSubviews[i].tintColor = i == self?.sectionNumber ? .label : .secondaryLabel
                    self?.leadingAnchorIndicator[i].isActive = i == self?.sectionNumber ? true : false
                    self?.trailingAnchorIndicator[i].isActive = i == self?.sectionNumber ? true : false
                    self?.layoutIfNeeded()
                }
            }
        }
    }

    private var leadingAnchorIndicator: [NSLayoutConstraint] = []
    private var trailingAnchorIndicator: [NSLayoutConstraint] = []


    private lazy var stackButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private var tabs: [UIButton] =  ["Tweets","Tweets & Replice", "Media", "Likes"].map { buttonTitle in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonTitle, for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }


    private let backgroundImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = true
        return image
    }()

    private let profileAvatarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profile")
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.backgroundColor = .green
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let displayNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let userNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()

    private let userBioLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let joinDataLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()

    private let joinDataImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "calendar")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let followersLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "Followers"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let followersCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "231"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let followingsLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "Following"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let followingsCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "1M"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backgroundImageView)
        addSubview(profileAvatarImageView)
        addSubview(joinDataImageView)
        addSubview(displayNameLabel)
        addSubview(userNameLabel)
        addSubview(userBioLabel)
        addSubview(joinDataLabel)
        addSubview(followersLabel)
        addSubview(followersCountLabel)
        addSubview(followingsLabel)
        addSubview(followingsCountLabel)
        addSubview(stackButton)
        addSubview(indicatorView)

        setConstraints()
        configureStackButton()

        displayNameLabel.text = "Vlad"
        userNameLabel.text = "@colokol"
        joinDataLabel.text = "10.08.1995"
        userBioLabel.text = "Ios developer"
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureStackButton() {
        for (i,button) in stackButton.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else {return}
            button.addTarget(self, action: #selector(tabsDidTap(_:)), for: .touchUpInside)
            if i == sectionNumber {
                button.tintColor = .label
            }else {
                button.tintColor = .secondaryLabel
            }


        }
    }

    @objc func tabsDidTap(_ sender:UIButton){
        guard let label = sender.titleLabel?.text else {return}
        switch label{
            case SectionsTabs.tweets.rawValue :
                sectionNumber = SectionsTabs.tweets.index
            case SectionsTabs.tweetsAndReply.rawValue :
                sectionNumber = SectionsTabs.tweetsAndReply.index
            case SectionsTabs.media.rawValue:
                sectionNumber = SectionsTabs.media.index
            case SectionsTabs.likes.rawValue :
                sectionNumber = SectionsTabs.likes.index
            default:
                sectionNumber = 0
        }

    }

    func setConstraints() {

        for i in 0..<tabs.count {
            let leadingIndicator = indicatorView.leadingAnchor.constraint(equalTo: stackButton.arrangedSubviews[i].leadingAnchor)
            leadingAnchorIndicator.append(leadingIndicator)
            let trailingIndicator = indicatorView.trailingAnchor.constraint(equalTo:             stackButton.arrangedSubviews[i].trailingAnchor)
            trailingAnchorIndicator.append(trailingIndicator)
        }

        NSLayoutConstraint.activate([
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 60),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 60),

            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 5),

            userNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5),

            userBioLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            userBioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),

            joinDataImageView.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            joinDataImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor, constant: 5),

            joinDataLabel.leadingAnchor.constraint(equalTo: joinDataImageView.trailingAnchor , constant: 5),
            joinDataLabel.centerYAnchor.constraint(equalTo: joinDataImageView.centerYAnchor),

            followersCountLabel.leadingAnchor.constraint(equalTo: userBioLabel.leadingAnchor),
            followersCountLabel.topAnchor.constraint(equalTo: joinDataImageView.bottomAnchor, constant: 5),

            followersLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 5),
            followersLabel.topAnchor.constraint(equalTo: followersCountLabel.topAnchor),

            followingsCountLabel.leadingAnchor.constraint(equalTo: followersLabel.trailingAnchor, constant: 15),
            followingsCountLabel.topAnchor.constraint(equalTo: followersCountLabel.topAnchor),

            followingsLabel.leadingAnchor.constraint(equalTo: followingsCountLabel.trailingAnchor, constant: 5),
            followingsLabel.topAnchor.constraint(equalTo: followersCountLabel.topAnchor),

            stackButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 25),
            stackButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            stackButton.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 10),
            stackButton.heightAnchor.constraint(equalToConstant: 30),

            indicatorView.topAnchor.constraint(equalTo: stackButton.bottomAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            leadingAnchorIndicator[0],
            trailingAnchorIndicator[0]

        ])
    }

}


