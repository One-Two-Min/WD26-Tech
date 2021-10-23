# 27장 - ARC

매번 전달할 때마다 값을 복사해 전달하는 값  타입과는 달리 참조 타입은 하나의 인스턴스가 참조를 통해 여러 곳에서 접근하기 때문에 언제 메모리에서 해제되는지가 중요한 문제이다. 인스턴스가 적절한 시점에 메모리에서 해제되지 않으면 한정적인 메모리 자원을 낭비하게 되며, 이는 성능의 저하로 이어지게 된다. 스위프트는 프로그램의 메모리 사용을 관리하기 위하여 메모리 관리 기법인 ARC를 사용한다.

> NOTE_ARC와 값 타입
>
> ARC가 관리해주는 참조 횟수 계산(Reference Counting)은 참조 타입인 클래스의 인스턴스에만 적용된다. 구조체나 열거형은 값 타입이므로 참조 횟수 계산과 무관하다. 즉, 구조체나 열거형은 다른 곳에서 참조하지 않기 때문에 ARC로 관리할 필요가 없다.

# 27.1 ARC란

---

 ARC 기능은 자동으로 메모리를 관리해주는 방식이다. ARC는 더 이상 필요하지 않은 클래스의 인스턴스를 메모리에서 해제하는 방식으로 동작한다.

 ARC와 가비지 컬렉션의 가장 큰 차이는 참조를 계산(Count)하는 시점이다. ARC는 인스턴스가 언제 메모리에서 해제되어야 할지를 컴파일과 동시에 결정한다. 가비지 컬렉션은 그렇지 않는다. 이로 인해 생기는 장점과 단점은 명확하다.

