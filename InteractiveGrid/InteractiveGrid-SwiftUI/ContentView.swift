import SwiftUI
import Algorithms
import UniformTypeIdentifiers


final class Container: ObservableObject {
    @Published var data: [Model]

    init() {
        data = Model.makeMixNMatch()
    }
}

struct ContentView: View {

    @StateObject
    private var container = Container()

    @State
    private var shouldEnableContextMenu = true

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mint, .orange, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)

            InteractiveGrid(container: container)
        }

        .toolbar {
            ToolbarItem {
                Menu("Demos") {
                    Button("All Compact") {
                        withAnimation {
                            container.data = Model.makeAllCompact()
                        }

                    }

                    Button("All Regular") {
                        withAnimation {
                            container.data = Model.makeAllRegular()
                        }
                    }

                    Button("Mix-n-match") {
                        withAnimation {
                            container.data = Model.makeMixNMatch()
                        }
                    }

                    Button("Random") {
                        withAnimation {
                            container.data = Model.makeRandom()
                        }
                    }

                    Button("Shuffle") {
                        withAnimation {
                            container.data.append(Model(value: 100, style: .compact, allowsContextMenu: false))
                        }

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













struct Gadget<Content>: View where Content: View {

    private let content: () -> Content

    @State
    private var shouldScale: Bool = false

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            content()
                .padding()
                .background(Color.blue)
//                .contextMenu(menuItems: {
//                    Button("Go") {
//
//                    }
//                    Button("Stop") {
//
//                    }
//                })

        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .cornerRadius(16)
        .scaleEffect(x: shouldScale ? 0.9 : 1.0, y: shouldScale ? 0.9 : 1.0, anchor: .center)



    }
}


struct InteractiveGrid: View {

    @ObservedObject
    var container: Container

    @State
    private var dragging: Model?

    var body: some View {
        ScrollView {
            Grid {
                let chunked = container.data
                    .chunks(ofCount: 2)


                ForEach(chunked, id: \.self) { chunk in
                    switch (chunk.first?.style, chunk.last?.style) {

                    case (.compact, .compact):
                        GridRow {
                            Gadget {
                                GridCell(model: chunk.first!)
                            }

                            Gadget {
                                GridCell(model: chunk.last!)
                            }

                        }
                        .aspectRatio(1, contentMode: .fill)
                    case (.compact, .none):
                        GridRow {
                            Gadget {
                                GridCell(model: chunk.first!)
                            }
                        }
                        .aspectRatio(1, contentMode: .fill)
                    case (.compact, .regular):
                        GridRow {
                            Gadget {
                                GridCell(model: chunk.first!)
                            }
                        }
                        .aspectRatio(1, contentMode: .fill)

                        GridRow {
                            Gadget {
                                GridCell(model: chunk.last!)
                            }
                        }
                        .gridCellColumns(2)
                        .aspectRatio(2, contentMode: .fill)
                    case (.regular, .compact):
                        GridRow {
                            Gadget {
                                GridCell(model: chunk.first!)
                            }
                        }
                        .gridCellColumns(2)
                        .aspectRatio(2, contentMode: .fill)

                        GridRow {
                            Gadget {
                                GridCell(model: chunk.last!)
                            }
                        }
                        .gridCellColumns(2)
                        .aspectRatio(2, contentMode: .fill)

                    case (.regular, .regular):
                        GridRow {
                            Gadget {
                                GridCell(model: chunk.first!)
                            }
                        }
                        .gridCellColumns(2)
                        .aspectRatio(2, contentMode: .fill)

                        GridRow {
                            Gadget {
                                GridCell(model: chunk.last!)
                            }
                        }
                        .gridCellColumns(2)
                        .aspectRatio(2, contentMode: .fill)

                    default:
                        EmptyView()
                    }
                }
                .id(999999)
            }
            .padding(.horizontal)
            .border(.green)
            .animation(.default, value: container.data)
        }
        .border(.red)
    }


}

struct DragRelocateDelegate: DropDelegate {
    let item: Model
    @Binding var listData: [Model]
    @Binding var current: Model?

    func dropEntered(info: DropInfo) {
        print("Drop entered: \(info); \(item); \(current) ")
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                              toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}


struct ProbeFoo_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {

            ContentView()
                .navigationTitle("Demo")
        }
    }
}

struct GridCell: View {

    let model: Model

    var body: some View {
        HStack {
            Text(model.value.formatted())
        }
    }
}
