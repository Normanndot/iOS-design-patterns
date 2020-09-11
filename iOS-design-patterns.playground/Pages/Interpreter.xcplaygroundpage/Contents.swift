
import Foundation
import XCTest

extension String
{
  func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>]
  {
    var result: [Range<Index>] = []
    var start = startIndex
    while let range = range(of: string, options: options, range: start..<endIndex)
    {
      result.append(range)
      start = range.upperBound
    }
    return result
  }

  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }

  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }

  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    let myRange: ClosedRange = start...end
    return String(self[myRange])
  }
}

class ExpressionProcessor
{
  var variables = [Character:Int]()

  enum NextOp
  {
    case nothing
    case plus
    case minus
  }

  func calculate(_ expression: String) -> Int
  {
    var current = 0
    var nextOp = NextOp.nothing

    var parts = [String]()
    var buffer = ""

    // regex lookbehind in swift is broken, so we split the strings by hand
    for c in expression
    {
      buffer.append(c)
      if (c == "+" || c == "-")
      {
        parts.append(buffer)
        buffer = ""
      }
    }
    if !buffer.isEmpty { parts.append(buffer) }

    for part in parts
    {
      let noOp = part.split { ["+", "-"].contains(String($0)) }
      var value = 0
      let first = String(noOp[0])

      if let z = Int(first)
      {
        value = z
      }
      else if (first.utf8.count == 1 && variables[first[0]] != nil)
      {
        value = variables[first[0]]!
      }
      else
      {
        return 0
      }

      switch nextOp
      {
        case .nothing:
          current = value
        case .plus:
          current += value
        case .minus:
          current -= value
      }

      if part.hasSuffix("+")
      {
        nextOp = .plus
      }
      else if part.hasSuffix("-")
      {
        nextOp = .minus
      }
    }

    return current
  }
}


func main()
{
  let ep = ExpressionProcessor()
  ep.variables["x"] = 5

  print(1, ep.calculate("1"), "1 = 1")

  print(3, ep.calculate("1+2"), "1+2 = 3")

  print(6, ep.calculate("1+x"), "1+x = 6")

  print(0, ep.calculate("1+xy"), "1+xy = 0 since xy is undefined")
}

main()
