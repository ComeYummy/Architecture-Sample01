#  Repository

## Protocol

```swift
protocol <#T##RepositoryName###>Repository {
    func fetch() -> Single<<#T##DataEntity##Data#>>
}
```

## Implementation

```swift
import RxSwift

struct <#T##RepositoryName###>RepositoryImpl: <#T##RepositoryName###>Repository {
    private let authTokenRepository: AuthTokenRepository

    static var shared: <#T##RepositoryName###>RepositoryImpl {
        return <#T##RepositoryName###>RepositoryImpl()
    }

    private init(authTokenRepository: AuthTokenRepository = AuthTokenRepositoryImpl.shared) {
        self.authTokenRepository = authTokenRepository
    }

    func fetch() -> Single<<#T##DataEntity##Data#>> {
        return authTokenRepository.getAccessToken()
            .flatMap { self.api.request($0) }
    }
}
```
