//
//  SDBX.swift
//
//  Created by Scott Bowen
//

import Foundation
import BigInt

var booleanCounter: UInt64 = 0
var tooHardBasket:  UInt64 = 0

var factorialHashMap: [UInt32:BigUInt] = [:]
var factorialHashMapCounter: UInt = 0

func INIT_FACTORIALS() {
    for i: UInt32 in 0...255 {
        factorialHashMap[i] = factorial(i)
    }
    for i: UInt32 in 256...1024 {
       factorialHashMap[i] = factorial(i)
    }
}

// FACTORIAL (32-bit Unsigned)
func factorial(_ input: UInt32) -> BigUInt {
    if (input >= 256) {
        factorialHashMapCounter += 1
        if let retFact = factorialHashMap[input] {
            factorialHashMapCounter += 1
            return retFact
        } else {
            return input == 1 ? BigUInt(256) : BigUInt(256) * factorial(input - 1)
        }
    }
    else if (input >= 1 ) {
        if let retFact = factorialHashMap[input] {
            factorialHashMapCounter += 1
            return retFact
        } else {
            return input == 1 ? BigUInt(input) : BigUInt(input) * factorial(input - 1)
            // (1 ... n).map { BigUInt($0) }.reduce(BigUInt(1), *)
        }
    } else {
        return 1 // 0! == 1
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

// GETTING THERE! x.offset fixed to x.element
func SDBX7__IN_PROGRESS__(pFreqStats: [UInt8]) -> BigUInt {
    
    let freqStats = pFreqStats // .sorted().reversed() // BAD IDEA!?
    
    var minor4 = BigUInt(0) // was (1)
    var minor4array: [UInt32] = [ ]
    
    for (x) in freqStats.enumerated() {
        // for _ in 0..<freqStats[x] {
            // print(x, pattern)
        minor4array.append(UInt32(x.element))
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
    // print(" *X7:", minor4array.count, minor4array)
    // sleep(1)
    
    for x in 0..<minor4array.count {
        assert(minor4array[x] < 16, "Assertion Failed: minor4array[x] < 16")
        // if (minor4array[x] > 0) {
            // BAD: minor4 *= 16 * BigUInt( minor4array[x]+1 )
            minor4 = 16 * minor4 + BigUInt( minor4array[x] )
        // }
    }
    
    return (minor4) // not -1 anymore
}
func SDBX7B__IN_PROGRESS__(pFreqStats: [UInt8], pUniques: UInt16) -> BigUInt {
    
    let freqStats = pFreqStats // .sorted().reversed() // BAD IDEA!?
    
    var minor4 = BigUInt(1) // was (1)
    var minor4array: [UInt32] = [ ]
    
    for (x) in freqStats.enumerated() {
        // for _ in 0..<freqStats[x] {
            // print(x, pattern)
        minor4array.append(UInt32(x.element))
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
    // print(" *X7:", minor4array.count, minor4array)
    // sleep(1)
    
    for x in 0..<minor4array.count {
        assert(minor4array[x] < 16, "Assertion Failed: minor4array[x] < 16")
        // if (minor4array[x] > 0) {
            // BAD: minor4 *= 16 * BigUInt( minor4array[x]+1 )
        minor4 *= BigUInt(pUniques).power(Int(minor4array[x]))
        // }
    }
    
    return (minor4-1) // not -1 anymore?
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


// Convert Input Array into a Compressed Factoradic Representation
func compressedFactoradic(inputArray: [UInt8]) -> (BigUInt, [UInt8], [UInt8]) {
    
    var bigIntRep: BigUInt = 0
    var indexArray: [UInt8] = [ ]
    var valueArray: [UInt8] = [ ]
    
    for idx in 0..<inputArray.count {
        assert(inputArray[idx] >= idx ) // >= ???
        // print(inputArray[idx], idx, (inputArray[idx] >= idx) )
        if (inputArray[idx] < idx+12) {
            bigIntRep = bigIntRep + factorial(UInt32(idx+12)) * BigUInt(inputArray[idx])
        } else {
            booleanCounter += 1
            // print(inputArray[idx], terminator: "; ")
            indexArray.append(UInt8(idx))
            valueArray.append(inputArray[idx])
            valueArray.sort()
        }
    }
    print()
    print("idxLen:", indexArray.count, "valLen:", valueArray.count)
    
    bigIntRep = bigIntRep / factorial(12-1) // Try 15 (16-1) first!
    // bigIntRep = bigIntRep // Try 15 (16-1) first!
    
    return (bigIntRep, indexArray, valueArray);
}
func compressedFactoradic(inputArray: [UInt16]) -> (BigUInt) {
    
    var bigIntRep: BigUInt = 0
    for idx in 0..<inputArray.count {
        bigIntRep = bigIntRep + factorial(UInt32(idx)) * BigUInt(inputArray[idx])
    }
    
    return bigIntRep;
}
func getFactoradic(big: BigUInt) -> (array: [UInt], permutation: BigUInt) {
    
    var num = big
    
    var factoradic: [UInt] = [ ]
    var i: UInt = 1
    
    while (num != 0) {
        let (_, r) = num.quotientAndRemainder(dividingBy: BigUInt(i))
        factoradic.append(UInt(r));
        num = num / BigUInt(i);
        i += 1;
    }
    
    var bigIntRep: BigUInt = 0
    for idx in 0..<factoradic.count {
        bigIntRep = bigIntRep + factorial(UInt32(idx)) * BigUInt(factoradic[idx])
    }
    
    let tuple: ([UInt], BigUInt) = (factoradic.reversed(), bigIntRep )
    return tuple;
}
func getFactoradic(big: BigUInt, customCeilings: [UInt8]) -> (array: [UInt], permutation: BigUInt) {
    
    var num = big + 1
    // let customCeilings = customCeilings.reversed().map( {$0} )
    
    var factoradic: [UInt] = [ ]
    // var i: UInt = 1
    
    // while (num != 0) {
    for i in stride(from: 255, through: 0, by: -1) {
        let divisor = BigUInt(Int(customCeilings[Int(i)]) + Int(1))
        let (_, r) = num.quotientAndRemainder(dividingBy: divisor)
        // let (q, r) = num.quotientAndRemainder(dividingBy: getDivisor(customCeilings: customCeilings, quanity: UInt(i)))
        factoradic.append(UInt(r));
        num = num / divisor // q // - r // num / BigUInt(Int(customCeilings[Int(i)]) + Int(1));
        // i += 1;
    }
    
    // TODO: Finish the updated function
    var bigIntRep: BigUInt = 0
    for idx in 0..<factoradic.count {
        bigIntRep = bigIntRep + factorial(UInt32(idx)) * BigUInt(factoradic[idx])
    }
    
    let tuple: ([UInt], BigUInt) = (factoradic.reversed(), bigIntRep )
    return tuple;
}
func getDivisor(customCeilings: [UInt8], quanity: UInt) -> BigUInt {
    
    var retVal = BigUInt( customCeilings[0] )
    
    if (quanity > 1) {
        for x in 1..<quanity {
            retVal = retVal * BigUInt(customCeilings[Int(x)-1])
        }
    }
    
    return retVal
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


