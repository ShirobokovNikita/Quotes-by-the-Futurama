//
//  IPersonsViewDataSource.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 06.12.22.
//

import Foundation

// MARK: ИМИТАЦИЯ КЭША

protocol IPersonsViewDataSource: AnyObject {
    func save(_ items: [Person])
    func getPerson(at index: Int) -> Person
    
    var itemsCount: Int { get }
}

class PersonsViewDataSource: IPersonsViewDataSource {
    private var items: [Person] = []
    
    var itemsCount: Int {
        items.count
    }
    
    func getPerson(at index: Int) -> Person {
        items[index]
    }
    
    func save(_ items: [Person]) {
        self.items = items
    }
}
