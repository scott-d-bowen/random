//
//  SDBX.swift
//
//  Created by Scott Bowen
//

import Foundation
import BigInt

// FACTORIAL (32-bit Unsigned)
func factorial(_ input: UInt32) -> BigUInt {
    if (input >= 256) {
        return input == 1 ? BigUInt(256) : BigUInt(256) * factorial(input - 1)
    }
    else if (input >= 1 ) {
        return input == 1 ? BigUInt(input) : BigUInt(input) * factorial(input - 1)
        // (1 ... n).map { BigUInt($0) }.reduce(BigUInt(1), *)
    } else {
        return 0
    }
}

// PSUEDO-FACTORIAL
func psuedoFactorial(_ input: [Bool]) -> BigUInt {
    var retVal: BigUInt = 0
    var bitsSet: UInt8 = 0
    
    for iterator in 0..<input.count {
        if (input[iterator]) {
            bitsSet += 1
        }
    }
    /// print("bitsSet: \(bitsSet)", terminator: "; ")
    
    for iterator in 0..<input.count {
        if (input[iterator]) {
            retVal = (retVal+1) * BigUInt(iterator)
        }
    }
    
    //for iterator in 0..<(255-bitsSet) {
    //    retVal = retVal * (BigUInt(256) - BigUInt(iterator))
    //}
    /// print("bitsNSet: \(255-bitsSet+1)", terminator: "; ")
    
    /// print("bitsWide: \(retVal.bitWidth)")
    return retVal - 1
}

// PACK BITS
func packBits(_ input: [Bool]) -> BigUInt {
    var retVal: BigUInt = 0
    
    for iterator in 0..<input.count {
        if (input[iterator]) {
            retVal *= 2
            retVal += 1
        } else {
            retVal *= 2
        }
    }
    
    // TODO: print("  \(retVal.bitWidth)")
    return retVal
}

// IS BIT SET
func isBitSet(b: UInt8, pos: Int) -> Bool {
   return (b & (1 << pos)) != 0;
}

// C++ to SWIFT
func getSequenceId(array: [Bool]) -> UInt64 {
    
    var rank: UInt64 = 0
    var nck: UInt64 = 1
    var numones: UInt32 = 0
    
    for iter in 0..<array.count {
        if (array[iter]) {
            numones += 1;
            nck = (numones == iter) ? 1 : (nck * UInt64(iter) / UInt64(numones));
            rank += nck;
        } else {
            nck = UInt64((numones >= iter) ? 1 : Int(nck) * iter / (iter - Int(numones)));
        }
    }
    return rank;
}


func SDBX7__IN_PROGRESS__(pFreqStats: [UInt8]) -> BigUInt {
    
    let freqStats = pFreqStats.sorted().reversed()
    
    var minor4 = BigUInt(1)
    var minor4array: [UInt32] = [ ]
    
    for (x) in freqStats.enumerated() {
        // for _ in 0..<freqStats[x] {
            // print(x, pattern)
            minor4array.append(UInt32(x.offset))
            if (minor4array.count >= freqStats.count) {
                // print(minor4array.count, minor4array)
                break
            }
        // }
        if (minor4array.count >= freqStats.count) {
            // OFF: print(minor4array.count, minor4array)
            break
        }
    }
    // OK: 162;
    // print(" *:", minor4array.count, minor4array)
    for x in 0..<minor4array.count {
        minor4 *= BigUInt( minor4array[x]+1 )
    }
    
    return (minor4 - 1)
}



func SDBX4(from: UInt, count: UInt, pattern: UInt) -> BigUInt {
    var minor4 = BigUInt(1)
    var minor4array: [UInt32] = [ ]
    
    for x in stride(from: from, to: 0, by: -1) {
        for _ in 0..<pattern {
            // print(x, pattern)
            minor4array.append(UInt32(x))
            if (minor4array.count >= count) {
                // print(minor4array.count, minor4array)
                break
            }
        }
        if (minor4array.count >= count) {
            // OFF: print(minor4array.count, minor4array)
            break
        }
    }
    // OK: 162;
    // print(" *:", minor4array.count, minor4array)
    for x in 0..<minor4array.count {
        minor4 *= BigUInt( minor4array[x] )
    }
    
    return (minor4 - 1)
}



func SDBX5A(freqStats: [UInt8]) -> BigUInt {
    var bigNum: BigUInt = 1
    
    for x in 1...freqStats.count {
        let mul = BigUInt(x).power(Int(freqStats[x-1]))
        // OFF: print("mul:", mul)
        bigNum = bigNum * mul
    }
    
    return (bigNum - 1)
}






extension Data {
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count:
        values.count)) }

    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
           [T](UnsafeBufferPointer(start: $0, count:
            self.count/MemoryLayout<T>.stride))
        }
    }
}



extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


