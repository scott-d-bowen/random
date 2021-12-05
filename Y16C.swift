//  main.swift
//  Y16C (85-88 bits)
//
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

print("Hello, World!")

print("Init Random Data.......")
let bigNum  = BigUInt.randomInteger(withExactWidth: 3*1024*1024*8)
let bigData = bigNum.serialize().toArray(type: UInt8.self).chunked(into: 8192)
print("bigData.count:", bigData.count)
print("RNG CMPL [OK]")
print()

var date_start = Date()
print(date_start)

var bulkLZMA: [UInt8] = [ ]
// var bulkLZFSE: [UInt8] = [ ]

for o1 in 0..<bigData.count {
    
    var bytesLZMA: [UInt8] = [ ]
    // var bytesLZFSE: [UInt8] = [ ]
    
    for x in 0..<bigData[o1].count {
        bytesLZMA.append(bigData[o1][x])
        // bytesLZFSE.append(bigData[o1][x])
    }
    
    bytesLZMA.sort()
    // bytesLZFSE.sort()
    // print("LZMA:", bytesLZMA, "\nLZFSE:", bytesLZFSE)

    bulkLZMA.append(contentsOf: bytesLZMA)
    // bulkLZFSE.append(contentsOf: bytesLZFSE)
}

let compD = try NSData(data: Data(fromArray: bulkLZMA)).compressed(using: .lzma)
print(compD.length, "< 147456") // Int(Float80(compD.length)/3/1024/1024*256*8) )
// let compM = try NSData(data: Data(fromArray: bulkLZFSE)).compressed(using: .lzfse)
// print(compM.length, bulkLZMA.count )

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)

// let fact8KB = factorial(8192)-1
// print(fact8KB, fact8KB.bitWidth)

print("Goodbye.")
sleep(24*60*60)
