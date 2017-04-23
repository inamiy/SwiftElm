import UIKit
import VTree
import Flexbox

enum Msg: AutoMessage
{
    case increment
    case decrement
}

struct Model
{
    static let initial = Model(count: 0)

    let rootSize = UIScreen.main.bounds.size
    let count: Int
}

func update(_ model: Model, _ msg: Msg) -> Model?
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
            text: "\(count)",
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
