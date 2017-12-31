//
//  String.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 14/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import Foundation

extension String
{
    func toDouble()->Double?
    {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toFloat()->Float?
    {
        return NumberFormatter().number(from: self)?.floatValue
    }
}
