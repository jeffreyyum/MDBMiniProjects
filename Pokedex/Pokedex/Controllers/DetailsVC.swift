//
//  DetailsVC.swift
//  Pokedex
//
//  Created by Jeffrey Yum on 3/15/22.
//

import UIKit

class DetailsVC: UIViewController {
    
    let pokemon: Pokemon?
    init(data: Pokemon) {
        self.pokemon = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 35)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let detailsLbl: [UILabel] = {
        return (0...7).map { index in
            let detailLbl = UILabel()
            
            detailLbl.tag = index
            detailLbl.textColor = .systemBlue
            detailLbl.backgroundColor = .white
            detailLbl.textAlignment = .center
            detailLbl.font = .systemFont(ofSize: 22)
            detailLbl.translatesAutoresizingMaskIntoConstraints = false
            
            return detailLbl
        }
        
    }()
    
    let bigImg: UIImageView = {
        let bigImg = UIImageView()
        bigImg.contentMode = .scaleAspectFit
        bigImg.translatesAutoresizingMaskIntoConstraints = false
        return bigImg
    }()
    
    private let mainVS: UIStackView = {
        let sv = UIStackView()
        
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 25
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    let returnButton: UIButton = {
        let returnButton = UIButton()
        
        returnButton.setTitle("Return", for: .normal)
        returnButton.setTitleColor(.white, for: .normal)
        returnButton.backgroundColor = .systemGreen
        returnButton.layer.cornerRadius = 10
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        
        return returnButton
    }()
    
    //setting all constraints
    func setElementConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(bigImg)
        view.addSubview(mainVS)
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            
            mainVS.topAnchor.constraint(equalTo: bigImg.bottomAnchor, constant: 10),
            mainVS.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainVS.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 665),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            bigImg.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bigImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bigImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

        ])
    }
    
    
    //showing pokemon image setup
    func setPokeImage() {
        let url1 = pokemon!.imageUrl
        let stringUrl = url1?.absoluteString
        
        if stringUrl != nil {
            if let url: URL = URL(string: (stringUrl)!) {
                if let data = try? Data(contentsOf: url) {
                        bigImg.image = UIImage(data: data)
                }
            }
        }
    }
    
    
    //setting all detail labels' text
    func setDetails() {
        detailsLbl[0].text = "Attack: \(pokemon!.attack)"
        detailsLbl[1].text = "Defense: \(pokemon!.defense)"
        detailsLbl[2].text = "Health: \(pokemon!.health)"
        detailsLbl[3].text = "Special Attack: \(pokemon!.specialAttack)"
        detailsLbl[4].text = "Special Defense: \(pokemon!.specialDefense)"
        detailsLbl[5].text = "Speed: \(pokemon!.speed)"
        detailsLbl[6].text = "Total: \(pokemon!.total)"
        var multipleTypes: String = ""
        var notOne = false
        for type in (pokemon!.types) {
            if notOne {
                multipleTypes += " & \(type)"
            } else{
                multipleTypes += " \(type)"
                notOne = true
            }
        }
        detailsLbl[7].text = "Types: \(multipleTypes)"
        multipleTypes = ""
        notOne = false
        for i in 0..<8 {
            mainVS.addArrangedSubview(detailsLbl[i])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleLabel.text = pokemon!.name + " Info"
        
        setPokeImage()
        setDetails()
        setElementConstraints()
    }
    
    @objc func didTapReturn(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
