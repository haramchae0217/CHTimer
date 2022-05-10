//
//  Laps.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/10.
//

import UIKit

struct Laps {
    var lap: String
    var percent: Double
    var memo: String = "추가 메모 없음"
    
    static var laps: [Laps] = []
}

