# ViewModel

```swift
import RxCocoa
import RxSwift

class ViewModel: ViewModelType {
typealias UseCaseType =
typealias WireframeType =

private let useCase: UseCaseType
private let wireframe: WireframeType

struct Input {
}

struct Output {
}

init(useCase: UseCaseType, wireframe: WireframeType) {
self.useCase = useCase
self.wireframe = wireframe
}

func transform(_ input: Input) -> Output {

return Output()
}
}
```

## without Wireframe

```swift
import RxCocoa
import RxSwift

class CreateNewEventViewModel: ViewModelType {
typealias UseCaseType =

private let useCase: UseCaseType

struct Input {
}

struct Output {
}

init(useCase: UseCaseType) {
self.useCase = useCase
}

func transform(_ input: Input) -> Output {

return Output()
}
}

```
