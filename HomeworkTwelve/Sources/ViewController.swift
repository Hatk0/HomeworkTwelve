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
    
    private lazy var progressBar: CircularProgressBarView = {
           let progressBar = CircularProgressBarView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            progressBar.progressBarWidth = 10
            progressBar.isUserInteractionEnabled = false
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            return progressBar
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
        let views = [timerLabel,
                     playPauseButton,
                     progressBar]
        
        views.forEach { view.addSubview($0) }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: progressBar.frame.width),
            progressBar.heightAnchor.constraint(equalToConstant: progressBar.frame.width)
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
        
        progressBar.progressBarColor = isWorkTime ? .systemRed : .systemGreen
        
        let textColor = isWorkTime ? UIColor.systemRed : UIColor.systemGreen
        timerLabel.textColor = textColor
        playPauseButton.tintColor = textColor
        view.backgroundColor = isWorkTime ? .white : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        progressBar.progressLayer.strokeColor = progressBar.progressBarColor.cgColor
    }
    
    func startTimer() {
        isStarted = true
        if remainingTime == 0 {
            isWorkTime.toggle()
            remainingTime = isWorkTime ? 25 * 60 : 5 * 60
        }
        
        progressBar.progressBarColor = isWorkTime ? .systemRed : .systemGreen
        updateUI()
        progressBar.startAnimating(duration: TimeInterval(remainingTime))
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            self.updateTimerLabel()
            
            if self.remainingTime == 0 {
                self.timer?.invalidate()
                self.isStarted = false
                self.progressBar.stopAnimating()
                self.startTimer()
            }
        }
    }
    
    func pauseTimer() {
        isStarted = false
        updateUI()
        timer?.invalidate()
        progressBar.pauseAnimating()
    }
    
    func updateTimerLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

