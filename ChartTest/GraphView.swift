//
//  GraphView.swift
//  ChartTest
//
//  Created by Opcma on 21/09/2016.
//  Copyright © 2016 OpcmaTunisie. All rights reserved.
//

import UIKit
import CoreGraphics

@IBDesignable class GraphView: UIView {
    
    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.grayColor()
   // var graphPoints:[Int] = [1,20,6,9,3,8,9]
    var graphPoints:[Int] = []

    var xPoint:[String] = []

    override func drawRect(rect: CGRect) {
        
       // self.layer.cornerRadius = 15.0
        
        let width = rect.width
        let height = rect.height
        
        //set up background clipping area
        /*var path = UIBezierPath(roundedRect: rect,byRoundingCorners: UIRectCorner.AllCorners,cornerRadii: CGSize(width: 15.0, height: 15.0))
        path.addClip()
        */
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
                                                  colors,
                                                  colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context!,
                                    gradient!,
                                    startPoint,
                                    endPoint,
                                    CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        //calculate the x point
        
        let margin:CGFloat = 20.0
        var columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        // calculate the y point
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.maxElement()
        var columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // draw the line graph
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //set up the points line
        var graphPath = UIBezierPath()
        //go to start of line
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0),y:columnYPoint(graphPoints[0])))
        
        // First label in axe X
        let label0 = UILabel(frame: CGRectMake(20, 270, 40, 30))
        label0.center = CGPointMake(20, 270)
        label0.textAlignment = NSTextAlignment.Center
        label0.textColor = .whiteColor()
        label0.text = xPoint[0]
        self.addSubview(label0)
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),y:columnYPoint(graphPoints[i]))
          /*  // create label in point
            let label = UILabel(frame: CGRectMake(columnXPoint(i) , 270, 40, 30))
            label.center = CGPointMake(columnXPoint(i), 270)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = .whiteColor()
            //label.text = "1"
            label.tag = i+1
          //  print ("label.tag",label.tag)
            self.addSubview(label)
            //-----
            if let labelView = self.viewWithTag(i+1) as? UILabel {
              //  print ("self.viewWithTag(i) as? UILabel",self.viewWithTag(i+1) as? UILabel)
              //  print("days[i]",days[i])
                labelView.text = days[i]

            }

            //------
 */
            graphPath.addLineToPoint(nextPoint)
        }
        
        
        
        //graphPath.stroke()
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        CGContextSaveGState(context!)
        
        //2 - make a copy of the path
        var clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(graphPoints.count - 1),y:height))
        clippingPath.addLineToPoint(CGPoint(x:columnXPoint(0),y:height))
        clippingPath.closePath()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        //5 - check clipping path - temporary code
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context!, gradient!, startPoint, endPoint, CGGradientDrawingOptions(rawValue: UInt32(0)))
        CGContextRestoreGState(context!)
        //end temporary code
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        

        //Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 2.0
        linePath.stroke()
        
        
        // label of axe X
            let label = UILabel(frame: CGRectMake(350 , 270, 40, 30))
            label.center = CGPointMake(350, 270)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = .whiteColor()
            label.text = xPoint[1]
            self.addSubview(label)
            //-----
        let label1 = UILabel(frame: CGRectMake(680 , 270, 40, 30))
        label1.center = CGPointMake(680, 270)
        label1.textAlignment = NSTextAlignment.Center
        label1.textColor = .whiteColor()
        label1.text = xPoint[2]
        self.addSubview(label1)

        

    
    
    }
  /*
     func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.locationInView(self)
            for i in 0..<graphPoints.count {
                let nextPoint = CGPoint(x:columnXPoint(i),y:columnYPoint(graphPoints[i]))
            print(position.x)
            print(position.y)
            
        }
    }
    */

    
    
    
}
