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

enum Msg: String, Message
{
    case increment
    case decrement
}

typealias Model = Int

func update(state: Model, input: Msg) -> Model?
{
    switch input {
        case .increment:
            return state + 1
        case .decrement:
            return state - 1
    }
}

func view(_ model: Model) -> VView<Msg>
{
    let rootWidth = UIScreen.main.bounds.width
    let rootHeight = UIScreen.main.bounds.height

    let space: CGFloat = 20
    let buttonWidth = (rootWidth - space*3)/2

    func rootView(_ children: [AnyVTree<Msg>]) -> VView<Msg>
    {
        return VView(
            frame: CGRect(x: 0, y: 0, width: rootWidth, height: rootHeight),
            backgroundColor: .white,
            children: children
        )
    }

    func label(_ text: String) -> VLabel<Msg>
    {
        return VLabel(
            frame: CGRect(x: 0, y: 40, width: rootWidth, height: 80),
            backgroundColor: .clear,
            font: .systemFont(ofSize: 48),
            text: "\(text)",
            textAlignment: .center
        )
    }

    func incrementButton() -> VButton<Msg>
    {
        return VButton(
            frame: CGRect(x: rootWidth/2 + space/2, y: 150, width: buttonWidth, height: 50),
            backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            title: "+",
            titleFont: .systemFont(ofSize: 24),
            handlers: [.touchUpInside : .increment]
        )
    }

    func decrementButton() -> VButton<Msg>
    {
        return VButton(
            frame: CGRect(x: space, y: 150, width: buttonWidth, height: 50),
            backgroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),
            title: "-",
            titleFont: .systemFont(ofSize: 24),
            handlers: [.touchUpInside : .decrement]
        )
    }

    return rootView([
        *label("\(model)"),
        *incrementButton(),
        *decrementButton(),
    ])
}
