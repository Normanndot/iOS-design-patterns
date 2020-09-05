//: [Previous](@previous)

import Foundation

struct Coordinate {
    let value: (latitude: Double, longitude: Double)
}

let coordinates: [Coordinate] = [
    .init(value: (latitude: 40.4168,
                  longitude: 3.7038)),
    .init(value: (latitude: 51.5074,
                  longitude: 0.1278)),
    .init(value: (latitude: 81.434,
                  longitude: 32.1371))
]


coordinates.forEach { (coordinate) in
    switch coordinate.value {
    case let (latitude, longitude):
        if latitude == 40.4168 && longitude == 3.7038 {
            print("Found Madrid")
        } else if latitude == 51.5074 && longitude == 0.1278 {
            print("Found London")
        } else {
            print("Unknown coordinate")
        }
    }
}
