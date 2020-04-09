//
//  StudentModel.swift
//  RealmSwift5
//
//  Created by 酒井専冴 on 2020/04/03.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import RealmSwift

class Student: Object{
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    var fullName: String {
        return "\(lastName)\(firstName)"
    }
    @objc dynamic var createdAt: String = ""
    @objc dynamic var id: String = ""
    
    //1 vs many
    let cats = List<Cat>()
    //1 vs 1
    @objc dynamic var dog: Dog?
    
}
class Pet: Object {
    @objc dynamic var name: String = ""
    dynamic var age: Int = 0
}
class Dog: Pet {
    
    //studentへの逆方向の関連
    let student = LinkingObjects(fromType: Student.self, property: "dog")
    
}
class Cat: Pet {
    //studentへの逆方向の関連
    let student = LinkingObjects(fromType: Student.self, property: "cats")
}
class uiqueObject: Object{
    
    @objc dynamic var id = 0
    @objc dynamic var value = ""
    @objc dynamic var optionalValue: String?
    
    override static func primaryKey() -> String? {
        //id is Propaty primaryKey
        return "id"
    }
}

class ToDo: Object{
    
    @objc dynamic var ToDo: String = ""
    @objc dynamic var createdAt: String = ""
}
