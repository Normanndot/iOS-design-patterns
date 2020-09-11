
///////////////////////////////////////////////////
import Foundation

class Point
{
  var x = 0
  var y = 0

  init() {}

  init(x: Int, y: Int)
  {
    self.x = x
    self.y = y
  }
}

class Line
{
  var start = Point()
  var end = Point()

  init(start: Point, end: Point)
  {
    self.start = start
    self.end = end
  }

  func deepCopy() -> Line
  {
    let newStart = Point(x: start.x, y: start.y)
    let newEnd = Point(x: end.x, y: end.y)
    return Line(start: newStart, end: newEnd)
  }
}


func main()
{
  let line1 = Line(
    start: Point(x: 3, y: 3),
    end: Point(x: 10, y: 10)
  )

  let line2 = line1.deepCopy()
  line1.start.x = 0
  line1.start.y = 0
  line1.end.x = 0
  line1.end.y = 0

  print(3, line2.start.x)
  print(3, line2.start.y)
  print(10, line2.end.x)
  print(10, line2.end.y)
}

main()
