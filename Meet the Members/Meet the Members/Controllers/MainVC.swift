//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    
    var timer: Timer?
    var question: QuestionProvider.Question?
    var correctAnswer = 0
    var guessTime = 5
    var answerTime = 2
    var buttonTapped = 0
    enum WhichTime {
        case guessing, answers, paused, statistics
    }
    var whichTime = WhichTime.guessing
    
    
    let stats = Stats()
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Home", for: .normal)
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
    
    let imageView: UIImageView = {
        let view = UIImageView()
        // MARK: >> Your Code Here <<
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            // MARK: >> Your Code Here <<
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 10.0
            //adding shadow effect around buttons
            button.layer.shadowColor = UIColor(red: 0, green: 123, blue: 100, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 10.0
            button.layer.masksToBounds = false
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    
//     MARK: >> Your Code Here <<
    let scoreDisplay: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.textColor = .black
        label.backgroundColor = .systemGreen
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timerDisplay: UILabel = {
        let label = UILabel()
        label.text = "Guessing... 5"
        label.textColor = .black
        label.backgroundColor = .systemCyan
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let statsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Stats", for: .normal)
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
    
    let pauseButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Pause", for: .normal)
        button.backgroundColor = .systemOrange
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
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        startTimer()
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
    
        // MARK: >> Your Code Here <<
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-10),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -230)
            ])
        
        view.addSubview(homeButton)
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            homeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -300),
        ])

        
        view.addSubview(buttons[0])
        NSLayoutConstraint.activate([
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -210),
            buttons[0].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
        ])
        
        view.addSubview(buttons[1])
        NSLayoutConstraint.activate([
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 210),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttons[1].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
        ])
        
        view.addSubview(buttons[2])
        NSLayoutConstraint.activate([
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -210),
            buttons[2].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
        ])
        
        view.addSubview(buttons[3])
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 210),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttons[3].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
        ])
        
        view.addSubview(statsButton)
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
            statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 280),
            statsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -280),
            pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        view.addSubview(scoreDisplay)
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
            scoreDisplay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            scoreDisplay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
            scoreDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
            
        ])
        
        view.addSubview(timerDisplay)
        NSLayoutConstraint.activate([
            // MARK: >> Your Code Here <<
            timerDisplay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            timerDisplay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
            timerDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
        ])
        
        buttons.forEach { button in
            button.addTarget(self, action: #selector(tapAnswerHandler(_:)), for: .touchUpInside)
        }
        
        homeButton.addTarget(self, action: #selector(tapHomeHandler(_:)), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(tapStatsHandler(_:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(tapPauseHandler(_:)), for: .touchUpInside)
        
        // buttons[0].addTarget(self, action: #selector(tapAnswerHandler(_:)), for:.touchUpInside)
        
        getNextQuestion()
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
      
        // MARK: >> Your Code Here <<
        
        
        // MARK: STEP 10: Stats Button
        // See instructions above.
        
        // MARK: >> Your Code Here <<
        
    }
    
    
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // MARK: >> Your Code Here <<
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        eraseAnswer()
        if let nextQuestion = QuestionProvider.shared.nextQuestion() {
            question = nextQuestion
            imageView.image = nextQuestion.image
            
            for i in 0...3 {
                if nextQuestion.choices[i] == nextQuestion.answer {
                    correctAnswer = i
                    print(correctAnswer)
                }
                buttons[i].setTitle(nextQuestion.choices[i], for: .normal)
            }
            guessTime = 5
        
        } else {
            return
        }
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // You don't have to
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    // - Call `startTimer()` where appropriate
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - Checkout `UIControl.addAction(_:for:)`
    //      (`UIButton` subclasses `UIControl`)
    // - You can use `sender.tag` to identify which button is pressed.
    // - The timer will invoke the callback every one second.
    func startTimer() {
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallback() {
        // MARK: >> Your Code Here <<
        switch whichTime {
            case WhichTime.guessing:
                guessTime -= 1
                timerDisplay.text = "Guessing... \(guessTime)"
                if guessTime <= 0 {
                    guessTime = 5
                    buttons[correctAnswer].backgroundColor = .systemGreen
                    timerDisplay.text = "Answers... 2"
                    whichTime = WhichTime.answers
                }
            case WhichTime.answers:
                answerTime -= 1
                timerDisplay.text = "Answers... \(answerTime)"
                if answerTime <= 0 {
                    getNextQuestion()
                    answerTime = 2
                    whichTime = WhichTime.guessing
                    timerDisplay.text = "Guessing... 5"
                }
            case WhichTime.paused:
                    break
            
            case WhichTime.statistics:
                    break
        }
    }

    
    @objc func tapAnswerHandler(_ sender: UIButton) {
        // MARK: >> Your Code Here <<
        if whichTime == WhichTime.guessing {
            buttons[correctAnswer].backgroundColor = .systemGreen
            whichTime = WhichTime.answers                
        }
        if sender.tag != correctAnswer {
            stats.allAnswers.append(false)
            sender.backgroundColor = .systemRed
        } else {
            stats.allAnswers.append(true)
            stats.score += 1
            stats.streak += 1
            if stats.recentCorrect < 3 {
                stats.recentCorrect += 1
            }
            stats.bestStreak = max(stats.streak, stats.bestStreak)
        }
        scoreDisplay.text = "Score: \(stats.score)"
        timerDisplay.text = "Answers... 2"
    }
    
    @objc func tapStatsHandler(_ action: UIAction) {
        
        let vc = StatsVC(stats: stats)
        whichTime = WhichTime.statistics
      //  vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped i.e. stop the timer
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func tapPauseHandler(_ sender: UIButton) {
        if whichTime == WhichTime.guessing {
            whichTime = WhichTime.paused
            sender.setTitle("Resume", for: .normal)
            sender.backgroundColor = .systemGreen
        } else {
            whichTime = WhichTime.guessing
            sender.setTitle("Pause", for: .normal)
            sender.backgroundColor = .systemOrange
        }
    }
    
    
    func eraseAnswer() {
        buttons.forEach { button in
            button.backgroundColor = .white
                }
    }
    
    @objc func tapHomeHandler(_ action: UIAction) {
        let vc = StartVC()
        present(vc, animated: true, completion: nil)
    }

}
