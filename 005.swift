


date_start = Date()

let bigNum = BigUInt.randomInteger(lessThan: BigUInt(256).power(65536))
let bytes  = bigNum.serialize().toArray(type: UInt8.self)
var stats: [[UInt8]] = Array(repeating: Array(repeating: 0x00, count: 256), count: 256)

for stride256 in stride(from: 0, to: 256, by: 1) {
    for iterator in 0..<256 {
        stats[stride256][Int(bytes[stride256 + iterator])] += 1
    }
}

for iter in 0..<stats.count {
    stats[iter].sort(by: >)
}
// print(stats)

var joined = Array(stats.joined() )
print(joined.sorted() )

print("\(-date_start.timeIntervalSinceNow) seconds")
print("Goodbye.")
sleep(300)
