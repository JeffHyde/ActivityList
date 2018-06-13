//
//  Caller.swift
//  PlaiTester
//
//  Created by Jeff  Hyde on 11/18/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import Foundation

import UIKit

class Caller {
  
    static func getEvents(urlString: String, completion:  @escaping ([Event]) -> ()) {
        var events = [Event]()
        let jsonURLString = urlString
        guard let url = URL(string: jsonURLString) else {return}
        URLSession.shared.dataTask(with: url) {
            (data,response, error) in
            guard let data = data else {return}
            do {
                let event = try JSONDecoder().decode([Event].self, from: data)
                events = event
                print("Data: \(events)")
            } catch let jsonError {
                print("error: \(jsonError)")
            }
            completion(events)
            }.resume()
    }

}


