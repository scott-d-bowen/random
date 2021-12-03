//  main.swift
//  R4: Make Difficult
//
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

print("Hello, World!")
var date_start = Date()

var difficultCount = 0

for _ in 0..<65536 {
    let bigNum = BigUInt.randomInteger(withExactWidth: 256*8)
    let data   = bigNum.serialize()
    var stats: [UInt8] = Array(repeating: 0x00, count: 256)
    var dataUInt8: [UInt8] = [ ]
    

    for i in (0)..<(data.count) {
        stats[Int(data[i])] += 1
    }
    
    var uniqueValues = 0
    for i in (0)..<(stats.count) {
        if (stats[i] >= 1) {
            uniqueValues += 1
        }
    }
    if (uniqueValues >= 180) {
        difficultCount += 1
        dataUInt8 = data.toArray(type: UInt8.self)
        dataUInt8.sort()
        print("*:", uniqueValues, dataUInt8)
    }
    // stats.sort()
}
print("difficultCount:", difficultCount)
print()


print("\(-date_start.timeIntervalSinceNow)")
date_start = Date()
print(date_start)
print()
print("Goodbye.")
sleep(24*60*60)
