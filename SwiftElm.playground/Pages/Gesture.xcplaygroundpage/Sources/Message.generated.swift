// Generated using Sourcery 0.4.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import VTree

extension Msg: Message
{
    public init?(rawValue: String)
    {
        switch rawValue {

            // .tap(GestureContext)
            case _ where rawValue.hasPrefix("tap\(GestureContext.separator)"):
                let count = "tap\(GestureContext.separator)".characters.count
                let fromIndex = rawValue.index(rawValue.startIndex, offsetBy: count)
                let contextValue = rawValue.substring(from: fromIndex)
                if let context = GestureContext(rawValue: contextValue) {
                    self = .tap(context)
                }
                else {
                    return nil
                }

            // .pan(GestureContext)
            case _ where rawValue.hasPrefix("pan\(GestureContext.separator)"):
                let count = "pan\(GestureContext.separator)".characters.count
                let fromIndex = rawValue.index(rawValue.startIndex, offsetBy: count)
                let contextValue = rawValue.substring(from: fromIndex)
                if let context = GestureContext(rawValue: contextValue) {
                    self = .pan(context)
                }
                else {
                    return nil
                }

            default:
                return nil
        }
    }

    public var rawValue: String
    {
        switch self {

            case let .tap(context):
                return context.rawMessage("tap")

            case let .pan(context):
                return context.rawMessage("pan")

        }
    }
}

