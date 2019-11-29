//
//  SSBouncingBallView.swift
//  SSBouncingBall
//
//  Created by Jianing Fu on 11/29/19.
//  Copyright © 2019 Jianing Fu. All rights reserved.
//

import Foundation
import ScreenSaver

struct Ball {
    var ballPosition: CGPoint
    var ballVelocity: CGVector
    var ballRadius: CGFloat
    var ballColor: NSColor
    
    init() {
        ballPosition = .zero
        ballVelocity = .zero
        ballRadius = 10
        ballColor = .white
    }
}

class SSBouncingBallView: ScreenSaverView {

    private let ballNumber: Int = Int.random(in: 1...2)
    private var ballArray: [Ball] = Array()

    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        for _ in 1...self.ballNumber {
            var b: Ball = Ball()
            b.ballPosition = CGPoint(x: CGFloat.random(in: 0...frame.width), y: CGFloat.random(in: 0...frame.height))
            b.ballVelocity = initialVelocity()
            b.ballRadius = CGFloat.random(in: 5...15)
            ballArray.append(b)
        }
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        // Draw a single frame in this function
        drawBackground(.black)
        drawBall()
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        
        // Update the "state" of the screensaver in this function
        for i in 1...self.ballNumber {
            var b: Ball = ballArray[i]
            let oobAxes = ballIsOOB(b: b)
            if oobAxes.xAxis {
                b.ballVelocity.dx *= -1
            }
            if oobAxes.yAxis {
                b.ballVelocity.dy *= -1
            }

            b.ballPosition.x += b.ballVelocity.dx
            b.ballPosition.y += b.ballVelocity.dy
        }

        setNeedsDisplay(bounds)
    }
    
    private func drawBackground(_ color: NSColor) {
         let background = NSBezierPath(rect: bounds)
         color.setFill()
         background.fill()
     }
    
    private func initialVelocity() -> CGVector {
        let desiredVelocityMagnitude: CGFloat = 10
        let xVelocity = CGFloat.random(in: 1.0...3.0)
        let xSign: CGFloat = Bool.random() ? 1 : -1
        let yVelocity = sqrt(pow(desiredVelocityMagnitude, 2) - pow(xVelocity, 2))
        let ySign: CGFloat = Bool.random() ? 1 : -1
        return CGVector(dx: xVelocity * xSign, dy: yVelocity * ySign)
    }

    private func drawBall() {
        for i in 1...ballNumber {
            let b: Ball = ballArray[i]
            let ballRect = NSRect(x: b.ballPosition.x - b.ballRadius,
                                  y: b.ballPosition.y - b.ballRadius,
                                  width: b.ballRadius * 2,
                                  height: b.ballRadius * 2)
            let ball = NSBezierPath(roundedRect: ballRect,
                                    xRadius: b.ballRadius,
                                    yRadius: b.ballRadius)
            b.ballColor.setFill()
            ball.fill()
        }
    }
    
    private func ballIsOOB(b: Ball) -> (xAxis: Bool, yAxis: Bool) {
        let xAxisOOB = b.ballPosition.x - b.ballRadius <= 0 ||
            b.ballPosition.x + b.ballRadius >= bounds.width
        let yAxisOOB = b.ballPosition.y - b.ballRadius <= 0 ||
            b.ballPosition.y + b.ballRadius >= bounds.height
        return (xAxisOOB, yAxisOOB)
    }

}
