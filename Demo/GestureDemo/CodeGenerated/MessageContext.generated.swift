// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import VTree

extension DummyContext: MessageContext
{
    public init?(rawArguments: [Any])
    {
        guard rawArguments.count == 0 else { return nil }
        self = DummyContext()
    }

    public var rawArguments: [Any]
    {
        return []
    }
}
