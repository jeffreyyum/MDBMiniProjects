//
//  PokedexCell.swift
//  Pokedex
//
//  Created by Jeffrey Yum on 3/8/22.
//

import Foundation
import UIKit


class PokedexCell: UICollectionViewCell {
     
    static let reuseIdentifier: String = String(describing: PokedexCell.self)
    
    var symbol: Pokemon? {
        didSet {
            let completion: (UIImage) -> Void = { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.global(qos: .utility).async { [self] in
            guard let url = symbol?.imageUrl else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            completion(UIImage(data: data)!)
            }
            
            let name: String = symbol?.name ?? ""
            let id: Int = symbol?.id ?? 0
            
            titleView.text = name
            idView.text = "#\(id)"
        }
    }
    
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()
    
    
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)
        contentView.addSubview(idView)
        
        NSLayoutConstraint.activate([
            
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: idView.topAnchor),
            
            idView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            idView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            idView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
