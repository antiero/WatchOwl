//
//  ComplicationController.swift
//  OwlWatch WatchKit Extension
//
//  Created by Antony Nasce on 30/09/2018.
//  Copyright © 2018 Antony Nasce. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        if complication.family == .utilitarianSmall {
            let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
            smallFlat.textProvider = CLKSimpleTextProvider(text: "42%")
            smallFlat.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "gauge")!)
            smallFlat.tintColor = UIColor.green
            handler(smallFlat)
        }
        else if complication.family == .circularSmall {
            let circularSmall = CLKComplicationTemplateCircularSmallRingImage()
            circularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "gauge")!)
            circularSmall.ringStyle = .closed
            circularSmall.tintColor = UIColor.green
            handler(circularSmall)
        }
        else if complication.family == .modularSmall {
              let modularSmall = CLKComplicationTemplateModularSmallRingImage()
              modularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "gauge")!)
              modularSmall.ringStyle = .closed
              modularSmall.tintColor = UIColor.green
              handler(modularSmall)
            }
        handler(nil)
    }
    
}
