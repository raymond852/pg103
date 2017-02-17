//
//  UIControl+Target.swift
//  Created by Collin Hundley on 1/16/16
//

// Useful code snippet for Xcode autocompletion:
// addTarget(<#UIControlEvents#>) {[unowned self] in self.<#method#>}


import UIKit

public extension UIControl {
    
    /// The registry contains a weak reference to all UIControl objects that have been given targets, the events to observe, and the closures to execute when the events are triggered.
    fileprivate static var actionRegistry = [Action]()
    
    // MARK: Public methods
    
    /// Adds a target to the receiv er for the given event, which triggers the given action.
    public func addTarget(_ forControlEvents: UIControlEvents, action: @escaping () -> Void) {
        self.addTarget(forEvent: forControlEvents, action: action)
    }
    
    // MARK: Private methods
    
    /// A wrapper used to maintain a weak reference to a UIControl, an event to observe, and a function to call.
    fileprivate class Action: AnyObject {
        weak var object: UIControl?
        var event: UIControlEvents
        var function: Any
        init(object: UIControl, event: UIControlEvents, function:  @escaping () -> Void) {
            self.object = object
            self.event = event
            self.function = function
        }
        init(object: UIControl, event: UIControlEvents, function: @escaping (_ sender: UIControl) -> Void) {
            self.object = object
            self.event = event
            self.function = function
        }
    }
    
    /// Adds the target to the actual object and adds the action to the registry.
    fileprivate func addTarget(forEvent event: UIControlEvents, action: @escaping () -> Void) {
        var actionString: Selector!
        switch event {
            
            // Touch events
            
        case UIControlEvents.touchDown:
            actionString = #selector(UIControl.touchDown(_:))
        case UIControlEvents.touchDownRepeat:
            actionString = #selector(UIControl.touchDownRepeat(_:))
        case UIControlEvents.touchDragInside:
            actionString = #selector(UIControl.touchDragInside(_:))
        case UIControlEvents.touchDragOutside:
            actionString = #selector(UIControl.touchDragOutside(_:))
        case UIControlEvents.touchDragEnter:
            actionString = #selector(UIControl.touchDragEnter(_:))
        case UIControlEvents.touchDragExit:
            actionString = #selector(UIControl.touchDragExit(_:))
        case UIControlEvents.touchUpInside:
            actionString = #selector(UIControl.touchUpInside(_:))
        case UIControlEvents.touchUpOutside:
            actionString = #selector(UIControl.touchUpOutside(_:))
        case UIControlEvents.touchCancel:
            actionString = #selector(UIControl.touchCancel(_:))
            
            // UISlider events
            
        case UIControlEvents.valueChanged:
            actionString = #selector(UIControl.valueChanged(_:))
            
            // UITextField events
            
        case UIControlEvents.editingDidBegin:
            actionString = #selector(UIControl.editingDidBegin(_:))
        case UIControlEvents.editingChanged:
            actionString = #selector(UIControl.editingChanged(_:))
        case UIControlEvents.editingDidEnd:
            actionString = #selector(UIControl.editingDidEnd(_:))
        case UIControlEvents.editingDidEndOnExit:
            actionString = #selector(UIControl.editingDidEndOnExit(_:))
            
            // Other events
            
        case UIControlEvents.allTouchEvents:
            actionString = #selector(UIControl.allTouchEvents(_:))
        case UIControlEvents.allEditingEvents:
            actionString = #selector(UIControl.allEditingEvents(_:))
        case UIControlEvents.applicationReserved:
            actionString = #selector(UIControl.applicationReserved(_:))
        case UIControlEvents.systemReserved:
            actionString = #selector(UIControl.systemReserved(_:))
        case UIControlEvents.allEvents:
            actionString = #selector(UIControl.allEvents(_:))
            
        default: // Unrecognized event
            break
        }
        
        // Add the Objective-C target
        self.addTarget(self, action: actionString, for: event)
        
        // Register action
        UIControl.registerAction(Action(object: self, event: event, function: action))
    }
    
