//
//  main.swift
//  Playground
//
//  Created by Brian Coyner on 7/1/22.
//

import Foundation
import Algorithms



struct Model: Hashable, Identifiable {
    enum Style {
        case compact
        case regular
    }

    var id: Int {
        return value
    }

    let value: Int
    let style: Style
    let allowsContextMenu: Bool
}

extension Model.Style: CustomStringConvertible {

    var description: String {
        switch self {
        case .compact:
            return "Compact"
        case .regular:
            return "Regular"
        }
    }

    var symbolName: String {
        switch self {
        case .compact:
            return "plus.square"
        case .regular:
            return "plus.rectangle"
        }
    }
}

extension Model {

    static func makeAllCompact() -> [Model] {
        return [
            Model(value: 1, style: .compact, allowsContextMenu: true),
            Model(value: 2, style: .compact, allowsContextMenu: true),
            Model(value: 3, style: .compact, allowsContextMenu: true),
            Model(value: 4, style: .compact, allowsContextMenu: true),
            Model(value: 5, style: .compact, allowsContextMenu: true),
            Model(value: 6, style: .compact, allowsContextMenu: true)
        ]
    }

    static func makeAllRegular() -> [Model] {
        return [
            Model(value: 1, style: .regular, allowsContextMenu: false),
            Model(value: 2, style: .regular, allowsContextMenu: false),
            Model(value: 3, style: .regular, allowsContextMenu: false),
            Model(value: 4, style: .regular, allowsContextMenu: false),
            Model(value: 5, style: .regular, allowsContextMenu: false),
            Model(value: 6, style: .regular, allowsContextMenu: false)
        ]
    }

    static func makeMixNMatch() -> [Model] {
        return [
            Model(value: 1, style: .regular, allowsContextMenu: true),
            Model(value: 2, style: .compact, allowsContextMenu: true),
            Model(value: 3, style: .compact, allowsContextMenu: true),
            Model(value: 4, style: .compact, allowsContextMenu: true),
            Model(value: 5, style: .compact, allowsContextMenu: true),
            Model(value: 6, style: .regular, allowsContextMenu: true),
            Model(value: 7, style: .compact, allowsContextMenu: true),
            Model(value: 8, style: .compact, allowsContextMenu: true),
            Model(value: 9, style: .regular, allowsContextMenu: true)
        ]
    }

    static func makeRandom() -> [Model] {
        let compactModels = (0..<Int.random(in: 1..<10)).map { Model(value: $0, style: .compact, allowsContextMenu: $0.isMultiple(of: 2)) }
        let regularModels = (100..<Int.random(in: 100..<110)).map { Model(value: $0, style: .regular, allowsContextMenu: $0.isMultiple(of: 3)) }
        return (compactModels + regularModels).shuffled()
    }
}

let models = [
    Model(value: 1, style: .compact, allowsContextMenu: false),
    Model(value: 2, style: .compact, allowsContextMenu: false),
    Model(value: 3, style: .compact, allowsContextMenu: false),
    Model(value: 4, style: .regular, allowsContextMenu: false),
    Model(value: 5, style: .compact, allowsContextMenu: false),
    Model(value: 6, style: .compact, allowsContextMenu: false),
    Model(value: 7, style: .regular, allowsContextMenu: false),
    Model(value: 8, style: .regular, allowsContextMenu: false),
    Model(value: 9, style: .regular, allowsContextMenu: false),
    Model(value: 10, style: .compact, allowsContextMenu: false),
    Model(value: 11, style: .compact, allowsContextMenu: false),
    Model(value: 12, style: .compact, allowsContextMenu: false),
]
//let chunked = models.chunks(ofCount: 2)
//let chunked = models
//    .chunks(ofCount: 2)


let combinations = models.combinations(ofCount: 3)
for combination in combinations {
    print(combination)
}
//
//
//
//let foo = chunked
//    .map { Array($0) }
//
//
//let bar = foo
//    .chunked { a, b in
//        return a.style == .compact && b.style == .compact
//    }





//    .chunks(ofCount: 2)
//    .flatMap { Array($0) }

//
//for chunk in chunked {
//    print(chunk)
//}







//print(chunked)
