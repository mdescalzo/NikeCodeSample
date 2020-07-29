//
//  Box.swift
//
//  SOURCE:  raywenderlich.com
//

import Foundation

/**
    Basic Box class to allow property observation.
 */
final class Box<T> {
    
    /**
     Optional closure called when value is set
     */
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    /**
    Box initializer
     
     - Parameter value: Initial value
     */
    init(_ value: T) {
        self.value = value
    }
    
    /**
     Binds a closure to the encapsuled value (T) to be executed when value is changed.
     
     - Parameter listener: Closure ( (T) -> Void ) to be executed on value change.
     */
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
