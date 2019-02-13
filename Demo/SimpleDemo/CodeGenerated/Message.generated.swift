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
        }
    }
}
