//  main.swift
//  Y16F (Implmenting 'Gear Shift' Logic)
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

print("Hello, World!")

print("Init Random Data.......")
let bigNum  = BigUInt.randomInteger(withExactWidth: 1*3*1024*1024*8)
let bigData = bigNum.serialize().toArray(type: UInt8.self).chunked(into: 8192)
print("bigData.count:", bigData.count)
print("RNG CMPL [OK]")
print()

var date_start = Date()
print(date_start)

DispatchQueue.concurrentPerform(iterations: 1, execute: { indexGCD in
    var bulkLZMA: [UInt8] = [ ]         // Check compression type far below!
    // TODO: var bulkStatsX

    for o1 in 0..<bigData.count/1 {
        
        var bytesLZMA: [UInt8] = bigData[indexGCD*64 + o1]
        // var bytesLZFSE: [UInt8] = [ ]
        
        var stats: [[UInt8]] = Array(repeating:
                               Array(repeating: 0x00,
                                     count: 256),
                                     count: bytesLZMA.count/256)
        
        var statsX: [UInt8] = Array(repeating: 0x00, count: 256)
        
        let z256 = bytesLZMA.chunked(into: 256)
        
        for x in 0..<stats.count {
            for y in 0..<z256[x].count {
                stats[x][Int(z256[x][y])] += 1
            }
        }
        
        for x in 0..<stats.count {
            for y in 0..<stats[x].count {
                if (stats[x][y] > statsX[x]) {
                    statsX[y] += 1
                }
            }
        }
        
        var sum = 0
        for x in 0..<statsX.count {
            sum += Int(statsX[x])
        }
        
        print()
        print(statsX.count, sum, statsX.sorted().reversed() )
        
        let X7A = SDBX7__IN_PROGRESS__(pFreqStats: statsX)
        print("X7A:", X7A.bitWidth)
        
        // OFF:
        sleep(2)
        
        bytesLZMA.sort()
        // bytesLZFSE.sort()
        // print("LZMA:", bytesLZMA, "\nLZFSE:", bytesLZFSE)

        bulkLZMA.append(contentsOf: bytesLZMA)
        // bulkLZFSE.append(contentsOf: bytesLZFSE)
    }

    let compD = try! NSData(data: Data(fromArray: bulkLZMA)).compressed(using: .lzfse)
    print(compD.length, "< 147456") // , bulkLZMA.count)
    // let compM = try NSData(data: Data(fromArray: bulkLZFSE)).compressed(using: .lzfse)
    // print(compM.length, bulkLZMA.count )
})

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)

let fact8KB = factorial(8192)-1
print(fact8KB.bitWidth, 65536 - fact8KB.bitWidth)

print()
print("Power Method:")
for x in 140...256 {
    let y = BigUInt(x).power(256)-1
    print(x, y.bitWidth, 2048-y.bitWidth) // , y)
}

print()
print("SemiFactorial Method: 5")
for x in 140...256 {
    let y = SDBX4(from: UInt(x), count: 256, pattern: 5)
    print(x, y.bitWidth, 2048-y.bitWidth) // , y)
}

print()
print("SemiFactorial Method: 4")
for x in 140...256 {
    let y = SDBX4(from: UInt(x), count: 256, pattern: 4)
    print(x, y.bitWidth, 2048-y.bitWidth) // , y)
}

print()
print("SemiFactorial Method: 3")
for x in 140...256 {
    let y = SDBX4(from: UInt(x), count: 256, pattern: 3)
    print(x, y.bitWidth, 2048-y.bitWidth) // , y)
}

print()
print("SemiFactorial Method: 2")
for x in 140...256 {
    let y = SDBX4(from: UInt(x), count: 256, pattern: 2)
    print(x, y.bitWidth, 2048-y.bitWidth) // , y)
}

print()
print("SemiFactorial Method: 1")
for x in 140...256 {
    let y = SDBX4(from: UInt(x), count: 256, pattern: 1)
    print(x, y.bitWidth, 2048-y.bitWidth) // , y)
}

print("Goodbye.")
sleep(24*60*60)
