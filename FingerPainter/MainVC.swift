//
//  ViewController.swift
//  FingerPainter
//
//  Created by Trip Creighton on 1/31/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import UIKit
import Photos

class MainVC: UIViewController {
    
    @IBOutlet var imageView: UIImageView!,
                  settingsView: UIView!,
                  toolbar: UIToolbar!,
                  colorPreviewView: UIView!,
                  redLabel: UILabel!,
                  greenLabel: UILabel!,
                  blueLabel: UILabel!,
                  brushSizeLabel: UILabel!

    let blueColor = UIColor(r: 43, g: 127, b: 202, a: 255),
        whiteColor = UIColor(r: 230, g: 230, b: 230, a: 255),
        utils = Utilities(),
        defaults = UserDefaults()
    
    var  startPoint:CGPoint? = CGPoint(),
         endPoint:CGPoint? = CGPoint(),
         brushColor = UIColor(r: 127.5, g: 127.5, b: 127.5, a: 255),
         bSize = 12.0,
         isBrushMenuVisible = false,
         red:CGFloat = 0,
         green:CGFloat = 0,
         blue:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func willAppTerminate() {
        if defaults.bool(forKey: "saveCanvasState") {
            defaults.set(UIImagePNGRepresentation(imageView.image!), forKey: "savedImage")
        }
    }
    
    func setup() {
        //Add observer for shutting down app:
        NotificationCenter.default.addObserver(self, selector: #selector(willAppTerminate), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        
        //Settings View:
        settingsView.alpha = 0
        settingsView.layer.borderColor = whiteColor?.cgColor
        settingsView.layer.borderWidth = 2
        settingsView.layer.cornerRadius = 8
        
        //Color preview: 
        colorPreviewView.backgroundColor = brushColor
        colorPreviewView.layer.borderColor = whiteColor?.cgColor
        colorPreviewView.layer.borderWidth = 2
        colorPreviewView.layer.cornerRadius = 8
        
        if let lastImage = defaults.object(forKey: "savedImage") {
            imageView.image = UIImage(data: lastImage as! Data)
        }
        
    }
    
    /* OVERRIDES */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            self.startPoint = touch.location(in: self.imageView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            self.endPoint = touch.location(in: self.imageView)
            if let start = self.startPoint {
                draw(start, endPoint!)
            }
            self.startPoint = self.endPoint
        }
    }
    
    /* IBActions */
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        self.imageView.image = nil
    }
    
    @IBAction func settingsSlider(_ sender: UISlider) {
        if sender.tag == 0 {
            red = CGFloat(sender.value)
            redLabel.text = "Red(\(Int(red))):"
            redLabel.sizeToFit()
        } else if sender.tag == 1 {
            green = CGFloat(sender.value)
            greenLabel.text = "Green(\(Int(green))):"
            greenLabel.sizeToFit()
        } else if sender.tag == 2 {
            blue = CGFloat(sender.value)
            blueLabel.text = "Blue(\(Int(blue))):"
            blueLabel.sizeToFit()
        } else if sender.tag == 3 {
            bSize = Double(sender.value)
            brushSizeLabel.text = "Brush Size(\(Int(bSize))):"
            brushSizeLabel.sizeToFit()
        }
        if sender.tag != 3 { // Don't update the color only if the brush is changing
            brushColor = UIColor(r: red, g: green, b: blue, a: 255)!
            colorPreviewView.backgroundColor = brushColor
        }
    }
    
    @IBAction func paintBrushButtonPressed(_ sender: UIBarButtonItem) {
        isBrushMenuVisible = !isBrushMenuVisible
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations:  {
            if !self.isBrushMenuVisible {
                self.settingsView.alpha = 0
            } else {
                self.settingsView.alpha = 1
            }
        })
            
    }
    @IBAction func eraserButton(_ sender: Any) {
        //TODO
    }
    
    @IBAction func segueSettingsVC(segue: UIStoryboardSegue) {
        
    }
    
    func draw(_ start: CGPoint, _ end: CGPoint) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        
        if let cxt = UIGraphicsGetCurrentContext() {
            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
            
            cxt.setStrokeColor((brushColor?.cgColor)!)
            cxt.setFillColor((brushColor?.cgColor)!)
            cxt.setLineWidth(CGFloat(bSize))
            cxt.beginPath()
            cxt.move(to: startPoint!)
            cxt.addLine(to: endPoint!)
//            cxt.fillEllipse(in: CGRect(x: (startPoint?.x)!, y: (startPoint?.y)!, width: CGFloat(bSize), height: CGFloat(bSize)))
            cxt.strokePath()
        }
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            imageView.image = newImage
        }
    }
    
    
}

