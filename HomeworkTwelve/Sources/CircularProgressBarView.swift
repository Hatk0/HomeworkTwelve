import UIKit

class CircularProgressBarView: UIView {
    
    // MARK: - Properties
    
    var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var timer: Timer?
    private var startTime: TimeInterval = 0
    private var duration: TimeInterval = 0
    private var pausedTime: TimeInterval = 0
    private var pausedProgress: CGFloat = 0
    private var isAnimating = false

    var progressBarWidth: CGFloat = 5
    var progressBarColor: UIColor = .systemGreen
    var trackColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    // MARK: - Methods
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            radius: (bounds.width - progressBarWidth) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = progressBarWidth
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressBarColor.cgColor
        progressLayer.lineWidth = progressBarWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    func startAnimating(duration: TimeInterval) {
        self.duration = duration
        startTime = Date().timeIntervalSinceReferenceDate - pausedTime
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateProgress),
                                     userInfo: nil,
                                     repeats: true)
        isAnimating = true
    }

    @objc private func updateProgress() {
        if isAnimating {
            let currentTime = Date().timeIntervalSinceReferenceDate - pausedTime
            let elapsedTime = currentTime - startTime
            let progress = elapsedTime / duration
            progressLayer.strokeEnd = CGFloat(min(pausedProgress + progress, 1.0))

            if elapsedTime >= duration {
                timer?.invalidate()
                isAnimating = false
            }
        }
    }

    func pauseAnimating() {
        timer?.invalidate()
        pausedTime = Date().timeIntervalSinceReferenceDate - startTime
        pausedProgress = progressLayer.strokeEnd
        isAnimating = false
    }

    func stopAnimating() {
        timer?.invalidate()
        progressLayer.strokeEnd = 0
        pausedTime = 0
        pausedProgress = 0
        isAnimating = false
    }
}
