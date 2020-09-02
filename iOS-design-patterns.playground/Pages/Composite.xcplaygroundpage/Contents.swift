import Foundation

class SingleValue : Sequence
{
  var value = 0

  init() {}
  init(_ value: Int)
  {
    self.value = value
  }

  func makeIterator() -> IndexingIterator<Array<Int>>
  {
    return IndexingIterator(_elements: [value])
  }
}

class ManyValues : Sequence
{
  var values = [Int]()

  func makeIterator() -> IndexingIterator<Array<Int>>
  {
    return IndexingIterator(_elements: values)
  }

  func add(_ value: Int)
  {
    values.append(value)
  }
}

extension Sequence where Iterator.Element : Sequence,
  Iterator.Element.Iterator.Element == Int
{
  func sum() -> Int
  {
    var result = 0
    for c in self
    {
      for i in c
      {
        result += i
      }
    }
    return result
  }
}


////////////////////////////////////////////////////////////////////////////////
class GraphicObject : CustomStringConvertible
{
  var name: String = "Group"
  var color: String = ""

  var children = [GraphicObject]()

  init()
  {

  }

  init(name: String)
  {
    self.name = name
  }

  private func print(buffer: inout String, depth: Int)
  {
    buffer.append(String(repeating: "*", count: depth))
    buffer.append(color.isEmpty ? "" : "\(color) ")
    buffer.append("\(name)\n")

    for child in children
    {
      child.print(buffer: &buffer, depth: depth+1)
    }
  }

  var description: String
  {
    var buffer = ""
    print(buffer: &buffer, depth: 0)
    return buffer
  }
}

class Circle : GraphicObject
{
  init(color: String)
  {
    super.init(name: "Circle")
    self.color = color
  }
}

class Square : GraphicObject
{
  init(color: String)
  {
    super.init(name: "Square")
    self.color = color
  }
}

func main()
{
  let drawing = GraphicObject(name: "My Drawing")
  drawing.children.append(Square(color: "Red"))
  drawing.children.append(Circle(color: "Yellow"))

  let group = GraphicObject()
  group.children.append(Circle(color: "Blue"))
  group.children.append(Square(color: "Blue"))

  drawing.children.append(group)

  print(drawing.description)
}

/////////////////////////////////////////////////////////
class Neuron : Sequence
{
  var inputs = [Neuron]()
  var outputs = [Neuron]()

  func makeIterator() -> IndexingIterator<Array<Neuron>>
  {
    return IndexingIterator(_elements: [self])
  }

  func connectTo(_ other: Neuron)
  {
    outputs.append(other)
    other.inputs.append(self)
  }
}

class NeuronLayer : Sequence
{
  private var neurons: [Neuron]

  init(count: Int)
  {
    neurons = [Neuron](repeating: Neuron(), count: count)
  }

  func makeIterator() -> IndexingIterator<Array<Neuron>>
  {
    return IndexingIterator(_elements: neurons)
  }
}

extension Sequence
{
  func connectTo<Seq: Sequence>(_ other: Seq)
    where Seq.Iterator.Element == Neuron,
    Self.Iterator.Element == Neuron
  {
    for from in self
    {
      for to in other
      {
        from.outputs.append(to)
        to.inputs.append(from)
      }
    }
  }
}

func composite()
{
  let neuron1 = Neuron()
  let neuron2 = Neuron()
  let layer1 = NeuronLayer(count: 10)
  let layer2 = NeuronLayer(count: 20)

  neuron1.connectTo(neuron2)
  neuron1.connectTo(layer1)
  layer2.connectTo(neuron1)
  layer1.connectTo(layer2)
}

composite()
