//  main.swift
//  Y16L (Implmenting 'Advanced Gear Shift' Logic)
//  Created by Scott Bowen

import Foundation
import BigInt
import Compression

let THREADPOOL_COUNT = 10_406 // 128
let MACRO_BLOCK_SIZE = 1*64*1024

print("Hello, World!")

print("Init Random Data.......")
let bigNum  = BigUInt.randomInteger(withExactWidth: THREADPOOL_COUNT*MACRO_BLOCK_SIZE*8)
let bigData = bigNum.serialize().toArray(type: UInt8.self).chunked(into: 256)
print("bigData.count:", bigData.count)
print("RNG CMPL [OK]")
for c in 1...10 {
    sleep(1)
    print("\(c)", terminator: ", ")
}
print()

var date_start = Date()
print(date_start)

DispatchQueue.concurrentPerform(iterations: THREADPOOL_COUNT, execute: { indexGCD in
    
    if (indexGCD < bigData.count) {
    
        var bulkLZMA: [UInt8] = [ ]         // Check compression type far below!
        var bulkStatsY: [UInt8] = [ ]
        var bulkStatsX: [UInt8] = [ ]
        var bulkStatsZ: [UInt8] = [ ]

        for o1 in 0..<bigData.count/THREADPOOL_COUNT {
            
            // OFF: print("GCD Thread:", indexGCD, "o1", o1)
            
            var bytesLZMA: [UInt8] = bigData[indexGCD * (bigData.count/THREADPOOL_COUNT) + o1]
            // [indexGCD*THREADPOOL_COUNT + o1]
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
            
            for x in 0..<stats.count {
                // bulkStatsY.append(contentsOf: stats[x])
                // Disabled:
                let X7SZ = SDBX7__IN_PROGRESS__(pFreqStats: stats[x])
                let leng: [UInt8] = [ UInt8(X7SZ.serialize().count) ]
                bulkStatsZ.append(contentsOf: leng)
                bulkStatsZ.append(contentsOf: X7SZ.serialize() )
                // OFF:
                // print("X7SZ:", X7SZ.bitWidth, "bits")
            }
            
            var sum = 0
            for x in 0..<statsX.count {
                sum += Int(statsX[x])
            }
            
            bulkStatsX.append(contentsOf: statsX) // .sorted().reversed() ) // I think...
            
            // OFF: print()
            // print(statsX.count, sum, statsX.sorted().reversed() )
            
            // Disabled:
            // let X7A = SDBX7__IN_PROGRESS__(pFreqStats: statsX)
            // OK: "X7A: 1684" = print("X7A:", X7A.bitWidth)
            // OFF: print("X7A:", X7A.bitWidth, "bits")
            
            // OFF:
            // sleep(2)
            
            bytesLZMA.sort()
            // bytesLZFSE.sort()
            // print("LZMA:", bytesLZMA, "\nLZFSE:", bytesLZFSE)

            bulkLZMA.append(contentsOf: bytesLZMA)
            // bulkLZFSE.append(contentsOf: bytesLZFSE)
        }

        // Disabled:
        // let compRNG = try! NSData(data: Data(fromArray: bulkLZMA)).compressed(using: .lzma)
        // print(compRNG.length, "< 147456") // , bulkLZMA.count)
        
        // let compSX = try! NSData(data: Data(fromArray: bulkStatsX)).compressed(using: .lzma)
        // print(compSX.length, "< SX", "count:", bulkStatsX.count)
        
        // LZMA HEADER DISCOVERY:
        //let compNIL = try! NSData(data: Data() ).compressed(using: .lzma)
        //print(compNIL.length, "< NIL", "count:", Data().count)
        
        let compSZ = try! NSData(data: Data(fromArray: bulkStatsZ)).compressed(using: .lzma)
        print(indexGCD, ";", compSZ.length-32, ";", "< SZ (-32 bytes for fixed LZMA header)", ";", "count:", ";", bulkStatsZ.count)
        
        func createFile() {
            let url = URL(fileURLWithPath: "/Users/sdb/Y16_X7SZ_TestData_\(indexGCD).bin")
            let data = Data(bulkStatsZ)
            try! Data(data).write(to: url)
        }
        createFile()
    }
})

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)

let fact8KB = factorial(8192)-1
print(fact8KB.bitWidth, 65536 - fact8KB.bitWidth)

func PowerMethod() {
    print()
    print("Power Method:")
    for x in 140...256 {
        let y = BigUInt(x).power(256)-1
        print(x, y.bitWidth, 2048-y.bitWidth) // , y)
    }
}

func SemiFactorials() {
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
}

let _10pow82 = BigUInt(10).power(82)
let _256pow256 = BigUInt(256).power(256)

print(_10pow82)
print(_256pow256)

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
print()
print("Testing old school code:")
date_start = Date()
print(date_start)

print("Init Factorial HashMap")
INIT_FACTORIALS()
print("Factorial HashMap Init [OK]")

func OLD_SCHOOL() {
    DispatchQueue.concurrentPerform(iterations: THREADPOOL_COUNT, execute: { indexGCD in
        for i in 0..<bigData.count/THREADPOOL_COUNT {
            let rng256 = bigData[indexGCD * (bigData.count/THREADPOOL_COUNT) + i]
            let compFact = compressedFactoradic(inputArray: rng256)
            // OFF: print("OLD_SCHOOL:", indexGCD, compFact.bitWidth, compFact.hashValue) // , compFact)
        }
    })
}
OLD_SCHOOL()
print("factorialHashMapCounter:", factorialHashMapCounter)

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")
date_start = Date()
print(date_start)

print("Goodbye.")
sleep(24*60*60)
