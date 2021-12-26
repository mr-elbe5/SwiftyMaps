//
//  Log.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 26.12.21.
//

import Foundation

class Log{
    
    private static var entries = [LogEntry]()
    
    private static var lock = DispatchSemaphore(value: 1)
    
    private static var logging = false
    
    static var isLogging: Bool{
        logging
    }
    
    static func startLogging(){
        logging = true
        log("log started")
    }
    
    static func stopLogging(){
        log("log stopped")
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
        }
        return s
    }
    
}

struct LogEntry{
    
    var text: String
    var time: Date
    
    func toString() -> String{
        time.dateTimeString() + ": " + text + " \n"
    }
}
