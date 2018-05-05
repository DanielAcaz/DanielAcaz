//
//  ProductExtensions.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 30/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import Foundation

extension Product {
    
    @objc(addStatesObject:)
    @NSManaged public func addToStates(_ value: State)
    
    @objc(removeStatesObject:)
    @NSManaged public func removeFromStates(_ value: State)
    
    @objc(addStates:)
    @NSManaged public func addToStates(_ values: NSSet)
    
    @objc(removeStates:)
    @NSManaged public func removeFromStates(_ values: NSSet)
    
}
