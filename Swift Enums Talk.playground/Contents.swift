/*:
# Swift Enumerations

Enumeration defines common type for a group of related values.
Enums create types with finite number of states and associated values.
*/
import UIKit
import Foundation
//: ## Basic enums
//: Basic enum definition syntax is:
enum Fruit {
    case apple
    case pear
    case pineapple
}
//: Also we can define it in one line separating with commas:
enum Tree {
    case poplar, pine, birch
}
//: ### Usage
//: We can assing a value to a variable, type inference gives us confidence that aFruit is of type Fruit:
let aFruit = Fruit.apple
//: As with other types, we can omit type when assigning a value if variable type is known:
let aFruit2: Fruit
aFruit2 = .pear
print(aFruit)
//: Then we check what exact value the variable contains.
//: Using good old switch statement:
switch aFruit {
  case .apple: print("Apple!")
  case .pear: print("Pear?")
  case .pineapple: print("Pine! Apple?")
}
//: Compiler helps up in a way that we don't have to add default case as we have all possible values of Fruit type here in the switch. If we remove one or more case from the switch, we would require a default case.
//: Next, we can use if expression if we care about only one specific value:
if aFruit == .apple {
    print("Still an apple")
}
//: Also there is if-case expression that works the same as above in this simple case:
if case .apple = aFruit {
    print("If-Case: We got an apple!")
} else {
    // The same as default case in switch
    print("If-Case: Not an apple.")
}
//: When creating an array, we can use short form of an enum cases:
var fruits: [Fruit] = [.pear, .pear, .pear, .apple]

//: We can use while-case if we wait for a state of a variable to change
var anotherFruit: Fruit = .pear
//: Here we check for a value of anotherFruit and do some stuff while another fruit is a pear:
while case .pear = anotherFruit {
    anotherFruit = fruits.removeFirst()
}
// No more pear
print(anotherFruit)
//: ## Raw Value
//: We can define an enum with RawValue and a value of selected type will be assigned to every case in enum definition, the same way we used to in C and Objective-C.
//: To create enums which can be used from Objective-C we are requred to use RawValue of Int:
enum InterfaceOrientation: Int {
    case portraitTop
    case portraitBottom
    case lanscapeLeft
    case landscapeRight
}
//: For Int we don't have to assign values, defaults are used. 
//: But if we need to start with non-zero value, we can assign them:
enum HttpSuccess: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthorativeInfo
    case noContent
}
//: No need to assign values other then the first one (200) if they go one after another, like here.
//: Also we can define multiple ranges of values in single enum:
enum HttpCodes: Int {
    case ok = 200
    case created // 201
    case accepted // 202
    case multipleChoices = 300
    case movedPermanently // 301
    case found // 302
    case seeOther // 303
    case badRequest = 400
    case unauthorized // 401
    case paymentRequired // 402
    case forbidden // 403
}
//: There are only few types that can be used as Raw Type values: String, Character and any integer or floating point number type. As I said before, only enums with raw type Int can be used from Objective-C.
//: Let's take a look at an enum with String raw type:
enum AppleDevice: String {
    case iphone5s = "iPhone6,1"
    case iphone6  = "iPhone7,2"
    case iphone6s = "iPhone8,1"
    case iphone7  = "iPhone9,1"
    case iphoneSE
}
//: How would we use a raw value?
//: We can retrieve it using rawValue property:
HttpCodes.created.rawValue
//: You can use them, for example, as sections and row indexes in UI Table View.
AppleDevice.iphone7.rawValue
//: With Strings, the same as with Ints, we don't have to assign specific value. The case name will be used as a raw value.
AppleDevice.iphoneSE.rawValue
//: Enums with raw values can be initalized from a value. Compiler created for us an implicit initializer that accepts a value of raw type:
let iphone6 = AppleDevice(rawValue: "iPhone7,2")
let iphoneSe = AppleDevice(rawValue: "iphoneSE")
let success = HttpCodes(rawValue: 200)
//: It's a failable initializer, that means if we try to create an enum with a value that does not have a case associated with it, initializer returns nil.
//: ## Associated values
//: We can add some data to enum cases that will be saved in a variables or passed to a function with the case.
//:
//: Unlike Raw Value, associated values can be of any type and not limited to 1 value per enum. Actually, every case can have its own values.
enum Shape {
    case square(position: CGPoint, size: CGSize)
    case circle(center: CGPoint, radius: CGFloat)
}
//: **Unfortutately, you can not use such enums from Objective-C.**
//: OK, let's create a variable for a circle:
let circle = Shape.circle(center: CGPoint(x: 10, y: 10), radius: 54)
//: Then we fetch associated values from the variable using the same constructions: switch, if-case-let, while-case, etc…
switch circle {
case .circle(let center, let radius):
    print("Circle with center \(center) and radius \(radius)")
case let .square(position, size):
    print("Square with position: \(position) and size: \(size)")
}
//: We can put a let keyword before every variable in the case, or, as in second case, – only one before the whole case, it works the same.
//:
//: if-case looks almost as part of switch statement:
if case let .circle(center, radius) = circle {
    print("Circle again! \(center):\(radius)")
}
//: With associated types you can not use simple if statement.
//: Sometimes you could find it's more convenient to work with a tuple then with multple values, so you can extract associated values as a tuple:
if case let .circle(props) = circle {
    print("Circle props \(props)")
    print("Position: \(props.center) and radius: \(props.radius)")
}
//: Though Swift Core Team plan to change it in Swift 4 and payload of a case won't be a tuple anymore.
//: But for now, we can pass a tuple as associated value when creating a case.
//: Let's build a computer:
typealias Config = (RAM: Int, CPU: String, GPU: String)

