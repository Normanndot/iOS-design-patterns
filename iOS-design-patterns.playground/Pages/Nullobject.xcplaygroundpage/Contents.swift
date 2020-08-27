import Foundation

protocol Log
{
    var recordLimit: Int { get }
    var recordCount: Int { get set }
    func logInfo(_ message: String)
}

enum LogError : Error
{
    case recordNotUpdated
    case logSpaceExceeded
}

class Account
{
    private var log: Log
    
    init(_ log: Log)
    {
        self.log = log
    }
    
    func someOperation() throws
    {
        let c = log.recordCount
        log.logInfo("Performing an operation")
        if (c+1) != log.recordCount
        {
            throw LogError.recordNotUpdated
        }
        if log.recordCount >= log.recordLimit
        {
            throw LogError.logSpaceExceeded
        }
    }
}

class NullLog : Log
{
    var recordLimit: Int
    {
        return Int.max
    }
    var recordCount: Int = Int.min
    func logInfo(_ message: String)
    {
        recordCount += 1
    }
}



import Foundation

protocol Logger
{
    func info(_ msg: String)
    func warn(_ msg: String)
}

class ConsoleLog : Logger
{
    func info(_ msg: String)
    {
        print(msg)
    }
    
    func warn(_ msg: String)
    {
        print("WARNING: \(msg)")
    }
}

class BankAccount
{
    var log: Logger
    var balance = 0
    
    init(_ log: Logger)
    {
        self.log = log
    }
    
    func deposit(_ amount: Int)
    {
        balance += amount
        // check for null everywhere?
        log.info("Deposited \(amount), balance is now \(balance)")
    }
    
    func withdraw(_ amount: Int)
    {
        if (balance >= amount)
        {
            balance -= amount
            log.info("Withdrew \(amount), we have \(balance) left")
        }
        else
        {
            log.warn("Could not withdraw \(amount) because balance is only \(balance)")
        }
    }
}

class NullLogger : Logger
{
    func info(_ msg: String) {}
    func warn(_ msg: String) {}
}

func main()
{
    //let log = ConsoleLog()
    //let log = nil
    let log = NullLogger()
    let ba = BankAccount(log)
    ba.deposit(100)
    ba.withdraw(200)
}

main()
