//
//  ListRowItemView.swift
//  Devote
//
//  Created by Егор Шереметов on 03.02.2022.
//

import SwiftUI

struct ListRowItemView: View {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    @State var showDescription: Bool = false
    
    // MARK: - BODY
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Toggle(isOn: $item.completion) {
                Text(item.task ?? "")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(item.completion ? .pink : .primary)
                    .padding(.vertical, 12)
                    .animation(.default, value: item.completion)
            } //: TOGGLE
            .toggleStyle(CheckBoxStyle())
            .onReceive(item.objectWillChange) { _ in
                if self.viewContext.hasChanges {
                    try? self.viewContext.save()
                }
            }
            .onTapGesture {
                showDescription.toggle()
            }
            if showDescription {
                Text(item.details == "" ? "No description" : item.details ?? "Empty")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
            }
        } //: VSTACK
    } //: BODY
}

struct ListRowItemView_Previews: PreviewProvider {
 
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newItem = Item.init(context: context)
        newItem.task = "New Task"
        newItem.details = "Some Long detail becauessajkgqwleghqlewhfjql;iwjdlqwhfljqwbgjlqbwglqnwklfjnqlkwdjlqkwje"
        return ListRowItemView(item: newItem)
            .environment(\.managedObjectContext, context)
            .previewLayout(.sizeThatFits)
            .background(Color.gray)
    }
}
