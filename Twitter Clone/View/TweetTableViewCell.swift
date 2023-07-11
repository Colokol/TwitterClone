//
//  TweetTableViewCell.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 9.07.23.
//

import UIKit

protocol TweetTableViewCellDelegate {
    func replyBottonDidTap()
    func retweetBottonDidTap()
    func likeBottonDidTap()
    func shareBottonDidTap()
}

class TweetTableViewCell: UITableViewCell {

    static let identificator = "TweetTableViewCell"

    private let actionSpacing: CGFloat = 40

    var delegate: TweetTableViewCellDelegate?

    private let avatarImage: UIImageView = {
        let image = UIImageView(frame:CGRect(x: 0, y: 0, width: 60, height: 60))
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 30
        image.backgroundColor = .red
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let nameLabel  :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let nickNameLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textColor = .label
        label.alpha = 0.5
        return label
    }()

    private let messageLabel  :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "reply"), for: .normal)
        button.tintColor = .label
        return button
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .label
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .label
        return button
    }()

    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .label
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        avatarImage.image = UIImage(named: "Image")
        nameLabel.text = "Vladislav Green"
        messageLabel.text = "Priver mir i herePriver mir i herePriver mir i herePriver mir i herePriver mir i herePriver mir i herePriver mir i i herePriver mir i herePriver mir i herePriver mir i herePriver mir i herePriver mir i herePriver mir i "
        nickNameLabel.text = "@Colokol"

        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)

        setConstraints()
        configureButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureButton() {
        replyButton.addTarget(self, action: #selector(replyDidTap), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(retweetDidTap), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
    }

    @objc func replyDidTap(){
        delegate?.replyBottonDidTap()
    }

    @objc func retweetDidTap(){
        delegate?.retweetBottonDidTap()
    }

    @objc func likeDidTap(){
        delegate?.likeBottonDidTap()
    }

    @objc func shareDidTap(){
        delegate?.shareBottonDidTap()
    }


    func setConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            avatarImage.heightAnchor.constraint(equalToConstant: 60),
            avatarImage.widthAnchor.constraint(equalToConstant: 60),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 15),

            nickNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 15),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            replyButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            replyButton.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),

            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),

            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),

            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),

        ])
    }

}
