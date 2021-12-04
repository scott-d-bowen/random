//  main.swift
//  R4: Make Difficult
//  'Mark V'
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

let DIFFICULTY = 144    // Warning Use: ~161 to 186 only!

print("Hello, World!")
var date_start = Date()


var bulkStats: [UInt8] = [ ]

var difficultCount = 0
var VIPs: [UInt8] = [ ]

for _ in 0..<32768 {
    let bigNum = BigUInt.randomInteger(withExactWidth: 256*8)
    let data   = bigNum.serialize()
    var stats: [UInt8] = Array(repeating: 0x00, count: 256)
    var dataUInt8: [UInt8] = [ ]
    var first160UniqueValues: [UInt8] = [ ]
    var VIPs_Small: [UInt8] = [ ]

    for value in (0)..<(data.count) {
        stats[Int(data[value])] += 1
    }
    
    var uniqueValues = 0
    for value in (0)..<(stats.count) {
        if (stats[value] >= 1) {
            uniqueValues += 1
            if (uniqueValues <= 160) {
                first160UniqueValues.append(UInt8(value))
            }
        }
    }
    first160UniqueValues.sort()
    
    if (uniqueValues >= DIFFICULTY) {
        // TODO: print("C:", first160UniqueValues.count)
        difficultCount += 1
        dataUInt8 = data.toArray(type: UInt8.self)
        dataUInt8.sort()
        // TODO: print("*:", uniqueValues)
        for i in 0..<16 {
            for j in 0..<16 {
                if (dataUInt8[i*16+j] > first160UniqueValues.last!) {
                    // TODO: print(dataUInt8[i*16+j], terminator: ", ")
                    VIPs_Small.append(dataUInt8[i*16+j])
                    // if (j==15) { print() }
                }
            }
        }
        if (VIPs_Small.count >= 1) {
            VIPs_Small.insert(UInt8(VIPs_Small.count-1), at: 0)
            VIPs.append(contentsOf: VIPs_Small)
        } else {
            VIPs.append(0x00)
        }
    }
    stats.sort()
    bulkStats.append(contentsOf: stats)
}
print()
print()
print("difficultCount:", difficultCount)

let compVIPs = try NSData(data: Data(fromArray: VIPs)).compressed(using: .lzma)
print(compVIPs.length, VIPs.count, VIPs.first!, VIPs.last!)

let comp = try NSData(data: Data(fromArray: bulkStats)).compressed(using: .lzma)
print(comp.length, bulkStats.count, bulkStats.first!, bulkStats.last!)

print()

let fact4096 = factorial(4096)
print("fact4096.bits:", fact4096.bitWidth)

let fact160 = factorial(160)
print("fact160.bits:", fact160.bitWidth)

print()

print("\(-date_start.timeIntervalSinceNow)")
date_start = Date()
print(date_start)
print()
print("Goodbye.")
sleep(24*60*60)
