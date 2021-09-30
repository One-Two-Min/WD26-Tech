public struct Stack<T> {
    // 쌓이는 데이터를 담아주기 위한 배열
    private var elements: [T] = []
    public init() { }
    
    // 초기값 지정 생성자
    public init(_ element: [T]) {
        elements = element
    }
    
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

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init()
        for element in elements {
            self.elements.append(element)
        }
    }
}


var intStack: Stack<Int> = Stack()
intStack = [5, 3, 8]
print(intStack)
