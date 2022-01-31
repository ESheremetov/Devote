//
//  ContentView.swift
//  Devote
//
//  Created by Егор Шереметов on 28.01.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @State private var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - FUNCTIONS

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                     // MARK: - HEADER
                    Spacer(minLength: 80)
                    
                    // MARK: - TASKS
                    List {
                        ForEach(items) { item in
                            VStack (alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: LIST ITEM
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .listStyle(.insetGrouped)
                    .shadow(color: .black.opacity(0.5), radius: 10)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                    
                    // MARK: - NEW TASK BUTTON
                    Button {
                        showNewTaskItem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 85, alignment: .center)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.pink, .blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 0)
                    }
                    .padding()
                } //: VSTACK
                // MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            showNewTaskItem = false
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            } //: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
            } //: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea()
            )
        } //: NAVIGATION
        .navigationViewStyle(.stack)
    } //: BODY
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
