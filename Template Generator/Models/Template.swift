//
//  Template.swift
//  Temp Generator
//
//  Created by Soufian Hossam on 2/10/19.
//  Copyright © 2019 Soufian Hossam. All rights reserved.
//

import Foundation

class Template: NSCopying {
    var name: String = ""
    var content: String = ""
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Template()
        copy.name = name
        copy.content = content
        return copy
    }
}
