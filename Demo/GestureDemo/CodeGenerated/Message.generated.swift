// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import VTree
extension Msg: Message
{
    public init?(rawMessage: RawMessage)
    {
        switch rawMessage.funcName {
            case "increment":
                self = .increment
            case "decrement":
                self = .decrement
            // .tap(GestureContext)
            case "tap":
                let arguments = rawMessage.arguments
                if let context = GestureContext(rawArguments: arguments) {
                    self = .tap(context)
                }
                else {
                    return nil
                }
            // .pan(PanGestureContext)
            case "pan":
                let arguments = rawMessage.arguments
                if let context = PanGestureContext(rawArguments: arguments) {
                    self = .pan(context)
                }
                else {
                    return nil
                }
            // .longPress(GestureContext)
            case "longPress":
                let arguments = rawMessage.arguments
                if let context = GestureContext(rawArguments: arguments) {
                    self = .longPress(context)
                }
                else {
                    return nil
                }
            // .swipe(GestureContext)
            case "swipe":
                let arguments = rawMessage.arguments
                if let context = GestureContext(rawArguments: arguments) {
                    self = .swipe(context)
                }
                else {
                    return nil
                }
            // .pinch(PinchGestureContext)
            case "pinch":
                let arguments = rawMessage.arguments
                if let context = PinchGestureContext(rawArguments: arguments) {
                    self = .pinch(context)
                }
                else {
                    return nil
                }
            // .rotation(RotationGestureContext)
            case "rotation":
                let arguments = rawMessage.arguments
                if let context = RotationGestureContext(rawArguments: arguments) {
                    self = .rotation(context)
                }
                else {
                    return nil
                }
            // .dummy(DummyContext)
            case "dummy":
                let arguments = rawMessage.arguments
                if let context = DummyContext(rawArguments: arguments) {
                    self = .dummy(context)
                }
                else {
                    return nil
                }
            default:
                return nil
        }
    }

    public var rawMessage: RawMessage
    {
        switch self {
            case .increment:
                return RawMessage(funcName: "increment", arguments: [])
            case .decrement:
                return RawMessage(funcName: "decrement", arguments: [])
            case let .tap(context):
                return RawMessage(funcName: "tap", arguments: context.rawArguments)
            case let .pan(context):
                return RawMessage(funcName: "pan", arguments: context.rawArguments)
            case let .longPress(context):
                return RawMessage(funcName: "longPress", arguments: context.rawArguments)
            case let .swipe(context):
                return RawMessage(funcName: "swipe", arguments: context.rawArguments)
            case let .pinch(context):
                return RawMessage(funcName: "pinch", arguments: context.rawArguments)
            case let .rotation(context):
                return RawMessage(funcName: "rotation", arguments: context.rawArguments)
            case let .dummy(context):
                return RawMessage(funcName: "dummy", arguments: context.rawArguments)
        }
    }
}
