//
//  StatsVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 11: Going to StatsVC
    // Read the instructions in MainVC.swift
    
    let stats: Stats
    
    let bestStreakView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
            
        return view
    }()
    
    let scoreView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 30)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let statsLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.text = "Statistics"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let recentScoresView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10.0
        
        //adding shadow effect around buttons
        button.layer.shadowColor = UIColor(red: 0, green: 50, blue: 100, alpha: 0.5).cgColor
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        button.layer.masksToBounds = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let image: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "mdbcoverimage.jpg")
            view.contentMode = UIView.ContentMode.scaleAspectFit
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
    
    
    
    init(stats: Stats) {
        self.stats = stats
        bestStreakView.text = "Best Streak: \(stats.bestStreak)"
        scoreView.text = "Score: \(stats.score)"
        
        // Delegate rest of the initialization to super class
        // designated initializer.
        super.init(nibName: nil, bundle: nil)
        let recentNumber = min(stats.allAnswers.count, 3)
        recentScoresView.text = "Recent score: \(stats.recentCorrect) / \(recentNumber)"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 12: StatsVC UI
    // Action Items:
    // - Initialize the UI components, add subviews and constraints
    
    // MARK: >> Your Code Here <<
    
    override func viewDidLoad() {

        view.backgroundColor = .white
        view.addSubview(statsLabelView)
        view.addSubview(bestStreakView)
        view.addSubview(scoreView)
        view.addSubview(recentScoresView)
        view.addSubview(backButton)
        view.addSubview(image)
        
        NSLayoutConstraint.activate([
            
            statsLabelView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 30
            ),
            statsLabelView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            scoreView.topAnchor.constraint(
                equalTo: statsLabelView.bottomAnchor,
                constant: 80
            ),
            scoreView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            recentScoresView.bottomAnchor.constraint(
                equalTo: bestStreakView.topAnchor,
                constant: -30
            ),
            recentScoresView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            bestStreakView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -100
            ),
            bestStreakView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -300),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            image.bottomAnchor.constraint(equalTo: bestStreakView.topAnchor, constant: -150),

        ])
        

        
        backButton.addTarget(self, action: #selector(tapBackHandler(_:)), for: .touchUpInside)
    
    }
    @objc func tapBackHandler(_ action: UIAction) {
        
        let vc = MainVC()
        present(vc, animated: true, completion: nil)
    }

}
