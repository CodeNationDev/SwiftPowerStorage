//
import Foundation

public enum SPSResult<T>: Equatable {
    public static func == (lhs: SPSResult<T>, rhs: SPSResult<T>) -> Bool {
        var valueLHS = false
        var valueRHS = false
        
        switch lhs {
        case .success(value: _): valueLHS = true
        default: valueLHS = false
        }
        switch rhs {
        case .success(value: _): valueRHS = true
        default: valueRHS = false
        }
        
        return valueLHS == valueRHS
        
    }
    
    case success(value: T)
    case failure
}
