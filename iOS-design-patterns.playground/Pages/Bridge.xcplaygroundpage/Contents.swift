import Foundation

protocol Renderer
{
  var whatToRenderAs: String { get }
}

class Shape : CustomStringConvertible
{
  private let renderer: Renderer

  init(_ renderer: Renderer)
  {
    self.renderer = renderer
  }

  var name: String = ""

  var description: String
  {
    return "Drawing \(name) as \(renderer.whatToRenderAs)"
  }
}

class Triangle : Shape
{
  override init(_ renderer: Renderer)
  {
    super.init(renderer)
    name = "Triangle"
  }
}

class Square : Shape
{
  override init(_ renderer: Renderer)
  {
    super.init(renderer)
    name = "Square"
  }
}

class RasterRenderer : Renderer
{
  var whatToRenderAs: String {
    return "pixels"
  }
}

class VectorRenderer : Renderer
{
  var whatToRenderAs: String
  {
    return "lines"
  }
}

func main()
{
  print(Square(VectorRenderer()).description == "Drawing Square as lines")
}

main()
