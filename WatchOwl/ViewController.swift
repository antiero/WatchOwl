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
import SwiftSoup

class ViewController: UIViewController, WCSessionDelegate {

    var lastMessage: CFAbsoluteTime = 0
    var htmlString = ""
    
    @IBOutlet weak var elecUsageLabel: UILabel!
    @IBOutlet weak var solarGeneratingLabel: UILabel!
    @IBOutlet weak var solarExportingLabel: UILabel!
    
    
    @IBOutlet weak var webkitView: WKWebView!
    
    @IBAction func buttonTapped(_ sender: Any) {
        getCurrentOwlHTMLAsString(completion: { htmlString in
            self.getOwlDataFromHTML(html: htmlString ?? "NO HTML")
        })
        sendWatchMessage()
    }
    
    private func setupWebView() {
        if let url = URL(string: "https://www.owlintuition.com") {
            let request = URLRequest(url: url)
            self.webkitView.load(request)
        }
    }
    
    func getOwlDataFromHTML(html: String) {
    
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let electricityWatts: Element = try doc.select("#electricity-current-watts").first()!
            elecUsageLabel.text = try electricityWatts.text()
            
            let solarCurrentWatts: Element = try doc.select("#solar-current-watts").first()!
            solarGeneratingLabel.text = try solarCurrentWatts.text()

            let solarExportedWatts: Element = try doc.select("#solar-exported-watts").first()!
            solarExportingLabel.text = try solarExportedWatts.text()
            
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("getOwlDataFromHTML Error")
        }
    
    }
    
    func getCurrentOwlHTMLAsString (completion: @escaping (_ htmlString: String?) -> Void) {

       self.webkitView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (outerHTML, error ) in

            // Logic here
            completion(outerHTML as? String)
        })
    }
    
    func sendWatchMessage() {
        let currentTime = CFAbsoluteTimeGetCurrent()

        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }

        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = ["using": elecUsageLabel.text,
                           "solar" : solarGeneratingLabel.text,
                           "exporting" : solarExportingLabel.text]
                           
            WCSession.default.sendMessage(message as [String : Any], replyHandler: nil)
        }
        else {
            print("Not reachable?")
        }

        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
        

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

