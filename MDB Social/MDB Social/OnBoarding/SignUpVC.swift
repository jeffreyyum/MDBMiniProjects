//
//  SignUpVC.swift
//  MDB Social
//
//  Created by Jeffrey Yum on 3/30/22.
//

import Foundation
import UIKit
import NotificationBannerSwift

private let contentEdge = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    
private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)

class SignUpVC: UIViewController {
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.font = .systemFont(ofSize: 25, weight: .medium)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let sv: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let nameTF: AuthTextField = {
        let tf = AuthTextField(title: "Name (First + Last):")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let emailTF: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let usernameTF: AuthTextField = {
        let tf = AuthTextField(title: "Username:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passwordTF: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordCheckTF: AuthTextField = {
        let tf = AuthTextField(title: "Reenter Pasword:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let signUpButton: LoadingButton = {
        let b = LoadingButton()
        b.setTitle("Sign Up", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        b.isUserInteractionEnabled = true
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.black.cgColor
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    func viewAndStackConstraints() {
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        view.addSubview(sv)
        view.addSubview(signUpButton)
        
        sv.addArrangedSubview(nameTF)
        sv.addArrangedSubview(emailTF)
        sv.addArrangedSubview(usernameTF)
        sv.addArrangedSubview(passwordTF)
        sv.addArrangedSubview(passwordCheckTF)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdge.top + 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdge.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdge.left),
            
            sv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdge.left),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdge.left),
            sv.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            
            signUpButton.leadingAnchor.constraint(equalTo: sv.leadingAnchor),
            signUpButton.topAnchor.constraint(equalTo: sv.bottomAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: sv.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAndStackConstraints()
        signUpButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    
    
    @objc func didTapSignUp(_ sender: UIButton) {
        guard let name = nameTF.text, name != "" else {
            showErrorBanner(withTitle: "Missing full name", subtitle: "Please provide a full name")
            return
        }
        
        guard let email = emailTF.text, email != "" else {
            showErrorBanner(withTitle: "Missing email", subtitle: "Please provide an email")
            return
        }
        
        guard let username = usernameTF.text, username != "" else {
            showErrorBanner(withTitle: "Missing username", subtitle: "Please provide a username")
            return
        }
        
        guard let password = passwordTF.text, password != "" else {
            showErrorBanner(withTitle: "Missing password", subtitle: "Please provide a password")
            return
        }
        
        guard let password = passwordTF.text, password.count > 7 else {
            showErrorBanner(withTitle: "Weak Password", subtitle: "Password needs more than 6 characters")
            return
        }
        
        guard let password = passwordCheckTF.text, password == passwordTF.text else {
            showErrorBanner(withTitle: "Passwords do not match", subtitle: "Please check passwords")
            return
        }
        
        signUpButton.showLoading()
        
        AuthManager.shared.signUp(withName: name, withEmail: email, withUsername: username, withPassword: password) { [weak self] result in
            guard let self = self else { return }
            
            defer {
                self.signUpButton.hideLoading()
            }
            
            switch result {
            case .success:
                guard let window = self.view.window else { return }
                window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.3
                UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
//                let vc = FeedVC()
//                self.present(vc, animated: true, completion: nil)
            case .failure(let error):
                self.showErrorBanner(withTitle: error.localizedDescription)
            }
        }
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        showBanner(withStyle: .warning, title: title, subtitle: subtitle)
    }
    
    private func showBanner(withStyle style: BannerStyle, title: String, subtitle: String?) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: .systemFont(ofSize: 14, weight: .regular),
                                                style: style)
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                    cornerRadius: 20,
                    shadowColor: .black,
                    shadowOpacity: 0.5,
                    shadowBlurRadius: 15)
    }
}
