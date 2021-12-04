//  main.swift
//  R4: Make Difficult
//  'Mark IX.E'
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

let DIFFICULTY = 127            // Warning Use: ~161 to 186 only!
let THREAD_COUNT = 8         // Use 4-256 (or more if you have the RAM)
let MACRO_BLOCK_SIZE = 2*1024*1024/256
print("DIFFICULTY      :", DIFFICULTY)
print("THREAD_COUNT    :", THREAD_COUNT)
print("MACRO_BLOCK_SIZE:", MACRO_BLOCK_SIZE)

print("Hello, World!")

print("Init Random Data.......")
let bigNum  = BigUInt.randomInteger(withExactWidth: THREAD_COUNT*MACRO_BLOCK_SIZE*256*8)
let bigData = bigNum.serialize().toArray(type: UInt8.self).chunked(into: 256)
print("bigData.count:", bigData.count)
print("RNG CMPL [OK]")

var date_start = Date()
print(date_start)

DispatchQueue.concurrentPerform(iterations: THREAD_COUNT, execute: { indexGCD in
    var bulkStats: [UInt8] = [ ]

    var difficultCount = 0
    var VIPs: [UInt8] = [ ]

    for _1MB_LOOP_ in 0..<MACRO_BLOCK_SIZE {
        // let bigNum = BigUInt.randomInteger(withExactWidth: 256*8)
        // bigData.subdata(in: (8*1024*1024*indexGCD)..<(8*1024*1024*indexGCD+(8*1024*1024)))
        var data: [UInt8] = [ ]
        data.append(contentsOf: bigData[indexGCD * MACRO_BLOCK_SIZE + _1MB_LOOP_])
        // print(" *: data.count   :", data.count)
        // print(" *: bigData.count:", bigData.count)
        
        var stats: [UInt8] = Array(repeating: 0x00, count: 256)
        // var dataUInt8: [UInt8] = [ ]
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
            // dataUInt8 = data // TODO: .toArray(type: UInt8.self)
            data.sort()
            // TODO: print("*:", uniqueValues)
            for i in 0..<16 {
                for j in 0..<16 {
                    if (data[i*16+j] > first160UniqueValues.last!) {
                        // TODO: print(dataUInt8[i*16+j], terminator: ", ")
                        VIPs_Small.append(data[i*16+j])
                        // if (j==15) { print() }
                    }
                }
            }
            if (VIPs_Small.count >= 1) {
                // If the count is 1 then only use the next value
                VIPs_Small.insert(UInt8(VIPs_Small.count), at: 0)
                VIPs.append(contentsOf: VIPs_Small)
            } else {
                // Otherwise append 0 to indicate that certain work is not required
                VIPs.append(0x00)
            }
        }
        stats.sort()
        bulkStats.append(contentsOf: stats)
    }
    // print()
    // print()
    print("difficultCount:", difficultCount)

    let compVIPs = try! NSData(data: Data(fromArray: VIPs)).compressed(using: .lzfse)
    print(compVIPs.length, VIPs.count, VIPs.first, VIPs.last)

    // TODO: Re-enable this BulkStats Compression
    // let comp = try! NSData(data: Data(fromArray: bulkStats)).compressed(using: .lz4)
    // print(comp.length, bulkStats.count, bulkStats.first!, bulkStats.last!)
})

print()

let fact4096 = factorial(4096)
print("fact4096.bits:", fact4096.bitWidth)

let fact160 = factorial(160)
print("fact160.bits:", fact160.bitWidth)

print()

print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)
// print()
print("Goodbye.")
sleep(24*60*60)
