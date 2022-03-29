//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController, UICollectionViewDelegate {

    var filterShowing: Bool = false
    var gridOrNot: Bool = false
    var searchBar: UISearchBar!
    
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    let types: [String] = ["Bug", "Grass","Dark","Ground", "Dragon", "Electric", "Normal", "Fairy", "Poison", "Fighting", "Psychic", "Fire", "Rock", "Flying", "Steel","Ghost","Water","Unknown"]
    var currTypes: [String]?
    var currSelected: String = ""
    var currPokemons = PokemonGenerator.shared.getPokemonArray()

    var permPokemons: [Pokemon]?
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Filter ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let returnFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Return ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // spacing between cells
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 30
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // register will create new cell if none in queue
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: PokedexCell.reuseIdentifier)
        return collectionView
    }()
    
    let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "POKÉDEX"
            label.textAlignment = .center
            label.textColor = UIColor(red: 0, green: 100, blue: 60, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 35)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    func titleAndFilterConst() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }
    
    func searchLabelConst() {
        searchBar = UISearchBar.init(frame: .zero)
//        searchBar.setShowsCancelButton(true, animated: false)
        searchBar.delegate = self
        searchBar.frame = CGRect.init(x: view.bounds.width/10, y: view.safeAreaInsets.top + 135, width: view.bounds.width * 0.8, height: 30)
        searchBar.placeholder = "Search for a pokemon..."
        //set to true later? might not need scope bar
        searchBar.showsScopeBar = false
        permPokemons = currPokemons
        view.addSubview(searchBar)
    }
    
    let toggleView: UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(systemName: "squareshape.split.2x2"), for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 10.0
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .medium), forImageIn: .normal)
            button.imageView?.tintColor = .black
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    func toggleViewConst() {
        
        toggleView.addTarget(self, action: #selector(tapToggleHandler(_:)), for: .touchUpInside)
        
        view.addSubview(toggleView)
        toggleView.imageView?.tintColor = .black
        
        NSLayoutConstraint.activate([
            toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            toggleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toggleView.widthAnchor.constraint(equalTo: toggleView.heightAnchor, constant: 10)
        ])
    }
    
    func filterSetup() {
        if !filterShowing {
            view.addSubview(filterButton)
            NSLayoutConstraint.activate([
                filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ])
            }
            
        if filterShowing {
            view.addSubview(returnFilterButton)
            NSLayoutConstraint.activate([
                returnFilterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                returnFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ])
        }
        
        if !filterShowing {
            filterButton.addTarget(self, action: #selector(tappedFilter(_:)), for: .touchUpInside)

        }
        
        if filterShowing {
            returnFilterButton.addTarget(self, action: #selector(tappedFilterReturn(_:)), for: .touchUpInside)
        }
    }
    
    @objc func tappedFilter(_ sender: UIButton) {
        let vc = FilterVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func tappedFilterReturn(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
   }
    
    @objc func tapToggleHandler(_ sender: UIButton) {
        if gridOrNot {
            gridOrNot = false
            toggleView.imageView?.tintColor = .black
            toggleView.backgroundColor = .clear
            
        } else {
            gridOrNot = true
            toggleView.backgroundColor = UIColor(red: 0, green: 50, blue: 0, alpha: 1)
            toggleView.imageView?.tintColor = .white
            toggleView.layer.cornerRadius = 10
        }
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleAndFilterConst()
        toggleViewConst()
        searchLabelConst()
        filterSetup()
        view.addSubview(collectionView)
        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 190, left: 65, bottom: 0, right: 65))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        currTypes = types
    
    }
    
}

extension PokedexVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = currPokemons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.reuseIdentifier, for: indexPath) as! PokedexCell
        cell.symbol = pokemon
        return cell
    }
}


extension PokedexVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if gridOrNot {
            return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
        } else {
            return CGSize(width: 100, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let symbol = PokemonGenerator.shared.getPokemonArray()[indexPath.item]
        let tappedCell = collectionView.cellForItem(at: indexPath) as! PokedexCell
        let vc = DetailsVC(data: tappedCell.symbol!)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


extension PokedexVC: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //fltering by name
        currPokemons = currPokemons.filter({ p in
            p.name.contains(searchText)
        })
        if currPokemons.count == 0 {
                currPokemons = PokemonGenerator.shared.getPokemonArray()
            }
            collectionView.reloadData()
        }
    //should reset search
//    func cancelButtonHandler(_ searchBar: UISearchBar) {
//        currPokemons = pokemons
//        currSelected = ""
//        collectionView.reloadData()
//    }
}


