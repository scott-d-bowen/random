//
//  SDBX.swift
//  FADB
//
//  Created by Scott Bowen on 17/12/2021.
//

import Foundation

struct SDBX {
    
    var totalValues  = 0
    var uniqueValues = 0

    var set: Set<UInt8> = [ ]
    var values: [UInt8] = [ ]
    var valCounts: [UInt8] = Array(repeating: 0x00, count: 256)
    var originalIndex: [UInt8] = [ ]
    
    mutating func addValue(value: UInt8) {
        if (totalValues < 256) {
            set.update(with: value)
            values.append(value)
            originalIndex.append(UInt8(originalIndex.count))
            totalValues += 1
            uniqueValues = set.count
            valCounts[Int(value)] += 1
        } else {
            print(" * Total values exceeded.")
        }
    }
}
