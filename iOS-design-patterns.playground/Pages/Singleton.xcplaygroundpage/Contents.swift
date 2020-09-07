import Foundation

final class AClass {
    static let sharedInstance = AClass()
    
    private init() {}
}

let aValue = AClass.sharedInstance
let bValue = AClass.sharedInstance

print(aValue === bValue)
