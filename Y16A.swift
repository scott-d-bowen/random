//  main.swift
//  Y16A
//
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

print("Hello, World!")

print("Init Random Data.......")
let bigNum  = BigUInt.randomInteger(withExactWidth: 1*1440*1024*8)
let bigData = bigNum.serialize().toArray(type: UInt16.self).chunked(into: 256)
print("bigData.count:", bigData.count)
print("RNG CMPL [OK]")

var date_start = Date()
print(date_start)

var bulkD: [UInt8] = [ ]
var bulkM: [UInt8] = [ ]

for o1 in 0..<bigData.count {
    
    var div16: [UInt8] = [ ]
    var mod16: [UInt8] = [ ]
    
    for x in 0..<bigData[o1].count {
        div16.append(UInt8((bigData[o1][x]) / 256))
        mod16.append(UInt8((bigData[o1][x]) % 256))
    }
    
    div16.sort()
    mod16.sort()
    print("D:", div16, "\nM:", mod16)
    
    /* var div16m: [UInt8] = [ ]
    var mod16m: [UInt8] = [ ]
    
    for x in stride(from: 0, to: div16.count, by: +2) {
        div16m.append(div16[x]*16+div16[x+1])
        mod16m.append(mod16[x]*16+mod16[x+1])
    } */
    
    bulkD.append(contentsOf: div16)
    bulkM.append(contentsOf: mod16)
}

let compD = try NSData(data: Data(bulkD)).compressed(using: .lzma)
print(compD.length, bulkD.count)
let compM = try NSData(data: Data(bulkM)).compressed(using: .lzma)
print(compM.length, bulkD.count)

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)
print("Goodbye.")
sleep(24*60*60)
