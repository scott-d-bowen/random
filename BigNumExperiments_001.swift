//  main.swift
//  BigNumExperiments #001: Proves that Compression of Random Data IS POSSIBLE!!
//  Created by Scott D. Bowen

import Foundation
import BigInt

print("Hello, World!")

var randomData = BigUInt.randomInteger(withExactWidth: (1*16*1024*1024*8)).serialize()
var randomBytes: [[UInt8]] = randomData.toArray(type: UInt8.self).chunked(into: 256)

let date_start = Date()

let THRESHOLD = 42

func gogogo(THRESHOLD: Int) {
    var lastTHRESHOLD: Set<UInt8> = Set(0x00...0xFF)
    var coordinateW: UInt16 = 0x0000
    var coordinateX: UInt8  = 0x00

    for w in 0..<randomBytes.count {
        for x in 0..<randomBytes[w].count {
            lastTHRESHOLD.remove(randomBytes[w][x])
            if (lastTHRESHOLD.count <= THRESHOLD) {
                coordinateW = UInt16(w)
                coordinateX = UInt8(x)
                print()
                print("======== For THRESHOLD: \(THRESHOLD) ========")
                print(coordinateW, coordinateX, lastTHRESHOLD.count)
                break
            }
        }
        if (lastTHRESHOLD.count <= THRESHOLD) {
            break
        }
    }

    let mergedCoord: Int32 = Int32(Int32(coordinateW) * Int32(65536)) + Int32(coordinateX)
    let powerTHRESHOLD = BigUInt(256 - THRESHOLD).power(Int(mergedCoord))

    let wx = THRESHOLD * 8 < 256 ? THRESHOLD * 8 : 256
    
    print("Offset       :", mergedCoord)
    print("Bits required:", powerTHRESHOLD.bitWidth)
    print("Plus WX bits :", wx)
    print("Equals:      :", powerTHRESHOLD.bitWidth + wx)
    print("In Bytes:    :", ((powerTHRESHOLD.bitWidth + wx) / 8), ((powerTHRESHOLD.bitWidth + wx) % 8))
    print("Saving of    :", mergedCoord - Int32((powerTHRESHOLD.bitWidth + wx) / 8))
}

for x in 0...256 {
    gogogo(THRESHOLD: x)
}


print()
print("\(-date_start.timeIntervalSinceNow) seconds.")

print("Goodbye.")
sleep(24*60*60)
