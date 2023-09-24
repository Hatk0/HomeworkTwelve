import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var isWorkTime = true
    var isStarted = false
    var timer: Timer?
    var remainingTime = 25 * 60
    
    // MARK: - UI
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupHierarchy() {
        view.addSubview(timerLabel)
        view.addSubview(playPauseButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20)
        ])
        
        updateUI()
    }
    
    // MARK: - Actions

    @objc func playPauseButtonTapped() {
        if isStarted {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    func updateUI() {
        let buttonImageName = isStarted ? "pause" : "play"
        let buttonImage = UIImage(systemName: buttonImageName)
        
        let imageFrame = CGRect(x: 0, y: 0, width: 40, height: 30)
        
        if let existingImageView = playPauseButton.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            existingImageView.image = buttonImage?.withRenderingMode(.alwaysOriginal)
        } else {
            let imageView = UIImageView(frame: imageFrame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = buttonImage?.withRenderingMode(.alwaysOriginal)
            playPauseButton.setImage(nil, for: .normal)
            playPauseButton.addSubview(imageView)
        }
        
        let textColor = isWorkTime ? UIColor.systemRed : UIColor.systemGreen
        timerLabel.textColor = textColor
        playPauseButton.tintColor = textColor
        view.backgroundColor = isWorkTime ? .white : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
    
    func startTimer() {
        isStarted = true
        if remainingTime == 0 {
            return
        }
        updateUI()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            self.updateTimerLabel()
            
            if self.remainingTime == 0 {
                self.timer?.invalidate()
                self.remainingTime = 0
                self.isWorkTime.toggle()
                self.updateUI()
            }
        }
    }
    
    func pauseTimer() {
        isStarted = false
        updateUI()
        timer?.invalidate()
    }
    
    func updateTimerLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

