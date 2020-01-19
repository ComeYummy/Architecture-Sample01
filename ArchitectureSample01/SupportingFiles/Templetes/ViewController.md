# ViewController

```swift
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
typealias ViewModelType = <#type expression#>

private var viewModel: ViewModelType?
private var disposeBag = DisposeBag()

func inject(viewModel: ViewModelType) {
self.viewModel = viewModel
}

override func viewDidLoad() {
super.viewDidLoad()
configureNavigation()
configureView()
configureViewModel()
}

private func configureNavigation() {
}

private func configureView() {
}

private func configureViewModel() {
guard let viewModel = viewModel else { return }
}
}
```