![Untitled](https://user-images.githubusercontent.com/91004864/138552172-f111dec4-2e51-4b7c-935f-23994810aa4e.png)



 ARC를 이용해 자동으로 메모리 관리를 받기 위해서는 몇 가지 규칙을 알아야 한다. 왜냐하면 가비지 컬렉션과 달리 ARC는 컴파일과 동시에 인스턴스를 메모리에서 해제하는 시점이 결정하기 때문이다. 우리가 원하는 방향으로 메모리 관리가 이루어지려면 ARC에 명확한 힌트를 주어야 한다.

 클래스의 인스턴스를 생성할 때마다 ARC는 그 인스턴스에 대한 정보를 저장하기 위한 메모리 공간을 따로 또 할당한다. 그 메모리 공간에는 인스턴스의 타입 정보와 함께 그 인스턴스와 관련된 저장 프로퍼티의 값 등을 저장한다. 그 후에 인스턴스가 더 이상 필요 없는 상태가 되면 인스턴스가 차지하던 메모리 공간을 다른 용도로 활용할 수 있도록 ARC가 메모리에서 인스턴스를 없앤다. 

 그런데 만약 아직 더 사용해야 하는 인스턴스를 메모리에서 해제시킨다면 인스턴스와 관련된 프로퍼티에 접근하거나 인스턴스의 메서드를 호출할 수 없다. 게다가 인스턴스에 강제로 접근하려고 하면 잘못된 메모리 접근으로 인해 프로그램이 강제 종료될 확률이 크다. 

 인스턴스가 지속해서 필요한 상황에서 ARC는 인스턴스가 메모리에서 해제되지 않도록 인스턴스 참조 여부를 계속 추적한다. 다른 인스턴스의 프로퍼티나 변수, 상수 등 어느 한 곳에서 인스턴스를 참조한다면 ARC가 해당 인스턴스를 해제하지 않고 유지해야 하는 명분이 된다. 인스턴스를 메모리에 유지시키려면 이런 명분을 ARC에 제공해야 한다는 것을 명심해야 한다.

 

# 27.2 강한참조(Strong Reference)

---

 인스턴스가 계속해서 메모리에 남아있어야 하는 명분을 만들어 주는 것이 바로 강한참조이다. 인스턴스는 참조 횟수가 0이 되는 순간 메모리에서 해제되는데, 인스턴스를 다른 인스턴스의 프로퍼티나 변수, 상수 등에 할당할 때 강한참조를 사용하면 참조 횟수가 1 증가한다. 또, 강한참조를 사용하는 프로퍼티, 변수, 상수 등에 nil을 할당해주면 원래 자신에게 할당되어 있던 인스턴스의 참조 횟수가 1 감소한다.

 참조의 기본은 강한참조이므로 클래스 타입의 프로퍼티, 변수, 상수 등을 선언할 때 별도의 식별자를 명시하지 않으면 강한참조를 한다.

```swift
/*
	코드 27-1. 강한참조의 참조 횟수 확인
*/

class Person {
    let name: String

    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "yagom")
// yagom is being initialized
// 인스턴스의 참조 횟수 : 1

reference2 = reference1 // 인스턴스의 참조 횟수: 2
reference3 = reference1 // 인스턴스의 참조 횟수: 3

reference3 = nil // 인스턴스의 참조 횟수: 2
reference2 = nil // 인스턴스의 참조 횟수: 1
reference1 = nil // 인스턴스의 참조 횟수: 0
// yagom is being deinitialized
```

 [코드 27-1]의 reference1에 할당된 Person 클래스 타입의 인스턴스는 처음 메모리에 생성된 후 강한참조로 reference1에 할당되기 때문에 참조 횟수가 1 증가한다. 그 후 reference2, reference3에 할당될 때도 참조 횟수가 1 증가한다. 하나의 인스턴스가 세 개의 변수에 강한참조로 참조하고 있는 것이다. 따라서 계속 메모리에 살아있을 명분이 충분하다.

 그 후 참조를 그만두면서 참조 횟수가 0이 되고 이 순간 인스턴스는 ARC 규칙에 의해 메모리에서 해제되며 메모리에서 해제되기 직전에 디이니셜라이저를 호출한다.

```swift
/*
	코드 27-2. 강한참조 지역변수(상수)의 참조 횟수 확인
*/
func foo() {
    let yagom: Person = Person(name: "yagom") // yagom is being initialized
    // 인스턴스의 참조 횟수 : 1

    // 함수 종료 시점
    // 인스턴스의 참조 횟수 : 0
    // yagom is being deinitialized
}

foo()
```

 [코드 27-2]의 경우, foo()라는 함수 내부에 yagom이라 정의한 강한참조 상수가 있다. Person 타입의 인스턴스는 이니셜라이저에 의해 생성된 후 yagom 상수에 할당할 때 참조횟수가 1이 된다. 그리고 강한참조 지역변수(상수)가 사용된 범위의 코드 실행이 종료되면 그 지역변수(상수)가 참조하던 인스턴스의 참조 횟수가 1 감소한다. 그래서 yagom 상수가 강한참조하던 인스턴스의 참조 횟수가 1 감소하여 인스턴스의 참조 횟수가 0이 된다. 인스턴스의 참조 횟수가 0이 되는 순간 인스턴스는 메모리에서 해제된다.

```swift
/*
	코드 27-3. 강한참조 지역변수(상수)의 참조 횟수 확인과 전역변수
*/

var globalReference: Person?

func foo() {
    let yagom: Person = Person(name: "yagom") // yagom is being initialized
    // 인스턴스의 참조 횟수 : 1

    globalReference = yagom // 인스턴스의 참조 횟수 : 2

    // 함수 종료 시점
    // 인스턴스의 참조 횟수 : 1
}

foo()
```

 [코드 27-3]에서는 인스턴스가 강한참조를 하는 전역변수 globalReference에 강한참조되면서 참조 횟수가 1 더 증가하여 2가 되었다. 그 상태에서는 함수가 종료되면 참조 횟수가 1 감소하여도 여전히 참조 횟수가 1이므로 메모리에서 해제되지 않는다.

## 27.2.1 강한참조 순환 문제

 그런데 복합적으로 강한참조가 일어나는 상황에서 강한참조의 규칙을 모르고 사용하게 되면 문제가 발생할 수 있다. 인스턴스끼리 서로가 서로를 강한참조할 때를 대표적인 예로 들 수 있다. 이를 강한참조 순환(Strong Reference Cycle)이라고 한다.

```swift
/*
	코드 27-4. 강한참조 순환 문제
*/

class Person {
    let name: String

    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }

    var room: Room?

    deinit {
        print("\(name) is being deinitialized")
    }
}

class Room {
    let number: String

    init(number: String) {
        self.number = number
    }

    var host: Person?

    deinit {
        print("Room \(number) is being deinitialized")
    }
}

var yagom: Person? = Person(name: "yagom") // Person 인스턴스의 참조 횟수 : 1
var room: Room? = Room(number: "505") // Room 인스턴스의 참조 횟수 : 1

room?.host = yagom // Person 인스턴스의 참조 횟수 : 2
yagom?.room = room // Room 인스턴스의 참조 횟수 : 2

yagom = nil // Person 인스턴스의 참조 횟수 : 1
room = nil // Room 인스턴스의 참조 횟수 : 1

// Person 인스턴스를 참조할 방법 상실 - 메모리에 잔존
// Room 인스턴스를 참조할 방법 상실 - 메모리에 잔존
```

 [코드 27-4]에서 yagom = nil, room = nil을 해주는 순간 yagom 변수가 참조하던 Person 클래스의 인스턴스에 접근할 방법도, room 변수가 참조하던 Room 클래스의 인스턴스에 접근할 방법도 사라졌다. 참조 횟수가 0이 되지 않는 한, ARC의 규칙대로라면 인스턴스를 메모리에서 해제시키지 않기 대문에 이렇게 두 인스턴스 모두 참조 횟수 1을 남겨둔 채, 메모리에 좀비처럼 남아있게 된다. 메모리 누수가 발생하는 것이다. 디이니셜라이저가 호출되지 않은 것을 보면 메모리에서 해제되지 않고 계속 남아 있다는 것을 알 수 있다.

 이렇게 두 인스턴스가 서로를 참조하는 상황에서 강한참조 순환 문제가 발생할 수 있다.

```swift
/*
	코드 27-5. 강한참조 순환 문제를 수동으로 해결
*/

var yagom: Person? = Person(name: "yagom") // Person 인스턴스의 참조 횟수 : 1
var room: Room? = Room(number: "505") // Room 인스턴스의 참조 횟수 : 1

room?.host = yagom // Person 인스턴스의 참조 횟수 : 2
yagom?.room = room // Room 인스턴스의 참조 횟수 : 2

yagom?.room = nil // Room 인스턴스의 참조 횟수 : 1
yagom = nil // Person 인스턴스의 참조 횟수 : 1

room?.host = nil // Person 인스턴스의 참조 횟수 : 0
// yagom is being deinitialized

room = nil // Room 인스턴스의 참조 횟수 : 0
// Room 505 is being deinitialized
```

 변수 또는 프로퍼티에 nil을 할당하면 참조 횟수가 감소한다는 규칙을 생각해보면 [코드 27-5]와 같은 방법으로 인스턴스를 메모리에서 해제시킬 수 있을지도 모른다. 그렇지만 만약 실수로, 아니면 깜빡하고 코드를 빼먹는다면? 아니면 해제해야 할 프로퍼티가 너무 많거나 귀찮다면? 

 이후에 소개할 약한참조와 미소유참조를 통해 조금 더 명확한 해결책을 찾아보자.

# 27.3 약한참조(Weak Reference)

---

 약한참조는 강한참조와 달리 자신이 참조하는 인스턴스의 참조 횟수를 증가시키지 않는다. 참조 타입의 프로퍼티나 변수의 선언 앞에 weak 키워드를 써주면 그 프로퍼티나 변수는 자신이 참조하는 인스턴스를 약한참조한다.

 약한참조를 사용한다면 자신이 참조하는 인스턴스가 메모리에서 해제될 수도 있다는 것을 예상해볼 수 있어야 한다. 자신이 참조 횟수를 증가시키지 않았기 때문에 그 인스턴스를 강한 참조하던 프로퍼티나 변수에서 참조 횟수를 감소시켜 0으로 만들면 자신이 참조하던 인스턴스가 메모리에서 해제되기 때문이다.

> NOTE_약한참조와 상수, 옵셔널
>
> 약한참조는 상수에서 쓰일 수 없다. 만약 자신이 참조하던 인스턴스가 메모리에서 해제된다면 nil이 할당될 수 있어야 하기 때문이다. 그래서 약한참조를 할 때는 자신의 값을 변경할 수 있는 변수로 선언해야 한다. 더불어 nil이 할당될 수 있어야 하므로 약한참조는 항상 옵셔널이어야 한다. 즉, **옵셔널 변수만 약한참조를 할 수 있다.**
>
> 

```swift
/*
	코드 27-6. 강한참조 순환 문제를 약한참조로 해결
*/

class Room {
    let number: String

    init(number: String) {
        self.number = number
    }

    weak var host: Person?

    deinit {
        print("Room \(number) is being deinitialized")
    }
}

var yagom: Person? = Person(name: "yagom") // Person 인스턴스의 참조 횟수 : 1
var room: Room? = Room(number: "505") // Room 인스턴스의 참조 횟수 : 1

room?.host = yagom // Person 인스턴스의 참조 횟수 : 1
yagom?.room = room // Room 인스턴스의 참조 횟수 : 2

yagom = nil // Person 인스턴스의 참조 횟수 : 0, Room 인스턴스의 참조 횟수 : 1
// yagom is being deinitialized
print(room?.host) // nil

room = nil // Room 인스턴스의 참조 횟수 : 0
// Room 505 is being deinitialized
```

 [코드 27-4]의 강한참조 순환 문제를 해결하기 위하여 [코드 27-6]에서는 Room 클래스의 host 프로퍼티가 약한참조를 하도록 weak 키워드를 추가하여 정의했다. room 변수가 참조하는 인스턴스의 host 프로퍼티가 약한참조를 하므로 yagom이 참조하는 인스턴스를 host 프로퍼티에 참조하도록 할 때 참조 횟수는 증가하지 않는다. 그렇지만 yagom이 참조하는 인스턴스의 room 프로퍼티는 강한참조를 하므로 인스턴스의 참조 횟수가 1 증가하게 된다.

 여기서 눈여겨봐야 할 점은 yagom 변수가 참조했던 인스턴스의 참조 횟수가 0이 되면서 메모리에서 해제될 때, 인스턴스의 room 프로퍼티가 참조하는 인스턴스의 참조 횟수도 1 감소된 것이다. 이를 통해 우리는 **인스턴스가 메모리에서 해제될 때, 자신의 프로퍼티가 강한참조를 하던 인스턴스의 참조 횟수를 1 감소시킨다는 것을 알 수 있다.**

 그리고 yagom 변수가 참조하던 인스턴스가 메모리에서 해제되었다는 뜻은 room 변수가 참조하는 인스턴스의 프로퍼티인 host가 참조하는 인스턴스가 메모리에서 해제되었다는 의미이다. host 프로퍼티는 약한참조를 하기 때문에 자신이 참조하는 인스턴스가 메모리에서 해제되면 자동으로 nil을 할당한다는 것을 알 수 있다.

 그리고 마지막으로 room 변수가 참조하던 인스턴스는 room = nil이라는 코드를 통해 더 이상 자신을 참조한느 곳이 없는 상태이다. 즉, 참조 횟수가 0이 되고 메모리에서 해제되는 것을 확인할 수 있다.

# 27.4 미소유참조(Unowned Reference)

---

 참조 횟수를 증가시키지 않고 참조할 수 있는 방법은 약한참조 뿐만이 아니라 미소유참조도 있다. 미소유참조는 약한참조와 다르게 **자신이 참조하는 인스턴스가 항상 메모리에 존재할 것이라는 전제를 기반으로 동작**한다. 즉, 자신이 참조하는 인스턴스가 메모리에서 해제되더라도 스스로 nil을 할당해주지 않는다는 뜻이다. 그렇기 때문에 미소유참조를 하는 변수나 프로퍼티는 옵셔널이나 변수가 아니어도 된다.

 그렇지만 미소유참조를 하면서 메모리에서 해제된 인스턴스에 접근하려 한다면 잘못된 메모리 접근으로 런타임 오류가 발생해 프로세스가 강제로 종료된다. 따라서 **미소유참조는 참조하는 동안 해당 인스턴스가 메모리에서 해제되지 않으리라는 확신이 있을 때만 사용해야 한다.**

 참조 타입의 변수나 프로퍼티의 정의 앞에 unowned 키워드를 써주면 그 변수(상수)나 프로퍼티는 자신이 참조하는 인스턴스를 미소유참조하게 된다.

 미소유참조는 사람과 신용카드의 관계를 예로 들어 생각해볼 수 있다. 사람이 신용카드를 소지하지 않을 수는 있지만, 신용카드는 명의자가 꼭 있어야 한다. 명의자와 신용카드는 서로를 참조해야 하는 상황이고 신용카드는 명의자가 꼭 존재한다는 확신이 있을 때, 이 관계를 클래스로 표현해보자면 [코드 27-7]처럼 표현해볼 수 있다.

```swift
/*
	코드 27-7. 미소유참조
*/

class Person {
    let name: String

    // 카드를 소지할 수도, 소지하지 않을 수도 있기 때문에 옵셔널로 정의한다.
    // 또, 카드를 한 번 가진 후 잃어버리면 안 되기 때문에 강한참조를 해야 한다.
    var card: CreditCard?

    init(name: String) {
        self.name = name
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: UInt
    unowned let owner: Person // 카드는 소유자가 분명히 존재해야 한다.

    init(number: UInt, owner: Person) {
        self.number = number
        self.owner = owner
    }

    deinit {
        print("Card #\(number) is being deinitialized")
    }
}

var jisoo: Person? = Person(name: "jisoo") // Person 인스턴스의 참조 횟수 : 1

if let person: Person = jisoo {
    // CreditCard 인스턴스의 참조 횟수 : 1
    person.card = CreditCard(number: 1004, owner: person)
    // Person 인스턴스의 참조 횟수 : 1
}

jisoo = nil // Person 인스턴스의 참조 횟수 : 0
// CreditCard 인스턴스의 참조 횟수 : 0
// jisoo is being deinitialized
// Card #1004 is being deinitialized
```

 CreditCard의 이니셜라이저에서 owner 프로퍼티에 미소유참조되는 Person 인스턴스는 참조 횟수가 증가하지 않는다. 그래서 서로 참조를 하지만 참조 횟수는 모두 1인 상태가 된다. jisoo 변수에 nil을 할당하면 jisoo 변수가 강한참조하던 인스턴스가 메모리에서 해제되므로 그 인스턴스의 card 프로퍼티가 강한참조하던 CreditCard 클래스의 인스턴스도 참조 횟수가 1 감소되어 메모리에서 해제된다.

# 27.5 미소유 옵셔널 참조

---

 클래스를 참조하는 옵셔널을 미소유로 표시할 수 있다. ARC 소유 모델에 따르면 미소유 옵셔널 참조와 약한참조를 같은 상황에 사용할 수 있다. 차이가 있다면 **미소유 옵셔널 참조는 항상 유효한 객체를 가리키거나 그렇지 않으면 nil을 할당해 주도록 직접 신경을 써야 한다는 것이다.** 

 특정 학과가 운영하는 과목들의 수강 순서를 나타내고 싶다. 각 과목에는 다음 수강 과목이 있을 수도, 없을 수도 있다. 이 관계를 나타내기 위해 [코드 27-8]에서 미소유 옵셔널 참조를 사용해보자.

```swift
/*
	코드 27-8. 미소유 옵셔널 참조의 사용
*/

class Department {
    var name: String
    var subjects: [Subject] = []
    init(name: String) {
        self.name = name
    }
}

class Subject {
    var name: String
    unowned var department: Department
    unowned var nextSubject: Subject?
    init(name: String, in department: Department) {
        self.name = name
        self.department = department
        self.nextSubject = nil
    }
}

let department = Department(name: "Computer Science")

let intro = Subject(name: "Computer Architecture", in: department)
let intermediate = Subject(name: "Swift Language", in: department)
let advanced = Subject(name: "iOS App Programming", in: department)

intro.nextSubject = intermediate
intermediate.nextSubject = advanced
department.subjects = [intro, intermediate, advanced]
```

 Department는 학과에서 운영하는 각 과목을 배열에 담아 강한참조하고 있다. 학과가 과목들을 소유하고 있는 형태이다. Subject는 두 개의 미소유참조를 갖고 있는데 과목이 소유하고 있지 않은 것이다. 각각의 과목은 특정 학과에 꼭 속해 있기 때문에 department 프로퍼티는 옵셔널이 아니다. 그렇지만 모든 과목이 다음 차례의 과목을 갖고 있는 것은 아니기 때문에 nextSubject 프로퍼티는 옵셔널이다. 

 미소유 옵셔널 참조는 옵셔널의 값인 클래스 인스턴스를 강한참조를 하지 않기 때문에, 옵셔널 값인 클래스의 인스턴스가 메모리에서 해제될 때 ARC에 의해 보호받지 못한다. 이는 미소유참조와 동일한 동작을 하지만, 미소유 옵셔널 참조는 nil이 될 수 있다는 점이 미소유참조와 다르다. 

 옵셔널이 아닌 미소유참조와 같이 nextSubject가 항상 올바른 과목 인스턴스를 참조하도록 신경 써야 한다. 예를 들어, [코드 27-8]에서 department.subjects에서 한 과목을 제거한다면, 그 과목을 nextSubject로 참조하고 있는 인스턴스에서 nextSubject의 참조를 제거해 줘야 한다. 만약 그렇지 않다면 참조하려고 할 때 오류가 발생할 것이다.

# 27.6 미소유참조와 암시적 추출 옵셔널 프로퍼티

---

 서로 참조해야 하는 프로퍼티에 값이 꼭 있어야 하면서도 한 번 초기화되면 그 이후에는 nil을 할당할 수 없는 조건을 갖추어야 하는 경우가 있다. [코드 27-9]를 통해 이를 알아보자.

```swift
/*
	코드 27-9. 미소유참조와 암시적 추출 옵셔널 프로퍼티의 활용
*/

class Company {
    let name: String
    // 암시적 추출 옵셔널 프로퍼티 (강한참조)
    var ceo: CEO!

    init(name: String, ceoName: String) {
        self.name = name
        self.ceo = CEO(name: ceoName, company: Self)
    }

    func introduce() {
        print("\(name)의 CEO는 \(ceo.name)입니다.")
    }
}

class CEO {
    let name: String
    // 미소유참조 상수 프로퍼티 (미소유참조)
    unowned let company: Company

    init(name: String, company: Company) {
        self.name = name
        self.company = company
    }

    func introduce() {
        print("\(name)는 \(company.name)의 CEO입니다.")
    }
}

let company: Company = Company(name: "무한상사", ceoName: "김태호")
company.introduce() // 무한상사의 CEO는 김태호입니다.
company.ceo.introduce() // 김태호는 무한상사의 CEO입니다.
```

 회사(Company를 창립(인스턴스 생성)할 때는 꼭 최고경영자(CEO)가 있어야 하며, 최고경영자는 단 하나의 회사를 운영한다. 회사가 사라지면 최고 경영자가 있을 의미가 없다. 즉, Company를 초기화할 때 CEO 인스턴스가 생성되면서 프로퍼티로 할당되어야 하고, Company가 존재하는 한 ceo 프로퍼티에는 꼭 CEO 인스턴스가 존재해야 하는 상황이다. 또, CEO의 인스턴스는 꼭 회사가 있는 경우에만 초기화할 수 있다. 그리고 회사가 사라지면 최고경영자가 있을 의미가 없기 때문에 강한참조를 사용하지 않는다.

 최고경영자는 회사를 꼭 운영하고 있어야 하므로 CEO 타입의 company는 옵셔널이 될 수 없다. 옵셔널이 될 수 없다는 뜻은 약한참조를 사용할 수 없다는 뜻이다. 그렇지만 강한참조를 하면 강한참조 순환 문제가 발생할 수 있으므로 미소유참조를 한다.

 Company의 ceo 프로퍼티에 암시적 추출 옵셔널을 사용한 이유는, Company 타입의 인스턴스를 초기화할 때, CEO 타입의 인스턴스를 생성하는 과정에서 자기 자신을 참조하도록 보내줘야 하기 때문이다. 

 암시적 추출 옵셔널 프로퍼티는 이니셜라이저의 2단계 초기화(18.3.3절) 조건을 충족시키기 위해 사용했으며 미소유참조 프로퍼티는 약한참조를 사용할 수 없는 경우(옵셔널이 아니어야 하거나 상수로 지정해야 하는 경우)에 강한참조를 피하기 위하여 사용할 수 있다.

 

# 27.7 클로저의 강한참조 순환

---

 강한참조 순환 문제는 두 인스턴스끼리의 참조일 때만 발생하는 것 외에 클로저가 인스턴스의 프로퍼티일 때나, 클로저의 값 획득 특성 때문에 발생한다. 예를 들어 클로저 내부에서 self.SomeProperty처럼 인스턴스의 프로퍼티에 접근할 때나 클로저 내부에서 self.someMethod()처럼 인스턴스의 메서드를 호출할 때 값 획득이 발생할 수 있는데, 두 경우 모두 클로저가 self를 획득하므로 강한참조 순환이 발생한다.

 강한참조 순환이 발생하는 이유는 클로저가 클래스와 같은 참조 타입이기 때문이다. 클로저를 클래스 인스턴스의 프로퍼티로 할당하면 클로저의 참조가 할당된다. 이때 참조 타입과 참조 타입이 서로 강한참조를 하기 때문에 강한참조 순환 문제가 발생한다.

 이러한 클로저의 강한참조 순환 문제는 클로저의 획득 목록을 통해 해결할 수 있다. 해결 방법을 알아보기 전에 먼저 강한참조 순환이 어떻게 일어나게 되는지 알아보자.

```swift
/*
	코드 27-10. 클로저의 강한 참조 순환 문제
*/

class Person {
    let name: String
    let hobby: String?

    lazy var introduce: () -> String = {
        var introduction: String = "My name is \(self.name)."

        guard let hobby = self.hobby else {
            return introduction
        }

        introduction += " "
        introduction += "My hobby is \(hobby)."

        return introduction
    }

    init(name: String, hobby: String? = nil) {
        self.name = name
        self.hobby = hobby
    }

    deinit {
        print("\(name) is being deinitialized.")
    }
}

var yagom: Person? = Person(name: "yagom", hobby: "eating")
print(yagom?.introduce()) // My name is yagom. My hobby is eating.
yagom = nil
```

 

 [코드 27-10]에서 yagom 변수에 마지막에 nil을 할당했지만 deinit이 호출되지 않았다. Person 클래스의 introduct 프로퍼티에 클로저를 할당한 후 클로저 내부에서 self 프로퍼티를 사용할 수 있었던 이유는 introduce가 지연 저장 프로퍼티이기 때문이다. 만약 지연 저장 프로퍼티(10.1.2절)가 아니라면 이렇게 self를 사용하여 접근할 수 없었을 것이다. lazy 프로퍼티로 할당한 클로저 내부에서 Person 클래스 인스턴스의 다른 인스턴스 프로퍼티에 접근하려면 Person 클래스의 인스턴스가 모두 초기화되어 사용이 가능한 상태에서만 클로저에 접근할 수 있다. 따라서 클로저 내부에서는 self 프로퍼티를 통해서만 다른 프로퍼티에 접근할 수 있다. 

 자기소개를 하려고 introduce 프로퍼티를 통해 클로저를 호출하면 그 때 클로저는 자신의 내부에 있는 참조 타입 변수 등을 획득한다. 문제는 클로저는 자신이 호출되면 언제든지 자신 내부의 참조들을 사용할 수 있도록 참조 횟수를 증가시켜 메모리에서 해제되는 것을 방지하는데, 이때 자신을 프로퍼티로 갖는 인스턴스의 참조 횟수도 증가시킨다. 

 이렇게 강한참조 순환이 발생하면 자신을 강한참조 프로퍼티로 갖는 인스턴스가 메모리에서 해제될 수 없다. 

> NOTE_self 프로퍼티와 참조 횟수
>
> 클로저 내부에서 self 프로퍼티를 여러 번 호출하여 접근한다고 해도 참조 횟수는 한 번만 증가한다.

## 27.7.1 획득목록(Capture list)

 앞의 문제를 획득목록을 통해 해결할 수 있다. 획득목록은 클로저 내부에서 참조 타입을 획득하는 규칙을 제시해줄 수 있는 기능이다. 예를 들어 [코드 27-10]의 상황에서 클로저 내부의 self 참조를 약한참조로 지정할 수도, 강한참조로 지정할 수도 있다는 뜻이다. 획득목록을 사용하면 때에 따라서, 혹은 관계에 따라서 참조 방식을 클로저에 제안할 수 있다.

 획득목록은 클로저 내부의 매개변수 목록 이전 위치에 작성해준다. 획득목록은 참조 방식과 참조할 대상을 대괄호( [ ] )로 둘러싼 목록 형식으로 작성하며 획득목록 뒤에는 in 키워드를 써준다. 획득목록에 명시한 요소가 참조 타입이 아니라면 해당 요소들은 클로저가 생성될 때 초기화된다.

```swift
/*
	코드 27-11. 획득목록을 통한 값 획득
*/

var a = 0
var b = 0
let closure = { [a] in 
    print(a, b)
    b = 20
}

a = 10
b = 10
closure() // 0 10
print(b) // 20
```

 [코드 27-11]을 보면 변수 a는 클로저의 획득목록을 통해 클로저가 생성될 때 값 0을 획득했지만 b는 따로 값을 획득하지 않았다. 차후에 a와 b의 값을 변경한 후 클로저를 실행하면 a는 클로저가 생성되었을 때 획득한 값을 갖지만, b는 변경된 값을 사용하는 것을 확인할 수 있다.

 a 변수는 클로저가 생성됨과 동시에 획득목록 내에서 다시 a라는 이름의 상수로 초기화된 것이다. 그렇기 때문에 외부에서 a의 값을 변경하더라도 클로저의 획득목록을 통한 a와는 별개가 되는 것이다. 그러나 b의 경우에는 클로저의 내부와 외부 상관없이 값이 변하는대로 모두 반영됨을 확인할 수 있다.

 그러나 만약 획득목록에 해당하는 요소가 참조 타입이라면 조금 다른 결과를 볼 수 있다.

```swift
class SimpleClass {
    var value: Int = 0
}

var x = SimpleClass()
var y = SimpleClass()
let closure = { [x] in 
    print(x.value, y.value)
}

x.value = 10
y.value = 10

closure() // 10 10
```

 변수 x는 획득목록을 통해 값을 획득했지만 y는 획득목록에 별도로 명시되지 않았다. 그렇지만 서로 동작은 같다. 두 변수 모두 참조 타입의 인스턴스가 있기 때문이다. 그렇지만 참조 타입은 획득목록에서 어떤 방식으로 참조할 것인지, 즉 강한획득(Strong Capture)을 할 것인지, 약한획득(Weak Capture)을 할 것인지, 미소유획득(Unowned Capture)을 할 것인지를 정해줄 수 있다. 또 획득의 종류에 따라 참조 횟수를 증가시킬지 결정할 수 있다. 다만 명심할 것은 **약한획득을 하게 되면 획득목록에서 획득하는 상수가 옵셔널 상수로 지정된다는 것이다.** 그 이유는 차후에 클로저 내부에서 약한획득한 상수를 사용하려고 할 때 이미 메모리에서 해제된 상태일 수 있기 때문이다. 해제된 후에 접근하려 하면 잘못된 접근으로 오류가 발생하므로 안전을 위해 약한획득은 기본적으로 타입을 옵셔널로 사용하는 것이다.

 

```swift
/*
	코드 27-13. 획득목록의 획득 종류 명시
*/

class SimpleClass {
    var value: Int = 0
}

var x: SimpleClass? = SimpleClass()
var y = SimpleClass()
let closure = { [weak x, unowned y] in 
    print(x?.value, y.value)
}

x = nil
y.value = 10

closure() // nil 10
```

 x가 약한참조를 하게 되므로 클로저 내부에서 사용하더라도 클로저는 x가 참조하는 인스턴스의 참조 횟수를 증가시키지 않는다. 그렇게 되면 변수 x가 참조하는 인스턴스가 메모리에서 해제되어 클로저 내부에서도 더 이상 참조가 불가능한 것을 볼 수 있다. y는 미소유참조를 했기 때문에 클로저가 참조 횟수를 증가시키지 않지만, 만약 메모리에서 해제된 상태에서 사용하려 한다면 실행 중에 오류로 애플리케이션이 강제로 종료될 가능성이 있다.

 [코드 27-10]에서 우리가 만들었던 클로저의 강한참조 순환 문제를 해결해보도록 하자.

```swift
/*
	코드 27-14. 획득목록을 통한 클로저의 강한참조 순환 문제 해결
*/

class Person {
    let name: String
    let hobby: String?

    lazy var introduce: () -> String = { [unowned self] in
        var introduction: String = "My name is \(self.name)."

        guard let hobby = self.hobby else {
            return introduction
        }

        introduction += " "
        introduction += "My hobby is \(hobby)."

        return introduction
    }

    init(name: String, hobby: String? = nil) {
        self.name = name
        self.hobby = hobby
    }

    deinit {
        print("\(name) is being deinitialized.")
    }
}

var yagom: Person? = Person(name: "yagom", hobby: "eating")
print(yagom?.introduce()) // My name is yagom. My hobby is eating.
yagom = nil  // yagom is being deinitialized.
```

 introduce 프로퍼티의 클로저가 self를 미소유참조하도록 획득목록에 명시했기 때문에 yagom이 참조하는 인스턴스가 의도한 대로 메모리에서 해제되는 것을 확인할 수 있다. slef 프로퍼티를 미소유참조하도록 한 것은, 해당 인스턴스가 존재하지 않는다면 프로퍼티도 호출할 수 없으므로 self는 미소유참조를 하더라도 실행 중에 오류를 발생시킬 가능성이 거의 없다고 볼 수 있기 때문이다.

 self를 미소유참조로 지정해주었을 때 문제가 발생할 수 있다. 프로퍼티로 사용하던 클로저를 다른 곳에서 참조하게 된 후 인스턴스가 메모리에서 해제되었을 때다. 그런 상황에 클로저가 실행되면 잘못된 메모리 접근을 야기한다. 그러므로 미소유참조는 신중히 사용해야 하며, 문제가 될 소지가 있다면 약한참조를 사용하면 된다.

```swift
/*
	코드 27-15. 획득목록의 미소유참조로 인한 차후 접근 문제 발생
*/

var yagom: Person? = Person(name: "yagom", hobby: "eating")
var hana: Person? = Person(name: "hana", hobby: "playing guitar")

// hana의 introduce 프로퍼티에 yagom의 introduce 프로퍼티 클로저의 참조 할당
hana?.introduce = yagom?.introduce ?? {" "}

// 아직 yagom이 참조하는 인스턴스가 해제되지 않았기 때문에
// 클로저 내부에서 self(yagom 변수가 참조하는 인스턴스) 참조 가능
print(yagom?.introduce()) // My name is yagom. My hobby is eating.

yagom = nil // yagom is being deinitialized.

print(hana?.introduce()) // 오류 발생! 이미 메모리에서 해제된 인스턴스(yagom) 참조 시도
```

 [코드 27-15]처럼 미소유참조로 인한 문제상황이 발생할 수 있다면 약한참조로 변경하여 옵셔널로 사용해도 무방하다.

```swift
/*
	코드 27-16. 획득목록의 약한참조를 통한 차후 접근 문제 방지
*/

class Person {
    let name: String
    let hobby: String?

    lazy var introduce: () -> String = { [weak self] in

        // 'self'를 사용한 이유는 2장 예약어와 키워드 TIP(2.1절)과 부록 C를 참고
        guard let `self` = self else {
            return "원래의 참조 인스턴스가 없어졌습니다."
        }

        var introduction: String = "My name is \(self.name)."

        guard let hobby = self.hobby else {
            return introduction
        }

        introduction += " "
        introduction += "My hobby is \(hobby)."

        return introduction
    }

    init(name: String, hobby: String? = nil) {
        self.name = name
        self.hobby = hobby
    }

    deinit {
        print("\(name) is being deinitialized.")
    }
}

var yagom: Person? = Person(name: "yagom", hobby: "eating")
var hana: Person? = Person(name: "hana", hobby: "playing guitar")

// hana의 introduce 프로퍼티에 yagom의 introduce 프로퍼티 클로저의 참조 할당
hana?.introduce = yagom?.introduce ?? {" "}

// 아직 yagom이 참조하는 인스턴스가 해제되지 않았기 때문에
// 클로저 내부에서 self(yagom 변수가 참조하는 인스턴스) 참조 가능
print(yagom?.introduce()) // My name is yagom. My hobby is eating.

yagom = nil // yagom is being deinitialized.

print(hana?.introduce()) // 원래의 참조 인스턴스가 없어졌습니다.
```