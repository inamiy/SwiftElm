# SwiftElm

[Reactive](https://github.com/ReactiveCocoa/ReactiveSwift) + [Automaton](https://github.com/inamiy/ReactiveAutomaton) + [VTree](https://github.com/inamiy/VTree) in Swift, inspired by [Elm](http://elm-lang.org).

**Note:** This library is only a **100 lines of code**.

## Example

All your `AppDelegate` are belong to Elm.

```swift
import UIKit
import VTree
import SwiftElm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var program: Program<Model, Msg>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.program = Program(model: 0, update: update, view: view)

        self.window = UIWindow()
        self.window?.rootViewController = self.program?.rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }
}

enum Msg: String, Message {
    case increment
    case decrement
}

typealias Model = Int

func update(state: Model, input: Msg) -> Model? {
    switch input {
        case .increment:
            return state + 1
        case .decrement:
            return state - 1
    }
}

func view(_ model: Model) -> VView<Msg> {
    return VView(children: [
        *VLabel(text: "\(model)"),
        *VButton(title: "+", handlers: [.touchUpInside : .increment]),
        *VButton(title: "-", handlers: [.touchUpInside : .decrement]),
    ])
}
```

Please see [Demo/AppDelegate.swift](Demo/AppDelegate.swift) for more information.

## Acknowledgement

- Evan Czaplicki: Creator of [Elm](http://elm-lang.org/)

## License

[MIT](LICENSE)
