import VTree

/// Complex `Message` type that has associated values.
/// - Important: See `VTree.Message` comment documentation for more detail.
/// - Note: This file must be inside `xcplaygroundpage/Sources` for supporting code-generation via `Sourcery`.
public enum Msg: AutoMessage
{
    case tap(GestureContext)
    case pan(GestureContext)
}
