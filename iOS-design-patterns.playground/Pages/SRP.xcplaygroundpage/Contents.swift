import Foundation

class Article : CustomStringConvertible
{
  var entries = [String]()
  var count = 0

  func addEntry(_ text: String) -> Int
  {
    count += 1
    entries.append("\(count): \(text)")
    return count - 1
  }

  func removeEntry(_ index: Int)
  {
    entries.remove(at: index)
  }

  var description: String
  {
    return entries.joined(separator: "\n")
  }

  func save(_ filename: String, _ overwrite: Bool = false)
  {
    // save to a file
  }
}

class Persistence
{
  func saveToFile(_ journal: Article, filename: String, _ overwrite: Bool = false)
  {
    
  }
}

