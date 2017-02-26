// Generated using Sourcery 0.5.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import VTree

extension Msg: Message
{
    public init?(rawValue: RawMessage)
    {
        switch rawValue.funcName {

            // .tap(GestureContext)
            case "tap":
                let arguments = rawValue.arguments
                if let context = GestureContext(rawValue: arguments) {
                    self = .tap(context)
                }
                else {
                    return nil
                }

            // .pan(PanGestureContext)
            case "pan":
                let arguments = rawValue.arguments
                if let context = PanGestureContext(rawValue: arguments) {
                    self = .pan(context)
                }
                else {
                    return nil
                }

            // .longPress(GestureContext)
            case "longPress":
                let arguments = rawValue.arguments
                if let context = GestureContext(rawValue: arguments) {
                    self = .longPress(context)
                }
                else {
                    return nil
                }

            // .swipe(GestureContext)
            case "swipe":
                let arguments = rawValue.arguments
                if let context = GestureContext(rawValue: arguments) {
                    self = .swipe(context)
                }
                else {
                    return nil
                }

            // .pinch(PinchGestureContext)
            case "pinch":
                let arguments = rawValue.arguments
                if let context = PinchGestureContext(rawValue: arguments) {
                    self = .pinch(context)
                }
                else {
                    return nil
                }

            // .rotation(RotationGestureContext)
            case "rotation":
                let arguments = rawValue.arguments
                if let context = RotationGestureContext(rawValue: arguments) {
                    self = .rotation(context)
                }
                else {
                    return nil
                }

            default:
                return nil
        }
    }

    public var rawValue: RawMessage
    {
        switch self {

            case let .tap(context):
                return RawMessage(funcName: "tap", arguments: context.rawValue)

            case let .pan(context):
                return RawMessage(funcName: "pan", arguments: context.rawValue)

            case let .longPress(context):
                return RawMessage(funcName: "longPress", arguments: context.rawValue)

            case let .swipe(context):
                return RawMessage(funcName: "swipe", arguments: context.rawValue)

            case let .pinch(context):
                return RawMessage(funcName: "pinch", arguments: context.rawValue)

            case let .rotation(context):
                return RawMessage(funcName: "rotation", arguments: context.rawValue)

        }
    }
}

