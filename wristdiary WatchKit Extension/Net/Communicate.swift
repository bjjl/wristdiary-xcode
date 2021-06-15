//
//  Communicate.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 28.05.21.
//

import Foundation

struct IOManager {
    
    let sendURLString = "https://lion.mx.plus/api/send"
    let receiveURLString = "https://lion.mx.plus/api/receive"
    
    func sendEntry(user_id: String, entry: String) {
        
        let json: [String: Any] = [ "user_id": user_id, "entry": entry, "is_encrypted": "true" ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let url = URL(string: sendURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSONforSend(user_id: user_id, resultData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func receiveEntries(user_id: String, day: Int = 0, month: Int = 0) {
        
        let receiveForSpecificDay = day > 0 && month > 0
        
        var queryItems = [URLQueryItem(name: "user_id", value: user_id)]
        if receiveForSpecificDay {
            queryItems.append(URLQueryItem(name: "day", value: String(day)))
            queryItems.append(URLQueryItem(name: "month", value: String(month)))
        }
        var urlComps = URLComponents(string: receiveURLString)!
        urlComps.queryItems = queryItems
        
        if let url = urlComps.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSONforReceive(resultData: safeData,
                                             receiveForSpecificDay: receiveForSpecificDay)
                }
            }
            task.resume()
        }
    }
    
    func parseJSONforSend(user_id: String, resultData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StatusData.self, from: resultData)
            print(decodedData.result)
            receiveEntries(user_id: user_id)
        } catch {
            print(error)
        }
    }
    
    func parseJSONforReceive(resultData: Data, receiveForSpecificDay: Bool) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([EntryData].self, from: resultData)
            DispatchQueue.main.async {
                if receiveForSpecificDay {
                    DataController.shared.dayEntries = decodedData
                } else {
                    DataController.shared.entries = decodedData
                }
            }
        } catch {
            print(error)
        }
    }
    
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
