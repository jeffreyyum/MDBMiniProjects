//
//  FilterVC.swift
//  Pokedex
//
//  Created by Jeffrey Yum on 3/15/22.
//

import UIKit

class FilterVC: UIViewController {
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    var selectedTypes: [PokeType] = []
    var resultPokemon: [Pokemon] = []
    
    //used for filtering later
    var add :Bool = true
    
    let possible_types: [PokeType] = [.Bug, .Grass, .Dark, .Ground, .Dragon, .Ice, .Electric, .Normal, .Fairy, .Poison, .Fighting, .Psychic, .Fire, .Rock, .Flying, .Steel, .Ghost, .Water, .Unknown]
    var buttons: [UIButton] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = " Pokemon Types "
        label.textAlignment = .center
        label.textColor = UIColor(red: 0, green: 100, blue: 60, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Filter by Types ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Return ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        for index in 0...(possible_types.count - 2) {
            let type = possible_types[index]
            let eachType: UIButton = {
                let button = UIButton()
                button.setTitle(" \(type.rawValue) ", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 10
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            buttons.append(eachType)
            eachType.tag = index
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func typeButtonConst() {
        for button in buttons[0..<buttons.count/2] {
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/25*CGFloat(button.tag*2+5)),
                button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/4),
                button.widthAnchor.constraint(equalToConstant: view.bounds.width/5)
            ])
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
        
        for button in buttons[buttons.count/2+1..<buttons.count] {
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/25*CGFloat((button.tag-buttons.count/2)*2+3)),
                button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/4*3),
                button.widthAnchor.constraint(equalToConstant: view.bounds.width/5)
            ])
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }
    
    func allOtherConst() {
        view.addSubview(returnButton)
        view.addSubview(filterButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*18.5),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*18.5),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        filterButton.addTarget(self, action: #selector(tappedFilter(_:)), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        typeButtonConst()
        allOtherConst()
    }
    
    
    @objc func didTapReturn(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        if selectedTypes.contains(possible_types[sender.tag]) {
            buttons[sender.tag].backgroundColor = .lightGray
            selectedTypes = selectedTypes.filter(){$0 != possible_types[sender.tag]}
        } else {
            buttons[sender.tag].backgroundColor = .systemGreen
            selectedTypes.append(possible_types[sender.tag])
        }
    }
    
    @objc func tappedFilter(_ sender: UIButton) {
        let vc = PokedexVC()
        for pokemon in pokemons {
            add = true
            for st in selectedTypes {
                if !pokemon.types.contains(st) {
                    add = false
                }
            }
            if add {
                resultPokemon.append(pokemon)
            }
        }
        vc.filterShowing = true
        vc.currPokemons = resultPokemon
        vc.collectionView.reloadData()
        vc.modalPresentationStyle = .fullScreen
        
        //need to use present or else view will not reload as intended
        present(vc, animated: true, completion: nil)
    }
}
