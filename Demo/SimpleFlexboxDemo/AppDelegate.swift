import UIKit
import VTree
import Flexbox
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
            backgroundColor: .white,
            flexbox: Flexbox.Node(
                size: model.rootSize,
                flexDirection: .column,
                justifyContent: .center,
                alignItems: .center,
                padding: Edges(uniform: space)
            ),
            children: children
        )
    }

    func label(_ count: Int) -> VLabel<Msg>
    {
        return VLabel(
            backgroundColor: .clear,
            text: spellOut(count),
            textAlignment: .center,
            font: .systemFont(ofSize: 48),
            flexbox: Flexbox.Node(
                maxSize: CGSize(width: rootWidth - space*2, height: CGFloat.nan),
                padding: Edges(left: 50, right: 50)
            )
        )
    }

    func buttons(_ children: [AnyVTree<Msg>]) -> VView<Msg>
    {
        return VView(
            flexbox: Flexbox.Node(
                size: CGSize(width: CGFloat.nan, height: 70),
                flexDirection: .row,
                justifyContent: .spaceBetween,
                alignSelf: .stretch
            ),
            children: children
        )
    }

    func incrementButton() -> VButton<Msg>
    {
        return VButton(
            backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            title: "+",
            font: .systemFont(ofSize: 24),
            flexbox: Flexbox.Node(
                flexGrow: 1,
                margin: Edges(uniform: 10)
            ),
            handlers: [.touchUpInside: .increment]
        )
    }

    func decrementButton() -> VButton<Msg>
    {
        return VButton(
            backgroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),
            title: "-",
            font: .systemFont(ofSize: 24),
            flexbox: Flexbox.Node(
                flexGrow: 1,
                margin: Edges(uniform: 10)
            ),
            handlers: [.touchUpInside: .decrement]
        )
    }

    let count = model.count

    return rootView([
        *label(count),
        *buttons([
            *decrementButton(),
            *incrementButton()
        ])
    ])
}

// MARK: Private

private let _spellOutFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter
}()

/// e.g. "23" becomes "twenty-three".
public func spellOut(_ number: Int) -> String?
{
    return _spellOutFormatter.string(from: NSNumber(value: number))
}

