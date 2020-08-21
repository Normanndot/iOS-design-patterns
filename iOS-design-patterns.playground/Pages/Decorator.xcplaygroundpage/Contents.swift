import Foundation

class Bird
{
  var age = 0

  func fly() -> String
  {
    return (age < 10) ? "flying" : "too old"
  }
}

class Lizard
{
  var age = 0

  func crawl() -> String
  {
    return (age > 1) ? "crawling" : "too young"
  }
}

class Dragon
{
  private var _age = 0
  private let bird = Bird()
  private let lizard = Lizard()

  var age: Int
  {
    get { return _age }
    set(value)
    {
      lizard.age = value
      bird.age = value
      _age = value
    }
  }

  func fly() -> String { return bird.fly() }
  func crawl() -> String { return lizard.crawl() }
}
