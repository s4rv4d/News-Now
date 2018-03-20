//
//  Categories.swift
//  News Now
//
//  Created by Sarvad shetty on 3/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import Foundation
import RealmSwift

class RealmString: Object {
    @objc dynamic var stringValue = ""
}

class Categories: Object {
    var category: [String] {
        get {
            return _conversion.map { $0.stringValue }
        }
        set {
            _conversion.removeAll()
            _conversion.append(objectsIn: newValue.map { RealmString(value: [$0]) })
        }
    }
    let _conversion = List<RealmString>()
}
