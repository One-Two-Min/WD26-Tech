# Stack

## 기본 구현

[스택 기본]

- 스택은 '어떤 것을 쌓는 형태'를 컴퓨터에서 표현하기 위해 만들어진 자료구조이다.
- 상자를 쌓아서 정리했다면 '상자를 쌓는 것'이 스택이고 '상자'가 스택의 아이템이 된다.
- 상자를 뺄때는 위에서부터 빼야한다.
- 그렇기 때문에 가장 나중에 들어온 것이 먼저 빠지게 되고 이를 LIFO(Last In First Out)이라고 표현한다.

[필요한 연산]

- push(): 데이터를 쌓기 위한 메서드
- pop(): 데이터를 빼기 위한 메서드
- peek(): 가장 위에 있는 데이터가 어떤 것인지 보여주기 위한 메서드
- isEmpty(): 스택에 자료가 비어있는지를 나타내는 메서드
- count: 현재 스택에 몇 개의 자료가 있는지를 나타내기 위한 프로퍼티

[구현]

```swift
public struct Stack<T> {
    // 쌓이는 데이터를 담아주기 위한 배열
    private var elements: [T] = []
    public init() { }
    
    // count: 스택에 쌓여있는 데이터의 개수
    public var count: Int {
        return self.elements.count
    }
    
    // push: 데이터 쌓기
    public mutating func push(_ data: T) {
        self.elements.append(data)
    }
    
    // pop: 데이터 꺼내기
    public mutating func pop() -> T? {
        return self.elements.popLast()
    }
    
    // isEmpty: 스택이 비어있는지 확인
    public func isEmpty() -> Bool {
        return self.elements.isEmpty
    }
    
    // peek: 스택의 가장 위에 있는 데이터 확인
    public func peek() -> T? {
        return self.elements.last
    }
}

var intStack: Stack<Int> = Stack()
intStack.push(1)
intStack.push(4)
print(intStack.peek()) // 4
print(intStack.count) // 2
print(intStack.pop()) // 4

print(intStack)
```

## CustomStringConvertible 프로토콜 채택

- Stack 구조체에 CustomStringConvertible 프로토콜을 채택
- CustomStringConvertible 프로토콜은 description을 정의하는 프로토콜이다.
- 이를 채택한 객체를 출력하면 내가 정의한 description 형식으로 출력할 수 있다.

```swift
extension Stack: CustomStringConvertible {
    public var description: String {
        let topDivider = "----- top -----\n" // 출력의 시작을 알리는 문구
        let bottomDivider = "\n----- end -----" // 출력의 끝을 알리는 문구
        
        let stackElements = elements.map { "\($0)" }
            .reversed() // 문자열로 바뀐 배열의 요소를 거꾸로 정렬
            .joined(separator: "\n") // 문자열 사이에 줄 바꿈을 추가하여 하나의 String으로 변환
        
        return topDivider + stackElements + bottomDivider
    }
}
```

## init 추가

- init(element:) 을 추가해서 Stack 인스턴스를 생성할 때 초기값을 지정해 줄 수 있다.

```swift
		// 초기값 지정 생성자
    public init(_ element: [T]) {
        elements = element
    }
```

- 실행

```swift
var intStack: Stack<Int> = Stack([3, 6, 4])
print(intStack)
```

- 결과

![Untitled](https://user-images.githubusercontent.com/91004864/135453411-4a09049f-5e61-4021-b5e9-fa81d8d8fe45.png)

## ExpressibleByArrayLiteral 프로토콜 채택

- ExpressibleByArrayLiteral 프로토콜을 이용해서 초기화를 구현할 수도 있다.
- 배열이 초기화 하는 방식으로 쉽게 초기화가 가능하다.

- 구현

```swift
extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init()
        for element in elements {
            self.elements.append(element)
        }
    }
}
```

- 실행
  
    ![Untitled 1](https://user-images.githubusercontent.com/91004864/135453336-c4142c19-7346-478d-ae0b-a10c1969fe63.png)

