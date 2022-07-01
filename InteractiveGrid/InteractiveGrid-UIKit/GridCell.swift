import SwiftUI

struct GridCell: View {

    let model: Model

    var body: some View {
        VStack {
            Text(model.value.formatted())
                .font(.headline)

            Text(model.allowsContextMenu ? "long press for menu" : "no menu")
                .multilineTextAlignment(.center)
                .font(.subheadline)
        }
    }
}

struct GridCell_Previews: PreviewProvider {
    static var previews: some View {
        GridCell(model: Model(value: 9, style: .regular, allowsContextMenu: true))
    }
}
