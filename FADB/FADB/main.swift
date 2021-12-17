//
//  main.swift
//  FADB
//
//  Created by Scott Bowen on 15/12/2021.
//

import Foundation
import BigInt

print("Hello, World!")

INIT_FACTORIALS()
// Wrong scope: let randomData = BigUInt.randomInteger(withExactWidth: 1*1024*1024*8).serialize()

let date_start = Date()

var LENGTHS: [UInt16] = [ ]
var BULK_DATA: Data = Data()
var BULK_VOLU: Data = Data()

func tryPackedBits() {
    
    let randomData = BigUInt.randomInteger(withExactWidth: 1*1024*1024*8).serialize()
    let randomU8__ = randomData.toArray(type: UInt8.self).chunked(into: 256)
    
    for w in 0..<randomU8__.count {
        
        var outputBigN: BigUInt = BigUInt(1)
        
        var sdbx: SDBX = SDBX()
        var remainingValues: Set<UInt8> = Set(0x00...0xFF)

        for x in 0..<randomU8__[w].count {
            sdbx.addValue(value: randomU8__[w][x])
            remainingValues.remove(randomU8__[w][x])
        }
        BULK_VOLU.append(UInt8(remainingValues.count))
        // OFF: print(remainingValues.count, 256 - remainingValues.count)
        
        let usedValueCount = 256 - remainingValues.count
        let calibratedBigNum = factorial(UInt32(256 + remainingValues.count)) / factorial(UInt32(remainingValues.count))
        print("Calibrated :,", calibratedBigNum.bitWidth, 256 + remainingValues.count, remainingValues.count)
        
        var speculativeTestingArray: Set<UInt8> = Set(UInt8(remainingValues.count)...0xFF)
        // print(speculativeTestingArray.count, speculativeTestingArray)
        // sleep(3)
        
        for x in 0..<randomU8__[w].count {
            // var mul: BigUInt = BigUInt(1)
            if let val = speculativeTestingArray.remove(UInt8(x)) {
                if let mul = BigUInt(exactly: UInt32(val) + 1) {
                    // print(speculativeTestingArray.count, speculativeTestingArray)
                    outputBigN = outputBigN * mul + outputBigN
                } else {
                    let mul: BigUInt = 256
                    outputBigN = outputBigN * mul + outputBigN
                }
            } else {
                let mul: BigUInt = 256
                outputBigN = outputBigN * mul + outputBigN
            }
        }
        outputBigN -= 1
        // OFF: print(outputBigN.bitWidth)
        // OFF: sleep(3)
        
        /* if outputBigN.bitWidth < 256*8 {
            var shortBy = 256*8 - outputBigN.bitWidth
            shortBy /= 8
            for _ in 0..<shortBy {
                BULK_DATA.append(0x00)
            }
        } */
        BULK_DATA.append(outputBigN.serialize() )
        
        LENGTHS.append(UInt16(outputBigN.bitWidth / 8) - 1)
        print("Packed Bits:,", outputBigN.bitWidth, calibratedBigNum.bitWidth <= outputBigN.bitWidth ? true : false)
        // sleep(1)
        
    } // END: FOR LOOP[w]
    
} // END: tryPackedBits()

for _ in 1...16 {
    tryPackedBits()
}

print(BULK_DATA.count, LENGTHS.count)

let FILEX_URL = URL(fileURLWithPath: "/Users/sdb/TESTING/NEW/FADB-SDBX.data")
func createFileX() {
    let data = BULK_DATA
    try! Data(data).write(to: FILEX_URL)
    print("FADB-SDBX.data created?")
}
createFileX()

print("\(-date_start.timeIntervalSinceNow) seconds.")
print()

var compTest = NSData()

func compressionTest() {
    compTest = try! NSData(data: Data(fromArray: LENGTHS)).compressed(using: .lzfse)
    print(compTest.count - 12, LENGTHS.count)
    compTest = try! NSData(data: Data(fromArray: LENGTHS)).compressed(using: .lzma)
    print(compTest.count - 32, LENGTHS.count)
}
compressionTest()

let FILEY_URL = URL(fileURLWithPath: "/Users/sdb/TESTING/NEW/FADB-LENGTHS.data")
func createFileY() {
    let data = compTest
    try! Data(data).write(to: FILEY_URL)
    print("FADB-LENGTHS.data created?")
}
createFileY()

func compressionTest_Volumes() {
    compTest = try! NSData(data: Data(BULK_VOLU)).compressed(using: .lzfse)
    print(compTest.count - 12, BULK_VOLU.count)
    compTest = try! NSData(data: Data(BULK_VOLU)).compressed(using: .lzma)
    print(compTest.count - 32, BULK_VOLU.count)
}
compressionTest_Volumes()

let FILEZ_URL = URL(fileURLWithPath: "/Users/sdb/TESTING/NEW/FADB-VOLUMES.data")
func createFileZ() {
    let data = compTest
    try! Data(data).write(to: FILEZ_URL)
    print("FADB-VOLUMES.data created?")
}
createFileZ()

print("\(-date_start.timeIntervalSinceNow) seconds.")
print()

INIT_FACTORIALS()
// for f: UInt32 in 0..<1024*1024 {
//     print(f, factorial(f).bitWidth)
// }

print()
print("\(-date_start.timeIntervalSinceNow) seconds.")

print("Goodbye.")
sleep(24*60*60)
