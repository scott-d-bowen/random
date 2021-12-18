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
var BULK_DATA_GLOBAL: Data = Data()
var BULK_VOLU: Data = Data()

func tryPackedBits(iterations: UInt32) {
    
    var BULK_DATA: Data = Data()
    
    for iterCount in 1...iterations {
        
        func nested() {
            
            // Shadowing VARs for GCD (DispatchQueue)
            var LENGTHS: [UInt16] = [ ]
            var BULK_VOLU: Data = Data()
            
            var randomData: Data = Data()
            if BULK_DATA.isEmpty {
                randomData = BigUInt.randomInteger(withExactWidth: 1*512*1024*8).serialize()
            } else {
                randomData = BULK_DATA
            }
            let randomU8__ = randomData.toArray(type: UInt8.self).chunked(into: 256)
            BULK_DATA.removeAll(keepingCapacity: true)
            
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
                // OFF: print("Calibrated :,", calibratedBigNum.bitWidth, 256 + remainingValues.count, remainingValues.count)
                
                var speculativeTestingArray: Set<UInt8> = Set(UInt8(remainingValues.count)...0xFF)
                // print(speculativeTestingArray.count, speculativeTestingArray)
                // sleep(3)
                
                for x in 0..<randomU8__[w].count {
                    // var mul: BigUInt = BigUInt(1)
                    if let val = speculativeTestingArray.remove(UInt8(x)) {
                        if let mul = BigUInt(exactly: UInt32(val) + 1) {
                            // print(speculativeTestingArray.count, speculativeTestingArray)
                            outputBigN = outputBigN * mul + BigUInt(UInt32.random(in: UInt32(0)..<UInt32(x+1)))
                        } else {
                            let mul: BigUInt = 256
                            outputBigN = outputBigN * mul + BigUInt(UInt32.random(in: UInt32(0)..<UInt32(x+1)))
                        }
                    } else {
                        let mul: BigUInt = 256
                        outputBigN = outputBigN * mul + BigUInt(UInt32.random(in: UInt32(0)..<UInt32(x+1)))
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
                // BULK_DATA.append(Data(try! NSData(data: outputBigN.serialize() ).compressed(using: .lzma)))
                BULK_DATA.append(outputBigN.serialize() )
                
                LENGTHS.append(UInt16(outputBigN.bitWidth / 8) - 1)
                // OFF: print("Packed Bits:,", outputBigN.bitWidth, calibratedBigNum.bitWidth <= outputBigN.bitWidth ? true : false)
                // sleep(1)
                
            } // END: FOR LOOP[w]
        } // END: nested()
        nested()
        print("BULK_DATA SIZE:", BULK_DATA.count)
    }
    
} // END: tryPackedBits()

print()
print("\(-date_start.timeIntervalSinceNow) seconds. STARTING GCD TEST RUN.....")
DispatchQueue.concurrentPerform(iterations: 128, execute: {_ in
        
    // Shadowing VARs for GCD (DispatchQueue)
    tryPackedBits(iterations: 96)
    print(BULK_DATA_GLOBAL.count, LENGTHS.count)
})

print("\(-date_start.timeIntervalSinceNow) seconds for GCD TEST RUN.")
print()


let FILEX_URL = URL(fileURLWithPath: "/Users/sdb/TESTING/NEW/FADB-SDBX.data")
func createFileX() {
    let data = BULK_DATA_GLOBAL
    try! Data(data).write(to: FILEX_URL)
    print("FADB-SDBX.data created?")
}
createFileX()

print("\(-date_start.timeIntervalSinceNow) seconds.")
print()

var compLENG = NSData()
var compVOLU = NSData()

func compressionTest() {
    compLENG = try! NSData(data: Data(fromArray: LENGTHS)).compressed(using: .lzfse)
    print(compLENG.count - 12, LENGTHS.count)
    compLENG = try! NSData(data: Data(fromArray: LENGTHS)).compressed(using: .lzma) // .compressed(using: .lzma)
    print(compLENG.count - 32, LENGTHS.count)
}
compressionTest()

let FILEY_URL = URL(fileURLWithPath: "/Users/sdb/TESTING/NEW/FADB-LENGTHS.data")
func createFileY() {
    let data = compLENG
    try! Data(data).write(to: FILEY_URL)
    print("FADB-LENGTHS.data created?")
}
createFileY()

func compressionTest_Volumes() {
    compVOLU = try! NSData(data: Data(BULK_VOLU)).compressed(using: .lzfse)
    print(compVOLU.count - 12, BULK_VOLU.count)
    compVOLU = try! NSData(data: Data(BULK_VOLU)).compressed(using: .lzma) // .compressed(using: .lzma)
    print(compVOLU.count - 32, BULK_VOLU.count)
}
compressionTest_Volumes()

let FILEZ_URL = URL(fileURLWithPath: "/Users/sdb/TESTING/NEW/FADB-VOLUMES.data")
func createFileZ() throws {
    let data = Data(compVOLU)
    try Data(data).write(to: FILEZ_URL)
    print("FADB-VOLUMES.data created?")
}
try createFileZ()

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
