import Foundation

class Person
{
  var id: Int
  var name: String

  init(called name: String, withId id: Int)
  {
    self.name = name
    self.id = id
  }
}

class PersonFactory
{
  private var id = 0

  func createPerson(name: String) -> Person
  {
    let p = Person(called: name, withId: id)
    id += 1
    return p
  }
}

func main()
{
    let pf = PersonFactory()

    let p1 = pf.createPerson(name: "Chris")
    let p2 = pf.createPerson(name: "Sarah")
    print(p1.name)
    print(p2.name)
}

main()
