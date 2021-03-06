import XCTest
@testable import Questions

class QuestionsTests: XCTestCase {

	let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testQuestionsLabels() {

		let vc = storyboard.instantiateViewController(withIdentifier: "questionsViewController") as! QuestionViewController

		var answersFromPlist: [String]
		var numberOfQuestions: Int
		var set: [NSDictionary]
		var question: String

		vc.view.reloadInputViews()

		for i in 0..<Quiz.set.count {

			vc.currentSet = i
			vc.viewDidLoad()
			
			set = (vc.set as! [NSDictionary])

			numberOfQuestions = (vc.set as! [NSDictionary]).count

			print("-> Set: ", vc.currentSet)

			for j in 0..<numberOfQuestions {

				answersFromPlist = set[j]["answers"] as! [String]
				question = set[j]["question"] as! String

				// TEST QUESTION
				print("· Question \(j):\nQuestionLabel: \(vc.questionLabel.text!)\nPlistQuestion: \(question)\n")
				XCTAssert(vc.questionLabel.text! == question, "Question \(j) string didn't load correctly")

				// TEST ANSWERS
				for k in 0..<vc.answersButtons.count {
					print("·· Answer \(k):\nLabel: \(vc.answersButtons[k].currentTitle!)\nPlist: \(answersFromPlist[k])\n")
					XCTAssert(vc.answersButtons[k].currentTitle! == answersFromPlist[k], "Error loading answer string \(k) from set \(vc.currentSet)")
				}

				vc.pickQuestion()
			}
		}

	}

	func testSettingsSwitchAction() {

		if let bgMusic = MainViewController.bgMusic {
			
			let settingsVC = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
			
			settingsVC.view.reloadInputViews()
			
			settingsVC.bgMusicSwitch.setOn(true, animated: true)
			settingsVC.switchBGMusic()
			XCTAssert(bgMusic.isPlaying, "Music not playing when switch is ON")

			settingsVC.bgMusicSwitch.setOn(false, animated: true)
			settingsVC.switchBGMusic()
			XCTAssert(!bgMusic.isPlaying, "Music playing when switch is OFF")
		}
		else {
			XCTFail("Music could not load correctly")
		}
	}
}
