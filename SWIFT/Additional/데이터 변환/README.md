# 데이터 변환

# (1) [Int]에서 String으로 변환

```swift
let myArr = [1, 2, 3]
let myResult = myArr.map(String.init).joined() // "123"

// String을 다시 Int로 변환
if let intResult = Int(myResult) {
    print(intResult) // 123
}
```

```swift
let myResult = myArr.map(String.init)
```

위 코드의 결과 myResult에는 ["1", "2", "3"]의 결과가 담긴다.

myArr의 각각의 값에 map을 이용해서 String으로 초기화 시켜주는 것이다.

joined(separator:) 메소드는 배열의 문자열들을 하나로 연결한 문자열을 반환한다. 또한 separator에 값을 주면 원소 사이에 분리 기호를 삽입하는 것도 가능하다.

위의 myResult에 joined(separator:) 메서드를 사용하면 "123"이 반환된다.

 

```swift
let strResult = myResult.joined()
```

참고 : [https://stackoverflow.com/questions/42274497/swift-convert-int-to-int-variable](https://stackoverflow.com/questions/42274497/swift-convert-int-to-int-variable), [https://medium.com/@sunghyun_k/swift-joined-4fcc49098bd0](https://medium.com/@sunghyun_k/swift-joined-4fcc49098bd0)

# (2) 문자열을 [Int]로 변환

"011"이 입력으로 들어왔을 때 [0, 1, 1]로 변환하는 방법을 알아보자.

```swift
let str: String = "011"

let numArray: [Int] = str.map { Int(String($0)) ?? 0 } // [0, 1, 1]
```

1. 먼저 String($0)을 통해서 Character형을 String으로 변환한다.
2. 그 후 Int()를 통해서 Int형으로 변환한다.
3. 그렇게 얻은 값을 numArray에 넣어준다.