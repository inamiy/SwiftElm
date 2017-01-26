import UIKit
import PlaygroundSupport
import Result
import ReactiveSwift
import VTree
import SwiftElm

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

let rootSize = rootView.bounds.size

typealias Model = Int

func update(model: Model, msg: Msg) -> (Model, Effect<Msg>)?
{
    switch msg {
        case let .tap(context):
            return (model, _printEffect("tap", context))
        case let .pan(context):
            return (model, _printEffect("pan", context))
    }
}

func _printEffect(_ title: String, _ context: GestureContext) -> Effect<Msg>
{
    return simpleEffect {
        print(title, context.location, context.state.rawValue)
    }
}

func view(_ model: Model) -> VView<Msg>
{
    let rootWidth = rootSize.width
    let rootHeight = rootSize.height

    let space: CGFloat = 20
    let buttonWidth = (rootWidth - space*3)/2

    func rootView(_ children: [AnyVTree<Msg>]) -> VView<Msg>
    {
        return VView(
            frame: CGRect(x: 0, y: 0, width: rootWidth, height: rootHeight),
            backgroundColor: .white,
            gestures: [.tap: ^Msg.tap, .pan: ^Msg.pan],
            children: children
        )
    }

    func label() -> VLabel<Msg>
    {
        return VLabel(
            frame: CGRect(x: 0, y: 40, width: rootWidth, height: 80),
            backgroundColor: .clear,
            font: .systemFont(ofSize: 16),
            text: "Tap anywhere to test gesture.",
            textAlignment: .center
        )
    }

    return rootView([
        *label()
    ])
}

let program = Program(initial: (0, .empty), update: update, view: view)
rootView.addSubview(program.rootViewController.view)

PlaygroundPage.current.liveView = rootView
