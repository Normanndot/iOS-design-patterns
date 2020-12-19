//: [Previous](@previous)

import Foundation

protocol Invocable: class {
    func invoke(_ data: Any)
}

protocol Disposable {
    func dispose()
}

class Event<T> {
    typealias EventHandler = (T) -> ()
    var eventHandlers = [Invocable]()

    func raise(_ data: T) {
        for handler in eventHandlers {
            handler.invoke(data)
        }
    }

    func addHandler<U: AnyObject>(target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let subscroption = Subscription(target: target, handler: handler, event: self)
        eventHandlers.append(subscroption)
        return subscroption
    }
}

class Subscription<T: AnyObject, U>: Invocable, Disposable {

    weak var target: T?
    let handler: (T) -> (U) -> ()
    let event: Event<U>

    init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
        self.target = target
        self.handler = handler
        self.event = event
    }

    func invoke(_ data: Any) {
        if let t = target {
            handler(t)(data as! U)
        }
    }

    func dispose() {
        event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
    }

}

class Demo {
    init() {
        let p = Person()
        let sub = p.fallsIll.addHandler(target: self, handler: Demo.callDoctor)
        p.catchCold()
        sub.dispose()
        p.catchCold()
    }

    func callDoctor(address: String) {
        print(address)
    }
}
class Person {
    let fallsIll = Event<String>()
    init() {

    }

    func catchCold() {
        fallsIll.raise("Call doctor")
    }
}

Demo()
