//Chain of Responsibilities
import Foundation

class Creature
{
  let game: Game
  let baseAttack: Int
  let baseDefense: Int

  internal init(game: Game, baseAttack: Int, baseDefense: Int)
  {
    self.game = game
    self.baseAttack = baseAttack
    self.baseDefense = baseDefense
  }

  // the rest of the members are typically 'abstract'
  var attack: Int
  {
    get { return baseAttack }
  }

  var defense: Int
  {
    get { return baseDefense }
  }

  func query(_ source: AnyObject, _ sq: StatQuery) {}
}

class Goblin : Creature
{
  override func query(_ source: AnyObject, _ sq: StatQuery)
  {
    if (source === self)
    {
      switch sq.statistic
      {
        case .attack: sq.result += baseAttack
        case .defense: sq.result += baseDefense
      }
    }
    else
    {
      // a Goblin gets +1 def for every other goblin in play
      if (sq.statistic == .defense)
      {
        sq.result += 1
      }
    }
  }

  override var defense: Int
  {
    get {
      let q = StatQuery(.defense)
      for c in game.creatures
      {
        c.query(self, q)
      }
      return q.result
    }
  }

  override var attack: Int
  {
    get
    {
      let q = StatQuery(.attack)
      for c in game.creatures
      {
        c.query(self, q)
      }
      return q.result
    }
  }

  convenience init(game: Game)
  {
    self.init(game: game, baseAttack: 1, baseDefense: 1)
  }
}

class GoblinKing : Goblin
{
  init(game: Game)
  {
    super.init(game: game, baseAttack: 3, baseDefense: 3)
  }

  override func query(_ source: AnyObject, _ sq: StatQuery)
  {
    // gives every _other_ goblin +1 attack
    if (source !== self && sq.statistic == .attack)
    {
      sq.result += 1
    } else {
      // the king is also a goblin, so...
      super.query(source, sq)
    }
  }
}

enum Statistic
{
  case attack
  case defense
}

class StatQuery
{
  var statistic: Statistic
  var result: Int = 0

  init(_ statistic: Statistic)
  {
    self.statistic = statistic
  }
}

class Game
{
  var creatures = [Creature]()
}


func main()
{
    let game = Game()
    let goblin = Goblin(game: game)
    game.creatures.append(goblin)
    goblin.attack
    print("Expecting goblin attack to be = 1")
    goblin.defense
    print("Expecting goblin defense to be = 1")

    let goblin2 = Goblin(game: game)
    game.creatures.append(goblin2)
    goblin2.attack
    print("Expecting goblin attack to be = 1")
    goblin2.defense
    print("Expecting goblin defense to be = 2 (1 baseline, +1 from other goblin)")

    let goblin3 = GoblinKing(game: game)
    game.creatures.append(goblin3)
    goblin3.attack
    print("Expecting goblin attack to be = 2 (1 baseline, +1 from king)")
    goblin3.defense
    print("Expecting goblin defense to be = 3 (1 baseline, +1 from other goblin, +1 from king)")

}

main()
