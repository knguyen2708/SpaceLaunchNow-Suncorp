import Foundation
import UIKit

extension UIView {
    /// Pins all edges to superview
    func pinEdgesToSuperview() {
        guard let superview = self.superview else {
            preconditionFailure("View must be added to a superview before calling this")
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),
        ])
    }
    
    /// Pins all edges to superview layout margins
    func pinEdgesToSuperviewMargins() {
        guard let superview = self.superview else {
            preconditionFailure("View must be added to a superview before calling this")
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.layoutMarginsGuide.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.layoutMarginsGuide.rightAnchor),
        ])
    }
    
    /// Centers in superview, with some left & right spacing
    func centerInSuperview() {
        guard let superview = self.superview else {
            preconditionFailure("View must be added to a superview before calling this")
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(greaterThanOrEqualTo: superview.safeAreaLayoutGuide.leftAnchor, constant: 30),
            self.rightAnchor.constraint(lessThanOrEqualTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -30),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
    
    /// Constrains width to constant
    @discardableResult
    func constrainWidthTo(_ value: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = self.widthAnchor.constraint(equalToConstant: value)
        
        NSLayoutConstraint.activate([constraint])
        
        return constraint
    }
    
    /// Constrains height to constant
    @discardableResult
    func constrainHeightTo(_ value: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = self.heightAnchor.constraint(equalToConstant: value)
        
        NSLayoutConstraint.activate([constraint])
        
        return constraint
    }
    
    /*
    /// Constraints size to constant
    func constraintSizeTo(_ size: CGSize) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size.width),
            self.heightAnchor.constraint(equalToConstant: size.height),
        ])
    }
    */
}
