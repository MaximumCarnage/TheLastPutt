//
//  Types.swift
//  TheLastPutt
//
//  Created by Dean Georgiou on 2018-06-26.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//
typealias TileCoordinates = (column: Int, row: Int)
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = 0xFFFFFFFF
    static let Edge:UInt32 = 0b1
    static let Player: UInt32 = 0b10
}

