import UIKit

var str = "Hello, playground"


var a: [String] = []

a.append("ss")
a.append("ddd")


print(a)

var b: [String] = []

b = a


b[0] = "XXX"
print(b)
print(a)
