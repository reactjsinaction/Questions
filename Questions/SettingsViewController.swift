import UIKit

class SettingsViewController: UITableViewController {

	// MARK: Properties

	@IBOutlet weak var bgMusicLabel: UILabel!
	@IBOutlet weak var parallaxEffectLabel: UILabel!
	@IBOutlet weak var darkThemeLabel: UILabel!
	@IBOutlet weak var resetGameButton: UIButton!

	var optionsLabels: [UILabel]!
	@IBOutlet weak var settingsNavItem: UINavigationItem!
	@IBOutlet weak var bgMusicSwitch: UISwitch!
	@IBOutlet weak var parallaxEffectSwitch: UISwitch!
	@IBOutlet weak var darkThemeSwitch: UISwitch!
	
	// MARK: View life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
	
		settingsNavItem.title = "Settings".localized
		
		bgMusicLabel.text = "Background music".localized
		parallaxEffectLabel.text = "Parallax effect".localized
		darkThemeLabel.text = "Dark theme".localized
		resetGameButton.setTitle("Reset game".localized, for: .normal)

		optionsLabels = [bgMusicLabel, parallaxEffectLabel, darkThemeLabel, resetGameButton.titleLabel ?? UILabel()]

		if let motionEffects = MainViewController.backgroundView?.motionEffects {
			parallaxEffectSwitch.setOn(!motionEffects.isEmpty, animated: true)
		}
		bgMusicSwitch.setOn(MainViewController.bgMusic?.isPlaying ?? false, animated: true)
		darkThemeSwitch.setOn(Settings.sharedInstance.darkThemeEnabled, animated: true)
		
		loadCurrentTheme()
	}

	// MARK: UITableViewDataSouce

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return optionsLabels.count
	}

	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		var completedSets = UInt()
		Settings.sharedInstance.completedSets.forEach { if $0 { completedSets += 1 } }
		
		return "\n\("Statistics".localized): \n\n" +
			"\("Completed sets".localized): \(completedSets)\n" +
			"\("Correct answers".localized): \(Settings.sharedInstance.correctAnswers)\n" +
			"\("Incorrect answers".localized): \(Settings.sharedInstance.incorrectAnswers)\n"
	}
	
	// MARK: UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		let footer = view as? UITableViewHeaderFooterView
		footer?.textLabel?.textColor = darkThemeSwitch.isOn ? .lightGray : .gray
		footer?.backgroundView?.backgroundColor = darkThemeSwitch.isOn ? .darkGray : .defaultBGcolor
	}
	
	// MARK: Alerts

	@IBAction func resetGameAlert() {
		
		let alertViewController = UIAlertController(title: "",
													message: "What do you want to reset?".localized,
													preferredStyle: .actionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
		let everythingAction = UIAlertAction(title: "Everything".localized, style: .destructive) { action in self.resetGameOptions() }
		let statisticsAction = UIAlertAction(title: "Only statistics".localized, style: .default) {	action in self.resetGameStatistics() }
		
		alertViewController.addAction(cancelAction)
		alertViewController.addAction(everythingAction)
		alertViewController.addAction(statisticsAction)
		
		present(alertViewController, animated: true, completion: nil)
	}

	// MARK: IBActions

	@IBAction func switchBGMusic() {

		if bgMusicSwitch.isOn { MainViewController.bgMusic?.play() }
		else { MainViewController.bgMusic?.pause() }
		
		Settings.sharedInstance.musicEnabled = bgMusicSwitch.isOn
	}

	@IBAction func switchParallaxEffect() {

		if parallaxEffectSwitch.isOn {
			MainViewController.addParallax(toView: MainViewController.backgroundView)
		}
		else if let effects = MainViewController.motionEffects {
			MainViewController.backgroundView?.removeMotionEffect(effects)
		}
	}

	@IBAction func switchTheme() {
		Settings.sharedInstance.darkThemeEnabled = darkThemeSwitch.isOn
		loadCurrentTheme()
	}
	
	// MARK: Convenience
	
	func loadCurrentTheme() {
		
		navigationController?.navigationBar.barStyle = darkThemeSwitch.isOn ? .black : .default
		navigationController?.navigationBar.tintColor = darkThemeSwitch.isOn ? .orange : .defaultTintColor
		
		tableView.backgroundColor = darkThemeSwitch.isOn ? .darkGray : .defaultBGcolor
		tableView.separatorColor = darkThemeSwitch.isOn ? .darkGray : .defaultSeparatorColor
		
		resetGameButton.setTitleColor(darkThemeSwitch.isOn ? .white : .black, for: .normal)
		
		let blueSwitch = UIColor(red: 80/255, green: 165/255, blue: 216/255, alpha: 1.0)
		let orangeSwitch = UIColor(red: 216/255, green: 159/255, blue: 50/255, alpha: 1.0)
		bgMusicSwitch.onTintColor = darkThemeSwitch.isOn ? orangeSwitch : blueSwitch
		parallaxEffectSwitch.onTintColor = darkThemeSwitch.isOn ? orangeSwitch : blueSwitch
		darkThemeSwitch.onTintColor = darkThemeSwitch.isOn ? orangeSwitch : blueSwitch
		
		tableView.reloadData()
			
		for i in 0..<optionsLabels.count {
			optionsLabels[i].textColor = darkThemeSwitch.isOn ? .white : .black
			tableView.visibleCells[i].backgroundColor = darkThemeSwitch.isOn ? .gray : .white
		}
	}
	
	func resetGameStatistics() {
		
		Settings.sharedInstance.completedSets = [Bool](repeating: false, count: Quiz.set.count)
		Settings.sharedInstance.correctAnswers = 0
		Settings.sharedInstance.incorrectAnswers = 0

		tableView.reloadData()
	}

	func resetGameOptions() {
		
		resetGameStatistics()
		Settings.sharedInstance.musicEnabled = true
		MainViewController.bgMusic?.play()
		bgMusicSwitch.setOn(true, animated: true)
		
		if !parallaxEffectSwitch.isOn {
			MainViewController.addParallax(toView: MainViewController.backgroundView)
		}
		
		parallaxEffectSwitch.setOn(true, animated: true)
		darkThemeSwitch.setOn(false, animated: true)
		Settings.sharedInstance.darkThemeEnabled = false
		
		loadCurrentTheme()
		tableView.reloadData()
	}
}
