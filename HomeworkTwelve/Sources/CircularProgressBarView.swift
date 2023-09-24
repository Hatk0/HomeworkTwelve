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
}
