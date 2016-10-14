//
//  ViewController.swift
//  ChartTest
//
//  Created by Opcma on 21/09/2016.
//  Copyright © 2016 OpcmaTunisie. All rights reserved.
//

import UIKit

private let Const = 133100

class ViewController: UIViewController {
    
   // var graphView1Color1 = UIColor(rgba:"#FFB85F")
   // var graphView1Color2 = UIColor(rgba:"#FF7A5A")
    
   // var graphView1Color1 = UIColor(rgba:"#26D0CE")
   // var graphView1Color2 = UIColor(rgba:"#EAECC6")
    //var graphView2Color1 = UIColor(rgba:"#1CD8D2")
    //var graphView2Color2 = UIColor(rgba:"#93EDC7")
    //var graphView3Color1 = UIColor(rgba:"#70e1f5")
    //var graphView3Color2 = UIColor(rgba:"#ffd194")

    var graphView1Color1 = UIColor(rgba:"#70e1f5")
    var graphView1Color2 = UIColor(rgba:"#ffd194")
    
    var graphView2Color1 = UIColor(rgba:"#26D0CE")
    var graphView2Color2 = UIColor(rgba:"#EAECC6")
    
    var graphView3Color1 = UIColor(rgba:"#1CD8D2")
    var graphView3Color2 = UIColor(rgba:"#93EDC7")
    
    var graphView1:GraphView?
    var graphView2:GraphView?
    var graphView3:GraphView?

    var label: UILabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //*****Mark:Graph View 1
        graphView1 = GraphView(frame: CGRectMake(40,50, 700, 300))
        
        graphView1?.layer.masksToBounds = false
        graphView1?.layer.cornerRadius = 25.0
        
        //---- label Title :
            var label: UILabel = UILabel()
            label.frame = CGRectMake(10,10, 220, 40)
            label.text = "Ahmed"
            label.textColor = .whiteColor()
            graphView1?.addSubview(label)
        //------
        graphView1?.startColor = graphView1Color1
        graphView1?.endColor = graphView1Color2
        graphView1?.graphPoints = calculTrameFromBLEAfterConstant([133144,133159,133153,133142,133144,133155,133148,133151,133151,133148,133160])
        graphView1?.xPoint = ["0","100","200"]
        self.view.addSubview(graphView1!)
        
        setupGraphDisplay(graphView1!)



        // *****************************
        
        //*****Mark:Graph View 2

        graphView2 = GraphView(frame: CGRectMake(40,380, 700, 300))
        //---- label Title :
            var label2: UILabel = UILabel()
            label2.frame = CGRectMake(10,10, 220, 40)
            label2.text = "Amine"
            label2.textColor = .whiteColor()
            graphView2?.addSubview(label2)
        //------
        graphView2?.startColor = graphView2Color1
        graphView2?.endColor = graphView2Color2
        graphView2?.graphPoints = [3,1,2,2,1,3,1,2,1,3,2,1,3,2,1,2,3,1,2,1,2,1,1,2,3]
        graphView2?.xPoint = ["A","B","C","D","E","A","B","C","D","E","A","B","C","D","E","A","B","C","D","E","A","B","C","D","E"]
        self.view.addSubview(graphView2!)
        
        setupGraphDisplay(graphView2!)

        // *****************************
        

        //*****Mark:Graph View 3
        graphView3 = GraphView(frame: CGRectMake(40,700, 700, 300))
        //---- label Title :
            var label3: UILabel = UILabel()
            label3.frame = CGRectMake(10,10, 220, 40)
            label3.text = "Zribi"
            label3.textColor = .whiteColor()
            graphView3?.addSubview(label3)
        //------
        graphView3?.startColor = graphView3Color1
        graphView3?.endColor = graphView3Color2
        graphView3?.graphPoints = [1,3,2,9,1]
        graphView3?.xPoint = ["A","B","C","D","E"]
        self.view.addSubview(graphView3!)
        
        setupGraphDisplay(graphView3!)

        // *****************************

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGraphDisplay(graphView:GraphView) -> UIView {
        
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //1 - replace last day with today's actual data
        //graphView.graphPoints[graphView.graphPoints.count-1] = graphView.graphPoints.maxElement()! as Int
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        var maxLabel = UILabel(frame: CGRectMake(2,45, 100, 20))
        maxLabel.text = "\(calculTrameFromBLEBeforeConstant(graphView.graphPoints).maxElement()! as Int)"
        maxLabel.textColor = .whiteColor()
        graphView.addSubview(maxLabel)
        
        //3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        //averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
       /* //4 - get today's day number
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
                                             fromDate: NSDate())
        var weekday = components.weekday
        
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        
        //5 - set up the day name labels with correct day
     
        for i in (1...days.count).reverse() {
            print(graphView.viewWithTag(i) as? UILabel)

                if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday--]
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }*/
        
        return graphView
        
    }
    
    func calculTrameFromBLEAfterConstant(trame:[Int])->[Int]
    {
        var finalTrame:[Int] = []

        for value in trame
        {
           let finalValue = (value - Const)
            finalTrame.append(Int(finalValue))
        }
        
        return finalTrame
    }
    func calculTrameFromBLEBeforeConstant(trame:[Int])->[Int]
    {
        var finalTrame:[Int] = []
        
        for value in trame
        {
            let finalValue = (value + Const)
            finalTrame.append(Int(finalValue))
        }
        
        return finalTrame
    }
    


}

