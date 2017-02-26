import VTree

public enum Msg: AutoMessage
{
    case tap(GestureContext)
    case pan(PanGestureContext)
    case longPress(GestureContext)
    case swipe(GestureContext)
    case pinch(PinchGestureContext)
    case rotation(RotationGestureContext)
}
