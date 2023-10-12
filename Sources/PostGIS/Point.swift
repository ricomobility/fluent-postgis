//
//  File.swift
//  
//
//  Created by Ravil Khusainov on 23.08.23.
//

import Foundation

public struct Point: Codable {
    public let x: Double
    public let y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
