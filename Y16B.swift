//  main.swift
//  Y16B
//
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

print("Hello, World!")

print("Init Random Data.......")
let bigNum  = BigUInt.randomInteger(withExactWidth: 1*1440*1024*8)
let bigData = bigNum.serialize().toArray(type: UInt16.self).chunked(into: 131072)
print("bigData.count:", bigData.count)
print("RNG CMPL [OK]")

var date_start = Date()
print(date_start)

var bulkLZMA: [UInt16] = [ ]
var bulkLZFSE: [UInt16] = [ ]

for o1 in 0..<bigData.count {
    
    var bytesLZMA: [UInt16] = [ ]
    var bytesLZFSE: [UInt16] = [ ]
    
    for x in 0..<bigData[o1].count {
        bytesLZMA.append(bigData[o1][x])
        bytesLZFSE.append(bigData[o1][x])
    }
    
    bytesLZMA.sort()
    bytesLZFSE.sort()
    // print("LZMA:", bytesLZMA, "\nLZFSE:", bytesLZFSE)

    bulkLZMA.append(contentsOf: bytesLZMA)
    bulkLZFSE.append(contentsOf: bytesLZFSE)
}

let compD = try NSData(data: Data(fromArray: bulkLZMA)).compressed(using: .lzma)
print(compD.length, bulkLZMA.count * 2)
let compM = try NSData(data: Data(fromArray: bulkLZFSE)).compressed(using: .lzfse)
print(compM.length, bulkLZMA.count * 2)

let fact128KB = factorial(131072)
print(fact128KB, fact128KB.bitWidth)

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)
print("Goodbye.")
sleep(24*60*60)
