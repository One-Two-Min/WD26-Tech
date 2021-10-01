# 입력 받기

## readLine()을 사용한 입력 받기

 Swift에서 입력을 받을 때는 다음과 같이 받아주면 된다.

```swift
var input = readLine()
```

그러나 readLine 메서드를 보면 다음과 같이 되어있다.

```swift
public func readLine(strippingNewline: Bool = true) -> String?
```

리턴 값이 옵셔널 타입임을 알 수 있다. 

옵셔널 강제 해제 연산을 써도 되지만 안전하게 if let을 사용한다.

```swift
var input = readLine()

if let input = input {
	print(input)
}
```

## 입력 값 사용

 readLine으로 읽은 값 input의 타입은 String이기 때문에 1 2 의 형태로 입력 받으면 "1 2"와 같은 문자열로 저장된다. 그렇기 때문에 이를 내가 원하는 형태로 구분하는 작업이 필요하다.

 위 예에서는 공백을 기준으로 입력받은 값을 배열의 요소로 저장해 줄 수 있다. String의 값을 원하는 모양으로 쪼개어서 배열로 만들어주는 메서드가 있는데 보통 두 가지를 사용한다.

```swift
func split(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Substring]
```

```swift
func components(separatedBy separator: String) -> [String]
```

먼저 두 메서드의 차이점을 살펴보자.

![Untitled](https://user-images.githubusercontent.com/91004864/135551222-25991e3a-1df8-4cee-bf6a-76ea54e4b5ad.png)

각 메서드는 다음과 같이 사용할 수 있다.

- split

```swift
var input = readLine()

if let input = input {
    let inputs = input.split(separator: " ")
    print(inputs)
    let intInput = inputs.map { Int($0)! } // map을 이용해서 Int형으로 변환
    print(intInput)
}
```

![Untitled 1](https://user-images.githubusercontent.com/91004864/135551226-e1c26355-7a84-49df-bb3b-aa99aa75f9be.png)

- components

```swift
var input = readLine()

if let input = input {
    let inputs = input.components(separatedBy: " ")
    print(inputs)
}
```

![Untitled 2](https://user-images.githubusercontent.com/91004864/135551236-3ac70a3f-1df3-425b-aecf-ab376aacd41c.png)

