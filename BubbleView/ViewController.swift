//
//  ViewController.swift
//  BubbleView
//
//  Created by yilmaz on 16.07.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Variable Declaration
    var BubbleTimer:Timer?
    
    private lazy var bubbleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Tap Me", for: .normal)
        btn.tintColor = .white
        btn.setBackgroundColor(.systemBlue, for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(imdbImageTouchUpInside), for: .touchUpInside)
        return btn
    }()
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BubbleTimer?.invalidate()
        BubbleTimer = nil
    }
    
    //MARK: - Function Declaration
    func setupUI() {
        BubbleTimer = Timer.scheduledTimer(timeInterval: 1.06, target: self, selector: #selector(self.startBubble), userInfo: nil, repeats: true)
    }
    
    @objc private func imdbImageTouchUpInside() {
        
        print("Pressed Bubble Button")
       
    }
    
    private func setupLayout(){
        view.addSubview(bubbleButton)
        bubbleButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bubbleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bubbleButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        bubbleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

//MARK: - Bubble Configuration
extension ViewController{
    
    @objc func startBubble() ->Void{

        let bubbleImageView = UIImageView()
        
        let intRandom = self.generateIntRandomNumber(min: 1, max: 6)
        
        if intRandom % 2 == 0{
            bubbleImageView.backgroundColor = UIColor.customOrangeColor
        }else{
            bubbleImageView.backgroundColor = UIColor.customBlueColor
        }
        let size = self.randomFloatBetweenNumbers(firstNum: 9, secondNum: 40)
        
        let randomOriginX = self.randomFloatBetweenNumbers(firstNum: self.bubbleButton.frame.minX, secondNum: self.bubbleButton.frame.maxX)
        let originy = self.view.frame.maxY
        
        
        bubbleImageView.frame = CGRect(x: randomOriginX, y: 0, width: CGFloat(size), height: CGFloat(size))
        bubbleImageView.alpha = self.randomFloatBetweenNumbers(firstNum: 0.0, secondNum: 1.0)
        bubbleImageView.layer.cornerRadius = bubbleImageView.frame.size.height / 2
        bubbleImageView.clipsToBounds = true
        self.view.addSubview(bubbleImageView)
        
        let zigzagPath: UIBezierPath = UIBezierPath()
        let oX: CGFloat = bubbleImageView.frame.origin.x
        let oY: CGFloat = bubbleButton.frame.origin.y
        let eX: CGFloat = oX
        let eY: CGFloat = oY - (self.randomFloatBetweenNumbers(firstNum: self.bubbleButton.frame.midY, secondNum: self.bubbleButton.frame.maxY))
        let t = self.randomFloatBetweenNumbers(firstNum: 20, secondNum: 100)
        var cp1 = CGPoint(x: oX - t, y: ((oY + eY) / 2))
        var cp2 = CGPoint(x: oX + t, y: cp1.y)
        
        let r = arc4random() % 2
        if (r == 1){
            let temp:CGPoint = cp1
            cp1 = cp2
            cp2 = temp
        }
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        
        zigzagPath.addCurve(to: CGPoint(x: eX, y: 400), controlPoint1: cp1, controlPoint2: cp2)
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.01, options: .curveEaseInOut, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 2.5
        pathAnimation.path = zigzagPath.cgPath
        
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
        
    }
    
    func generateIntRandomNumber(min: Int, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
    
    func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}
