import UIKit
import VTree
import Flexbox

/// Complex `Message` type that has associated values.
/// - Important: See `VTree.Message` comment documentation for more detail.
enum Msg: AutoMessage
{
    case increment
    case decrement
    case tap(GestureContext)
    case pan(PanGestureContext)
    case longPress(GestureContext)
    case swipe(GestureContext)
    case pinch(PinchGestureContext)
    case rotation(RotationGestureContext)

    case dummy(DummyContext)
}

/// Custom `MessageContext` that is recognizable in Sourcery.
struct DummyContext: AutoMessageContext {}

struct Model
{
    static let initial = Model(message: "Initial", cursor: nil)

    let rootSize = UIScreen.main.bounds.size
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

func update(_ model: Model, _ msg: Msg) -> Model?
{
    print(msg)  // Warning: impure logging

    let argsString = msg.rawMessage.arguments.map { "\($0)" }.joined(separator: "\n")
    let cursor = Model.Cursor(msg: msg)

    return Model(
        message: "\(msg.rawMessage.funcName)\n\(argsString)",
        cursor: cursor
    )
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
            key: key("label"),
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
            key: key("noteLabel"),
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
