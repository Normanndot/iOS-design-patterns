import Foundation
import XCTest

class BankAccount : CustomStringConvertible
{
  private var balance: Int = 0
  private let overdraftLimit = -500

  func deposit(_ amount: Int)
  {
    balance += amount
    print("Deposited \(amount), balance is now \(balance)")
  }

  func withdraw(_ amount: Int) -> Bool
  {
    if (balance - amount >= overdraftLimit)
    {
      balance -= amount
      print("Withdrew \(amount), balance is now \(balance)")
      return true
    }
    return false
  }

  var description: String
  {
    return "Balance: \(balance)"
  }
}

protocol BankCommand
{
  func call()
  func undo()
}

class BankAccountCommand : BankCommand
{
  private var account: BankAccount

  enum Action
  {
    case deposit
    case withdraw
  }

  private var action: Action
  private var amount: Int
  private var succeeded: Bool = false

  init(_ account: BankAccount, _ action: Action, _ amount: Int)
  {
    self.account = account
    self.action = action
    self.amount = amount
  }

  func call()
  {
    switch action
    {
      case .deposit:
        account.deposit(amount)
        succeeded = true
      case .withdraw:
        succeeded = account.withdraw(amount)
    }
  }

  func undo()
  {
    if !succeeded { return }

    // a rather bizarre way of doing things
    // not production code! :)
    switch action
    {
      case .deposit:
        account.withdraw(amount)
      case .withdraw:
        account.deposit(amount)
    }
  }
}

func mainBank()
{
  let ba = BankAccount()
  let commands = [
    BankAccountCommand(ba, .deposit, 100),
    BankAccountCommand(ba, .withdraw, 25) // try 1000
  ]

  print("Initial account: \(ba)")

  // apply each of the commands
  commands.forEach{ $0.call() }

  print("After commands applied: \(ba)")

  // undo commands in reverse order
  commands.reversed().forEach{ $0.undo() }

  print("After undo: \(ba)")
}

mainBank()

///////////////////////////////////////////////////////////////
import Foundation
import XCTest

class Command
{
  enum Action
  {
    case deposit
    case withdraw
  }

  var action: Action
  var amount: Int
  var success = false

  init(_ action: Action, _ amount: Int)
  {
    self.action = action
    self.amount = amount
  }
}

class Account
{
  var balance = 0

  func process(_ c: Command)
  {
    switch c.action
    {
      case .deposit:
        balance += c.amount
        c.success = true
      case .withdraw:
        c.success = (balance >= c.amount)
        if (c.success) { balance -= c.amount }
    }
  }
}

class UMBaseTestCase : XCTestCase {}

//@testable import Test

class Evaluate: UMBaseTestCase
{
  func simpleTest()
  {
    let a = Account()
    
    let deposit = Command(.deposit, 100)
    a.process(deposit)

    XCTAssertEqual(100, a.balance, "Expected the balance to rise to 100")
    XCTAssert(deposit.success, "A deposit should always succeed")

    let withdraw = Command(.withdraw, 50)
    a.process(withdraw)

    XCTAssertEqual(50, a.balance)
    XCTAssert(withdraw.success, "Withdrawal of 50 should have succeeded")

    let withdraw2 = Command(.withdraw, 100)
    a.process(withdraw2)

    XCTAssertEqual(50, a.balance, "After a failed withdrawal, balance should have stayed at exactly 50")
    XCTAssertFalse(withdraw2.success, "Attempted withdrawal should have failed")
  }
}

extension Evaluate
{
  static var allTests : [(String, (Evaluate) -> () throws -> Void)]
  {
    return [
      ("simpleTest", simpleTest)
    ]
  }
}

Evaluate.allTests