enum Desktop {
    case cube(Config)
    case tower(Config)
    case rack(Config)
}
let towerConfig: Config = (RAM: 32, CPU: "i7", GPU: "1080")
let aTower = Desktop.tower(towerConfig)

if case let .tower(ram, cpu, gpu) = aTower {
    print("Tower has \(ram) RAM, CPU: \(cpu), GPU: \(gpu)")
}
//: ## Extending enum
//: As structs and classes, enums can contain methods and computed properties, as well as nested types.
//: E.g. we can add a property to our Device enum:
extension AppleDevice {
    var chip: String {
        switch self {
        case .iphone5s: return "A7+M7"
        case .iphone6: return "A8+M8"
        case .iphone6s, .iphoneSE: return "A9+M9"
        case .iphone7: return "A10+M10"
        }
    }
}
//: If we create mutating method we can actually change the value of the enum:
enum TriStateSwitch {
    case off, low, high

    mutating func next() {
        switch self {
        case .off: self = .low
        case .low: self = .high
        case .high: self = .off
        }
    }
}

var light = TriStateSwitch.low
light.next() // Low -> High
light.next() // Hight -> Off
//: As structs and classes, enums can conform to protocols and use protocol extensions.
//:
//: Enums can be generic. Two of examples of generic enum are Optional and Result:
enum MyOptional<T> {
    case some(T)
    case none
}
enum MyError: Error {
}
enum Result<T, E: Error> {
    case success(T)
    case error(E)
}
let result = Result<Int, MyError>.success(72)
//: ## Complex usage
//: ### Recursive enums
//: Imagine a Tree structure, like file system of your Mac. It consists of Nodes – files and folder. You'd want a folder to contain another folder or file like this:
enum FileNode_ {
    case file(name: String)
    case folder(name: String, files: [FileNode_])
}
let aNode = FileNode_.folder(name: "Hello", files: [.file(name: "World")])
//: Value types like structs and enums have fixed size so you can't have a property of the same type there. But since Swift 2.0 there is a keyword 'indirect' that can be used to allow recursive enums like this:
enum FileNode {
    case file(name: String)
    indirect case folder(name: String, files: [FileNode])
}
let root = FileNode.folder(name: "/", files: [
        .folder(name: "bin", files: [
            .file(name: "bash"),
            .file(name: "cp"),
            .file(name: "ls")
        ]),
        .folder(name: "usr", files: [
            .folder(name: "local", files: [
                .folder(name: "bin", files: [])
            ])
        ])
    ])
//: ## Custom Raw type
//: You can use different types as a raw type with a workaround – such types should implement ExpressibleByStringLiteral protocol. Take CGSize for example:
extension CGSize: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let size = CGSizeFromString(value)
        self.init(width: size.width, height: size.height)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        let size = CGSizeFromString(value)
        self.init(width: size.width, height: size.height)
    }

    public init(unicodeScalarLiteral value: String) {
        let size = CGSizeFromString(value)
        self.init(width: size.width, height: size.height)
    }
}
//: Enum still accepts only Strings as raw values:
enum DeviceScreenResolution: CGSize {
    case iphoneSE = "{320, 480}"
    case iphone5s = "{320, 568}"
    case iphone6 = "{375, 667}"
}
//: But now we can access them as actual CGSize:
DeviceScreenResolution.iphone6.rawValue.width
DeviceScreenResolution.iphoneSE.rawValue.height
//: ### And some tips
//: ## Equality
//: When you use raw values, you get '==' equal operator for free:
let code = HttpCodes.created == HttpCodes.accepted
//: But otherwise, you have to implement it yourself. Take Shape. How do you compare it?
extension Shape: Equatable {
    static func ==(lhs: Shape, rhs: Shape) -> Bool {
        switch (lhs, rhs) {
        case let (.circle(center1, radius1), .circle(center2, radius2)):
            return center1 == center2 && radius1 == radius2
        case let (.square(position1, size1), .square(position2, size2)):
            return position1 == position2 && size1 == size2
//: But you need Switch to be exhaustive so you add default value:
        default:
            return false
        }
    }
}
//: If we add another shape, we can forget update the '==' function, compiler dosen't remind us because we have default case.
//: We can do this:
extension Shape: Equatable {
    static func ==(lhs: Shape, rhs: Shape) -> Bool {
        switch (lhs, rhs) {
        case let (.circle(center1, radius1), .circle(center2, radius2)):
            return center1 == center2 && radius1 == radius2
        case let (.square(position1, size1), .square(position2, size2)):
            return position1 == position2 && size1 == size2
        case let (.triangle(position1, side1), .triangle(position2, side2)):
            return position1 == position2 && side1 == side2
        case (.circle, _), (.square, _), (.triangle, _):
            return false
        }
    }
}
//: That way we always get false when trying to compare non-comparable cases and there is no default case so if we add another shape, compiler will tell us that we need to handle another case here.

//: ## See also:
//: [The Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html)
//:
//: [Advanced & Practical Enum usage in Swift](https://appventure.me/2015/10/17/advanced-practical-enum-examples/)
//:
//: [Enums, Equatable, and Exhaustiveness](https://oleb.net/blog/2017/03/enums-equatable-exhaustiveness/)