    /// Adds an action to the registry.
    fileprivate static func registerAction(_ action: Action) {
        self.cleanRegistry()
        // Add action to the registry
        self.actionRegistry.append(action)
    }
    
    /// Triggers the actions for the correct control events.
    fileprivate func triggerAction(_ forObject: UIControl, event: UIControlEvents) {
        for action in UIControl.actionRegistry {
            if action.object == forObject && action.event == event {
                if let function = action.function as? () -> Void {
                    function()
                } else if let function = action.function as? (_ sender: UIControl) -> Void {
                    function(forObject)
                }
            }
        }
        UIControl.cleanRegistry()
    }
    
    /// Cleans the registry, removing any actions whose object has already been released.
    /// This guarantees that no memory leaks will occur over time.
    fileprivate static func cleanRegistry() {
        UIControl.actionRegistry = UIControl.actionRegistry.filter({ $0.object != nil })
    }
    
    
    // MARK: Targets given to the Objective-C selectors
    
    @objc fileprivate func touchDown(_ sender: UIControl) {
        triggerAction(sender, event: .touchDown)
    }
    @objc fileprivate func touchDownRepeat(_ sender: UIControl) {
        triggerAction(sender, event: .touchDownRepeat)
    }
    @objc fileprivate func touchDragInside(_ sender: UIControl) {
        triggerAction(sender, event: .touchDragInside)
    }
    @objc fileprivate func touchDragOutside(_ sender: UIControl) {
        triggerAction(sender, event: .touchDragOutside)
    }
    @objc fileprivate func touchDragEnter(_ sender: UIControl) {
        triggerAction(sender, event: .touchDragEnter)
    }
    @objc fileprivate func touchDragExit(_ sender: UIControl) {
        triggerAction(sender, event: .touchDragExit)
    }
    @objc fileprivate func touchUpInside(_ sender: UIControl) {
        triggerAction(sender, event: .touchUpInside)
    }
    @objc fileprivate func touchUpOutside(_ sender: UIControl) {
        triggerAction(sender, event: .touchUpOutside)
    }
    @objc fileprivate func touchCancel(_ sender: UIControl) {
        triggerAction(sender, event: .touchCancel)
    }
    @objc fileprivate func valueChanged(_ sender: UIControl) {
        triggerAction(sender, event: .valueChanged)
    }
    @objc fileprivate func primaryActionTriggered(_ sender: UIControl) {
        if #available(iOS 9.0, *) {
            triggerAction(sender, event: .primaryActionTriggered)
        } else {
            // Fallback on earlier versions
        }
    }
    @objc fileprivate func editingDidBegin(_ sender: UIControl) {
        triggerAction(sender, event: .editingDidBegin)
    }
    @objc fileprivate func editingChanged(_ sender: UIControl) {
        triggerAction(sender, event: .editingChanged)
    }
    @objc fileprivate func editingDidEnd(_ sender: UIControl) {
        triggerAction(sender, event: .editingDidEnd)
    }
    @objc fileprivate func editingDidEndOnExit(_ sender: UIControl) {
        triggerAction(sender, event: .editingDidEndOnExit)
    }
    @objc fileprivate func allTouchEvents(_ sender: UIControl) {
        triggerAction(sender, event: .allTouchEvents)
    }
    @objc fileprivate func allEditingEvents(_ sender: UIControl) {
        triggerAction(sender, event: .allEditingEvents)
    }
    @objc fileprivate func applicationReserved(_ sender: UIControl) {
        triggerAction(sender, event: .applicationReserved)
    }
    @objc fileprivate func systemReserved(_ sender: UIControl) {
        triggerAction(sender, event: .systemReserved)
    }
    @objc fileprivate func allEvents(_ sender: UIControl) {
        triggerAction(sender, event: .allEvents)
    }
    
}
