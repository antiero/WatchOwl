//
//  InterfaceController.swift
//  OwlWatch WatchKit Extension
//
//  Created by Antony Nasce on 30/09/2018.
//  Copyright © 2018 Antony Nasce. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var refreshButton: WKInterfaceButton!
    
    @IBOutlet weak var usingText: WKInterfaceLabel!
    @IBOutlet weak var solarText: WKInterfaceLabel!
    @IBOutlet weak var exportingText: WKInterfaceLabel!
    
    @IBAction func refreshTapped() {
        solarText.setText(String(CFAbsoluteTimeGetCurrent()))
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let using = message["using"] as? String
        usingText.setText(using)

        let solar = message["solar"] as? String
        solarText.setText(solar)

        let exporting = message["exporting"] as? String
        exportingText.setText(exporting)

        WKInterfaceDevice().play(.success)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
    }

}
