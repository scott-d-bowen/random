//  main.swift
//  RandomRandomRandom
//
//  Created by Scott D. Bowen

import Foundation
import BigInt
import Compression


date_start = Date()

// DispatchQueue.concurrentPerform(iterations: 10240) { indexGCD in
for _ in 0..<10240 {
    let bigNum = BigUInt.randomInteger(lessThan: BigUInt(256).power(65536))
    let bytes  = bigNum.serialize().toArray(type: UInt8.self)
    var stats: [[UInt8]] = Array(repeating: Array(repeating: 0x00, count: 256), count: 256)

    for stride256 in stride(from: 0, to: 256, by: 1) {
        for iterator in 0..<256 {
            stats[stride256][Int(bytes[iterator])] += 1
        }
    }

    for iter in 0..<stats.count {
        stats[iter].sort(by: >)
    }
    // print(stats)
    let joined = Array(stats.joined() )
    // print(joined.sorted() )

    var statsOnTheStats = Array(repeating: 0x00, count: 256)
    for iterator in 0..<joined.count {
        statsOnTheStats[Int(joined[iterator])] += 1
    }
    for c in 0...8 {
        print(statsOnTheStats[c], terminator: ";       ")
    }
    print()
}

print("\(-date_start.timeIntervalSinceNow) seconds")
print("Goodbye.")
sleep(300)
