/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class Log{
    
    private static var entries = [LogEntry]()
    
    private static var lock = DispatchSemaphore(value: 1)
    
    private static var logging = false
    
    static var isLogging: Bool{
        logging
    }
    
    static var isEmtpy: Bool{
        entries.isEmpty
    }
    
    static func startLogging(){
        logging = true
        if isEmtpy{
            log("Log started")
            Preferences.instance.log()
        }
        else{
            log("Log resumed")
        }
    }
    
    static func stopLogging(){
        log("Log stopped")
        logging = false
    }
    
    static func clear(){
        lock.wait()
        defer{lock.signal()}
        entries.removeAll()
        logging = false
    }
    
    static func log(_ text: String){
        if logging{
            lock.wait()
            defer{lock.signal()}
            let entry = LogEntry(text: text, time: Date())
            entries.append(entry)
            print(entry.toString())
        }
    }
    
    static func toString() -> String{
        var s = ""
        for entry in entries{
            s += entry.toString()
            s += "\n"
        }
        return s
    }
    
}

struct LogEntry{
    
    var text: String
    var time: Date
    
    func toString() -> String{
        time.timestampString() + " - " + text
    }
}
