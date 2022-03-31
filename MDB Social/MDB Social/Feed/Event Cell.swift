//
//  Event Cell.swift
//  MDB Social
//
//  Created by Jeffrey Yum on 3/30/22.
//

import Foundation
import UIKit
import Firebase


class EventCell: UICollectionViewCell {
     
    static let reuseIdentifier: String = String(describing: EventCell.self)
    
    private var rsvps: [String] = []
    
    let storage = Storage.storage();
    
    var symbol: Event? {
        didSet {
            let imageRef: StorageReference = storage.reference(forURL: symbol!.photoURL)
                imageRef.getData(maxSize: 1000 * 1000) { data, error in
                    if let error = error {
                        print("Error: \(error)")
                      } else {
                        self.imageView.image = UIImage(data: data!)
                      }
                }
                
            nameView.text = " \(symbol?.name ?? "") "
            rsvpView.text = "\(symbol?.rsvpUsers.count ?? 0) interested"
            if symbol?.rsvpUsers.count ?? 0 < 3 {
                rsvpView.textColor = .systemRed
                nameView.layer.borderColor = UIColor.systemRed.cgColor
            } else {
                rsvpView.textColor = .systemGreen
                nameView.layer.borderColor = UIColor.systemGreen.cgColor
            }
            
            let authorRef = DatabaseRequest.shared.db.collection("users").document(symbol!.creator)
                authorRef.getDocument(completion: { (querySnapshot, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        guard let user = try? querySnapshot?.data(as: User.self) else { return }
                        self.authorView.text = user.fullname
                    }
                })
        }
    }
    private let imageView: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        
        private let nameView: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .black
            lbl.font = .systemFont(ofSize: 22, weight: .bold)
            lbl.layer.borderWidth = 1
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        private let authorView: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .black
            lbl.font = .systemFont(ofSize: 12, weight: .medium)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        private let rsvpView: UILabel = {
            let lbl = UILabel()
            lbl.font = .systemFont(ofSize: 12, weight: .medium)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.black.cgColor
            
            setConstraints()
        }
    
    func setConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(authorView)
        contentView.addSubview(nameView)
        contentView.addSubview(rsvpView)
                
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            
            nameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            authorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            authorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            rsvpView.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: 10),
            rsvpView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
