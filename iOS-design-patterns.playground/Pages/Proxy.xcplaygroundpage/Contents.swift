import Foundation

class Person
{
  var age: Int = 0

  func drink() -> String
  {
    return "drinking"
  }

  func drive() -> String
  {
    return "driving"
  }

  func drinkAndDrive() -> String
  {
    return "driving while drunk"
  }
}

class ResponsiblePerson
{
  private let person: Person

  init(person: Person)
  {
    self.person = person
  }

  var age: Int
  {
    get { return person.age }
    set(value) { person.age = value }
  }

  func drink() -> String
  {
    return (age >= 18) ? person.drink() : "too young"
  }

  func drive() -> String
  {
    return (age >= 16) ? person.drive() : "too young"
  }

  func drinkAndDrive() -> String
  {
    return "dead"
  }
}

