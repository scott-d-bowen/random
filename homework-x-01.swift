//  main.swift
//  R4: Make Difficult
//  'Mark IX.K'
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

let DIFFICULTY = 127         // Warning Use: ~161 to 186 only!
let THREAD_COUNT = 16        // Use 4-256 (or more if you have the RAM)
let MACRO_BLOCK_SIZE = 1*1440*1024/256
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
    var VIPsValues: [UInt8] = [ ]
    var VIPsOffset: [UInt8] = [ ]
    var VIPs_SmallValues_Count: UInt = 0

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
        var VIPs_SmallValues: [UInt8] = [ ]
        var VIPs_SmallOffset: [UInt8] = [ ]

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
        // OFF: print("first160UniqueValues:", first160UniqueValues.count)
        
        if (uniqueValues >= DIFFICULTY) {
            // TODO: print("C:", first160UniqueValues.count)
            difficultCount += 1
            // dataUInt8 = data // TODO: .toArray(type: UInt8.self)
            // data.sort()      // TODO: Trying without sorting 'data' to get accurate offset/position data
            // TODO:
            // OFF: print("*:", uniqueValues)
            for i in 0..<16 {
                for j in 0..<16 {
                    if (data[i*16+j] > first160UniqueValues.last!) {
                        // TODO: print(dataUInt8[i*16+j], terminator: ", ")
                        VIPs_SmallValues.append(data[i*16+j])
                        // if (j==15) { print() }
                        
                        // TODO: TESTING INCLUSION OF OFFSET/POSITION DATA: 'IX.F'
                        VIPs_SmallOffset.append(UInt8(i*16+j))
                    }
                }
            }
            if (VIPs_SmallValues.count >= 1) {
                // If the count is 1 then only use the next value
                VIPs_SmallValues_Count += UInt(VIPs_SmallValues.count)
                VIPs_SmallValues.insert(UInt8(VIPs_SmallValues.count), at: 0)
                VIPs_SmallOffset.insert(UInt8(VIPs_SmallOffset.count), at: 0)
                VIPsValues.append(contentsOf: VIPs_SmallValues)
                VIPsOffset.append(contentsOf: VIPs_SmallOffset)
                // OFF:
                // print(uniqueValues, VIPs_Small)
            } else {
                // Otherwise append 0 to indicate that certain work is not required
                VIPsValues.append(0x00)
                VIPsOffset.append(0x00)
            }
        }
        // TODO: Re-enable this BulkStats Compression
        // stats.sort()
        // bulkStats.append(contentsOf: stats)
    }
    // print()
    // print()
    print("difficultCount:", difficultCount)
    print("VIPs_SmallValues_Count:", VIPs_SmallValues_Count)

    let compVIPsValues = try! NSData(data: Data(fromArray: VIPsValues)).compressed(using: .lzma)
    // OFF: print("VAL:", compVIPsValues.length, "; " , VIPsValues.count, "; " , VIPsValues.first!, "; " , VIPsValues.last!)
    
    let compVIPsOffset = try! NSData(data: Data(fromArray: VIPsOffset)).compressed(using: .lzma)
    // OFF: print("POS:", compVIPsOffset.length, "; " , VIPsOffset.count, "; " , VIPsOffset.first!, "; " , VIPsOffset.last!)

    // TODO: Re-enable this BulkStats Compression
    // let comp = try! NSData(data: Data(fromArray: bulkStats)).compressed(using: .lz4)
    // print(comp.length, bulkStats.count, bulkStats.first!, bulkStats.last!)
})

print()

let fact4096 = factorial(4096)
print("fact4096.bits:", fact4096.bitWidth)

let fact160 = factorial(160)
print("fact160.bits:", fact160.bitWidth)

let fact96 = factorial(96)
print("fact96.bits:", fact96.bitWidth)

let fact70 = factorial(70)
print("fact70.bits:", fact70.bitWidth)

let base6pow256 = BigUInt(6).power(256)
print("base6pow256:", base6pow256.bitWidth, base6pow256)

let base7pow256 = BigUInt(7).power(256)
print("base7pow256:", base7pow256.bitWidth, base7pow256)

print()

print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print()
print(date_start)

for x in 0...256+16 {
    let factX = factorial(UInt16(x))
    // print(x, factX.bitWidth, factX.hashValue, factX)
    let hash = String(format:"%08x", factX.hashValue)
    print("\(x), \(factX.bitWidth), 0x\(hash)")
}

print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)
print("Goodbye.")
sleep(24*60*60)
