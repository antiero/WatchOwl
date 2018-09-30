//
//  ViewController.swift
//  WatchOwl
//
//  Created by Antony Nasce on 30/09/2018.
//  Copyright © 2018 Antony Nasce. All rights reserved.
//

import UIKit
import WebKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    var lastMessage: CFAbsoluteTime = 0
    @IBOutlet weak var webkitView: WKWebView!
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("buttonTapped")
        sendWatchMessage()
    }
    
    private func setupWebView() {
        if let url = URL(string: "https://www.owlintuition.com") {
            
            let request = URLRequest(url: url)
            self.webkitView.load(request)
        }
    }
    
    func sendWatchMessage() {
        print("sendWatchMessage triggered")
        let currentTime = CFAbsoluteTimeGetCurrent()

        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }

        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = ["Message": "Hello"]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        else {
            print("Not reachable?")
        }

        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
        
        self.webkitView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
                                    print(html!)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupWebView()
        //self.view.addSubview(self.webView)
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        let instructions = "Please ensure your Apple Watch is configured correctly. On your iPhone, launch Apple's 'Watch' configuration app then choose General > Wake Screen. On that screen, please disable Wake Screen On Wrist Raise, then select Wake For 70 Seconds. On your Apple Watch, please swipe up on your watch face and enable Silent Mode. You're done!"
//        let ac = UIAlertController(title: "Adjust your settings", message: instructions, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "I'm Ready", style: .default))
//        present(ac, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - WatchKitSession
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }
}

