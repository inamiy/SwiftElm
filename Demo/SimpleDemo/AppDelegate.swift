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
        let model = Model(count: 0)
        self.program = Program(model: model, update: update, view: view)

        self.window = UIWindow()
        self.window?.rootViewController = self.program?.rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }
}

enum Msg: AutoMessage
{
    case increment
    case decrement
}

struct Model
{
    let rootSize = UIScreen.main.bounds.size
    let count: Int
}

func update(_ model: Model, _ msg: Msg) -> Model
{
    switch msg {
        case .increment:
            return Model(count: model.count + 1)
        case .decrement:
            return Model(count: model.count - 1)
    }
}

func view(model: Model) -> VView<Msg>
{
    let rootWidth = model.rootSize.width
    let rootHeight = model.rootSize.height

    let space: CGFloat = 20
    let buttonWidth = (rootWidth - space*3)/2

    func rootView(_ children: [AnyVTree<Msg>] = []) -> VView<Msg>
    {
        return VView(
            frame: CGRect(x: 0, y: 0, width: rootWidth, height: rootHeight),
            backgroundColor: .white,
            children: children
        )
    }

    func label(_ count: Int) -> VLabel<Msg>
    {
        return VLabel(
            frame: CGRect(x: 0, y: 40, width: rootWidth, height: 80),
            backgroundColor: .clear,
            text: "\(count)",
            textAlignment: .center,
            font: .systemFont(ofSize: 48)
        )
    }

    func incrementButton() -> VButton<Msg>
    {
        return VButton(
            frame: CGRect(x: rootWidth/2 + space/2, y: 150, width: buttonWidth, height: 50),
            backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            title: "+",
            font: .systemFont(ofSize: 24),
            handlers: [.touchUpInside: .increment]
        )
    }

    func decrementButton() -> VButton<Msg>
    {
        return VButton(
            frame: CGRect(x: space, y: 150, width: buttonWidth, height: 50),
            backgroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),
            title: "-",
            font: .systemFont(ofSize: 24),
            handlers: [.touchUpInside: .decrement]
        )
    }

    let count = model.count

    return rootView([
        *label(count),
        *incrementButton(),
        *decrementButton()
    ])
}
