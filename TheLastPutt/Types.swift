//
//  Types.swift
//  TheLastPutt
//
//  Created by Dean Georgiou on 2018-06-26.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//enum GameState: Int {
enum GameState: Int {
    case initial=0, start, play, win, lose, reload, pause
}
typealias TileCoordinates = (column: Int, row: Int)
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = 0xFFFFFFFF
    static let Edge:UInt32 = 0b1
    static let Player: UInt32 = 0b10
    static let collider: UInt32  = 0b100
    static let Goal: UInt32 = 0b1000
}

