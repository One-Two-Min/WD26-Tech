# 순열과 조합

## 1. 순열

```swift
// nums: 값을 추출할 배열
// targetNum: nums에서 몇 개를 뽑을지를 나타내는 입력값
func permute(_ nums: [Int], _ targetNum: Int) {
    
    // nums에서 해당 인덱스의 숫자가 사용되었는지를 표시하기 위한 Bool형 배열
    var flag: [Bool] = [Bool](repeating: false, count: nums.count)
    
    // 실제로 값을 추출하는 함수
    func permutation(_ permuRes: [Int]) {
        
        // 추출한 배열의 갯수가 targetNum과 일치하면 작업 후 종료
        if permuRes.count == targetNum {
            print(permuRes)
            // 필요한 작업 수행...
            return
        }
        
        // nums 배열의 갯수만큼 반복하면서
        // 아직 nums[i]가 사용되지 않았다면 사용하고 재귀 호출
        for i in 0..<nums.count {
            if !flag[i] {
                flag[i] = true
                permutation(permuRes + [nums[i]])
                flag[i] = false
            }
        }
    }
    
    permutation([])
}

permute([1, 3, 5], 2)
```

- 참고: [https://icksw.tistory.com/180](https://icksw.tistory.com/180)

## 2. 조합

```swift
// nums: 타켓 배열
// targetNum: 뽑아낼 갯수
func combi(_ nums: [Int], _ targetNum: Int) {
    
    // idx: 현재 인덱스
    // combiRes: 현재까지 뽑아낸 결과 배열
    func combination(_ idx: Int, _ combiRes: [Int]) {
        
        // 현재까지 뽑아낸 배열의 원소 갯수가 targetNum과 일치하면 종료
        if combiRes.count == targetNum {
            print(combiRes)
            // 작업 수행..
            return
        }
        
        // 현재 인덱스(idx)부터 nums 배열 원소 갯수까지 for문 돌며 재귀적으로 호출
        for i in idx..<nums.count {
            combination(i+1, combiRes + [nums[i]])
        }
    }
    
    combination(0, [])
}

combi([1, 3, 5], 2)
```

- 참고: [https://ssooyn.tistory.com/24](https://ssooyn.tistory.com/24)