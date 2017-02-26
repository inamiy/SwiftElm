import UIKit

extension UIGestureRecognizerState: CustomDebugStringConvertible
{
    public var debugDescription: String
    {
        switch self {
            case .possible:
                return "possible"
            case .began:
                return "began"
            case .changed:
                return "changed"
            case .ended:
                return "ended"
            case .cancelled:
                return "cancelled"
            case .failed:
                return "failed"
        }
    }
}
