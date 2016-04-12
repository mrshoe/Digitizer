//
//  ViewController.swift
//  Digitizer
//
//  Created by David Shoemaker on 4/10/16.
//
//

import UIKit

class ViewController: UIViewController {

    let button: UIButton
    let guess: UILabel
    let scribbleView: ScribbleView
    let imageView: UIImageView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.button = UIButton()
        self.guess = UILabel()
        self.scribbleView = ScribbleView()
        self.imageView = UIImageView()
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.button = UIButton()
        self.guess = UILabel()
        self.scribbleView = ScribbleView()
        self.imageView = UIImageView()
        super.init(coder: aDecoder)
    }

    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(red:(0xf2/255.0), green:(0x00/255.0), blue:(0x30/255.0), alpha: 1.0)

        self.button.backgroundColor = UIColor(red:(0xff/255.0), green:(0x5c/255.0), blue:0.0, alpha: 1.0)
        self.button.setTitle("CHECK", forState:UIControlState.Normal)
        self.button.showsTouchWhenHighlighted = true
        self.button.addTarget(self, action:"handleCheck:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(button)

        self.guess.backgroundColor = UIColor(red:(0x4b/255.0), green:(0xe6/255.0), blue:0.0, alpha: 1.0)
        self.guess.text = "0"
        self.guess.font = UIFont(name:"AmericanTypewriter-Bold", size:80.0)
        self.guess.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.guess)

        self.scribbleView.backgroundColor = UIColor(red:(0xf2/255.0), green:(0x00/255.0), blue:(0x30/255.0), alpha: 1.0)
        self.view.addSubview(self.scribbleView)

        // add this to preview the image input into the neural net
//        self.view.addSubview(self.imageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = self.view.bounds
        self.button.frame = CGRectMake(0, bounds.size.height-100, bounds.size.width/2, 100)

        self.guess.frame = CGRectMake(bounds.size.width/2, bounds.size.height-100, bounds.size.width/2, 100)

        self.scribbleView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height-100)

        self.imageView.frame = CGRectMake(0, 30, 20, 20)
    }

    internal func handleCheck(button: UIButton) {
        let image = self.scribbleView.getImage()
        self.guessImage(image)
        self.imageView.image = image
        UIView.animateWithDuration(0.5, delay:0.4, options:UIViewAnimationOptions.CurveEaseInOut, animations:{
                self.scribbleView.alpha = 0.0
            }, completion:{ (fin: Bool) in
                self.scribbleView.resetPath()
                self.scribbleView.alpha = 1.0
        })
    }

    internal func guessImage(image: UIImage) {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        NSLog("%d", CGColorSpaceGetNumberOfComponents(colorSpace))
        let w = Int(image.size.width)
        let h = Int(image.size.height)
        let context = CGBitmapContextCreate(nil, w, h, 8, w, colorSpace, 0)
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage)
        self.guess.text = String(format:"%d", predict(CGBitmapContextGetData(context)))
    }
}
