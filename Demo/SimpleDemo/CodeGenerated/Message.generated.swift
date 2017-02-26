// Generated using Sourcery 0.5.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import VTree

extension Msg: Message
{
    public init?(rawValue: RawMessage)
    {
        switch rawValue.funcName {

            case "increment":
                self = .increment

            case "decrement":
                self = .decrement

            default:
                return nil
        }
    }

    public var rawValue: RawMessage
    {
        switch self {

            case .increment:
                return RawMessage(funcName: "increment", arguments: [])

            case .decrement:
                return RawMessage(funcName: "decrement", arguments: [])

        }
    }
}

