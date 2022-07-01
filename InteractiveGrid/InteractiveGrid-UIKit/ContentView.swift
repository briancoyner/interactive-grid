import SwiftUI

struct ContentView: View {

    @State
    private var models: [Model] = Model.makeAllCompact()

    @State
    private var shouldEnableContextMenu = true

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mint, .orange, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(.ultraThinMaterial)

            InteractiveGridViewControllerRepresentable(models: models)
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar {
            ToolbarItem {
                Menu("Demos") {
                    Button("All Compact") {
                        models = Model.makeAllCompact()
                    }

                    Button("All Regular") {
                        models = Model.makeAllRegular()
                    }

                    Button("Mix-n-match") {
                        models = Model.makeMixNMatch()
                    }

                    Button("Random") {
                        models = Model.makeRandom()
                    }
                }
            }
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
