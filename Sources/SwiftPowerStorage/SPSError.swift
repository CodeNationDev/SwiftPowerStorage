//
import Foundation

public struct SPSError: Error {
    public enum ErrorType { case valueNotFound, typeError }
    
    var message: String
    var errorType: ErrorType
}

