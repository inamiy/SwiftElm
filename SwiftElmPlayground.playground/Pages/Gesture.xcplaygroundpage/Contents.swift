import UIKit
import PlaygroundSupport
import Result
import ReactiveSwift
import VTree
import SwiftElm

struct Model
{
    let rootSize = CGSize(width: 320, height: 480)
    let message: String
    let cursor: Cursor?

    struct Cursor
    {
        let frame: CGRect
        let backgroundColor: UIColor
    }
}

extension Model.Cursor
{
    init?(msg: Msg)
    {
        switch msg {
        case let .tap(context):
            let frame = CGRect(origin: context.location, size: .zero)
                .insetBy(dx: -20, dy: -20)
            self = Model.Cursor(frame: frame, backgroundColor: .orange)
        case let .pan(context) where context.state == .changed:
            let frame = CGRect(origin: context.location, size: .zero)
                .insetBy(dx: -20, dy: -20)
            self = Model.Cursor(frame: frame, backgroundColor: .green)
        default:
            return nil
        }
    }
}

func update(_ model: Model, _ msg: Msg) -> (Model, Effect<Msg>)
{
    let argsString = msg.rawValue.arguments.map { "\($0)" }.joined(separator: "\n")
    let cursor = Model.Cursor(msg: msg)

    let model = Model(
        message: "\(msg.rawValue.funcName)\n\(argsString)",
        cursor: cursor
    )

    return (model, simpleEffect {
        let argsString = msg.rawValue.arguments.map { "\($0)" }.joined(separator: " ")
        print("\(msg.rawValue.funcName) \(argsString)")
        print(msg, "\n", cursor ?? "no cursor")
    })
}

func view(model: Model) -> VView<Msg>
{
    let rootWidth = model.rootSize.width
    let rootHeight = model.rootSize.height

    func rootView(_ children: [AnyVTree<Msg>?]) -> VView<Msg>
    {
        return VView(
            frame: CGRect(x: 0, y: 0, width: rootWidth, height: rootHeight),
            backgroundColor: .white,
            gestures: [.tap(^Msg.tap), .pan(^Msg.pan), .longPress(^Msg.longPress), .swipe(^Msg.swipe), .pinch(^Msg.pinch), .rotation(^Msg.rotation)],
            children: children.flatMap { $0 }
        )
    }

    func label(_ message: String) -> VLabel<Msg>
    {
        return VLabel(
            frame: CGRect(x: 0, y: 40, width: rootWidth, height: 300),
            backgroundColor: .clear,
            text: message,
            textAlignment: .center,
            font: .systemFont(ofSize: 24)
        )
    }

    func noteLabel() -> VLabel<Msg>
    {
        return VLabel(
            frame: CGRect(x: 0, y: 350, width: rootWidth, height: 80),
            backgroundColor: .clear,
            text: "Tap anywhere to test gesture.",
            textAlignment: .center,
            font: .systemFont(ofSize: 20)
        )
    }

    func cursorView(_ cursor: Model.Cursor) -> VView<Msg>
    {
        return VView(
            key: key("cursor"),
            frame: cursor.frame,
            backgroundColor: cursor.backgroundColor
        )
    }

    return rootView([
        *label(model.message),
        *noteLabel(),
        model.cursor.map(cursorView).map(*)
    ])
}

// MARK: Main

let model = Model(message: "Initial", cursor: nil)

let rootView = UIView(frame: CGRect(origin: .zero, size: model.rootSize))
rootView.backgroundColor = .white

let program = Program(initial: (model, .empty), update: update, view: view)
rootView.addSubview(program.rootViewController.view)

PlaygroundPage.current.liveView = rootView
