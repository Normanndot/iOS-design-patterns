import Foundation

class Person
{
    var name: String
    var room: ChatRoom? = nil // not in a room
    private var chatLog = [String]()
    
    init(_ name: String)
    {
        self.name = name
    }
    
    func receive(sender: String, message: String)
    {
        let s = "\(sender): `\(message)`"
        print("[\(name)'s chat session] \(s)")
        chatLog.append(s)
    }
    
    func say(_ message: String)
    {
        room?.broadcast(sender: name, message: message)
    }
    
    func pm(to target: String, message: String)
    {
        room?.message(sender: name, destination: target, message: message)
    }
}

class ChatRoom
{
    private var people = [Person]()
    
    func broadcast(sender: String, message: String)
    {
        for p in people
        {
            if p.name != sender
            {
                p.receive(sender: sender, message: message)
            }
        }
    }
    
    func join(_ p: Person)
    {
        let joinMsg = "\(p.name) joins the chat"
        broadcast(sender: "room", message: joinMsg)
        p.room = self
        people.append(p)
    }
    
    func message(sender: String, destination: String, message: String)
    {
        people.first{ $0.name == destination}?.receive(sender: sender, message: message)
    }
}

let room = ChatRoom()

let john = Person("John")
let jane = Person("Jane")

room.join(john)
room.join(jane)

john.say("hi room")
jane.say("oh, hey john")

let simon = Person("Simon")
room.join(simon)
simon.say("hi everyone!")

jane.pm(to: "Simon", message: "glad you could join us!")






public protocol Disposable
{
    func dispose()
}

protocol Invocable : class
{
    func invoke(_ data: Any)
}

public class Event<T>
{
    public typealias EventHandler = (T) -> ()
    
    var eventHandlers = [Invocable]()
    
    public func raise(_ data: T)
    {
        for handler in self.eventHandlers
        {
            handler.invoke(data)
        }
    }
    
    public func addHandler<U: AnyObject>
        (target: U, handler: @escaping (U) -> EventHandler) -> Disposable
    {
        let subscription = Subscription(target: target, handler: handler, event: self)
        eventHandlers.append(subscription)
        return subscription
    }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
    weak var target: T?
    let handler: (T) -> (U) -> ()
    let event: Event<U>
    
    init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
    {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(_ data: Any) {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose()
    {
        event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
    }
}

class Participant
{
    private let mediator: Mediator
    var value = 0
    
    init(_ mediator: Mediator)
    {
        self.mediator = mediator
        mediator.alert.addHandler(
            target: self,
            handler: {
                (_) -> ((AnyObject, Int)) -> () in
                return self.alert
        }
        )
    }
    
    func alert(_ data: (AnyObject, Int))
    {
        if (data.0 !== self)
        {
            value += data.1
        }
    }
    
    func say(_ n: Int)
    {
        mediator.broadcast(self, n)
    }
}

class Mediator
{
    let alert = Event<(AnyObject, Int)>()
    
    func broadcast(_ sender: AnyObject, _ n: Int)
    {
        alert.raise((sender, n))
    }
}

let mediator = Mediator()
let p1 = Participant(mediator)
let p2 = Participant(mediator)
print(p1.value)
print(p2.value)
p1.say(2)
print(p1.value)
print(p2.value)
p2.say(4)
