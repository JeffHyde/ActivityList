//
//  Event.swift
//  PlaiTester
//
//  Created by Jeff  Hyde on 11/15/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import Foundation
import UIKit

class Event: Decodable {
    
    let activity: String?
    let description: String?
    let image_link: String?
    let membership_link: String?
    let name: String?
    let summary: String?
    let time: String?
    let type: String?
    let venue: Venue?
    
    //Image Not Decoded.  So we need CodingKeys to exclude the UIImage
    var image: UIImage?
    //
    
    private enum CodingKeys: String, CodingKey {
        case activity
        case description
        case image_link
        case membership_link
        case name
        case summary
        case time
        case type
        case venue
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activity = try container.decode(String.self, forKey: .activity)
        description = try container.decode(String.self, forKey: .description)
        image_link = try container.decode(String.self, forKey: .image_link)
        membership_link = try container.decode(String.self, forKey: .membership_link)
        name = try container.decode(String.self, forKey: .name)
        summary = try container.decode(String.self, forKey: .summary)
        time = try container.decode(String.self, forKey: .time)
        type = try container.decode(String.self, forKey: .type)
        venue = try container.decode(Venue.self, forKey: .venue)
    }
    
    func getImage(completion: @escaping (_ image:UIImage) -> Void)  {
        if let link = image_link {
        if let url = URL(string: link) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    self.image = UIImage(data:data)
                    completion(UIImage(data:data)!)
                }
            }).resume()
        }
        }
    }
    
}

