import Foundation
import XCTest

class Sentence : CustomStringConvertible
{
  var words: [String]
  var tokens = [Int: WordToken]()

  init(_ plainText: String)
  {
    words = plainText.components(separatedBy: " ")
  }

  subscript(index: Int) -> WordToken
  {
    get
    {
      let wt = WordToken()
      tokens[index] = wt
      return tokens[index]!
    }
  }

  var description: String
  {
    var ws = [String]()
    for i in 0..<words.count
    {
      var w = words[i]
      if let item = tokens[i]
      {
        if (item.capitalize)
        {
          w = w.uppercased()
        }
      }
      ws.append(w)
    }
    return ws.joined(separator: " ")
  }

  class WordToken
  {
    var capitalize: Bool = false
    init(){}
    init(capitalize: Bool)
    {
      self.capitalize = capitalize
    }
  }
}

let s = Sentence("alpha beta gamma")
s[1].capitalize = true
print("alpha BETA gamma", s.description)


/////////////////////////////////////////////////////////////////////////////////////////////////
extension String {
    func substring(_ location: Int, _ length: Int) -> String? {
        guard self.count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: location + length)
        return substring(with: start..<end)
    }
}

class FormattedText: CustomStringConvertible
{
  private var text: String
  private var capitalize: [Bool]

  init(_ text: String)
  {
    self.text = text
    capitalize = [Bool](repeating: false, count: text.utf8.count)
  }
  
  func capitalize(_ start: Int, _ end: Int)
  {
    for i in start...end
    {
      capitalize[i] = true
    }
  }

  var description: String
  {
    var s = ""
    for i in 0..<text.utf8.count
    {
      let c = text.substring(i,1)!
      s += capitalize[i] ? c.capitalized : c
    }
    return s
  }
}

class BetterFormattedText: CustomStringConvertible
{
  private var text: String
  private var formatting = [TextRange]()

  init(_ text: String)
  {
    self.text = text
  }

  func getRange(_ start: Int, _ end: Int) -> TextRange
  {
    let range = TextRange(start, end)
    formatting.append(range)
    return range
  }

  var description: String
  {
    var s = ""
    for i in 0..<text.utf8.count
    {
      var c = text.substring(i, 1)!
      for range in formatting
      {
        if range.covers(i) && range.capitalize
        {
          c = c.capitalized
        }
      }
      s += c
    }
    return s
  }

  class TextRange
  {
    var start, end: Int
    var capitalize: Bool = false // bold, italic, etc

    init(_ start: Int, _ end: Int)
    {
      self.start = start
      self.end = end
    }

    func covers(_ position: Int) -> Bool
    {
      return position >= start && position <= end
    }
  }
}

func main()
{
  let ft = FormattedText("This is a brave new world")
  ft.capitalize(10,15)
  print(ft)

  let bft = BetterFormattedText("This is a brave new world")
  bft.getRange(10,15).capitalize = true
  print(bft)
}

main()


