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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
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
                    
                    HStack (spacing: 10) {
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                            .glow(color: .white, radius: 10, opacity: self.isDarkMode ? 0.55 : 0.0)

                        Spacer()
                        
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule().stroke(Color.white, lineWidth: 2)
                            )
                        
                        Button {
                            isDarkMode.toggle()
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }

                    } //: HStack
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // MARK: - TASKS
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .listStyle(.insetGrouped)
                    .shadow(color: .black.opacity(0.5), radius: 10)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                    .glow(color: .white, radius: 10, opacity: self.isDarkMode ? 0.35 : 0.0)
                    
                    // MARK: - NEW TASK BUTTON
                    Button {
                        withAnimation {
                            showNewTaskItem = true
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 85, alignment: .center)
                            .foregroundColor(.white)
                            .background(
                                self.isDarkMode ? Color.black : Color.pink
                            )
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 0)
                            .glow(color: .white, radius: 10, opacity: self.isDarkMode ? 0.5 : 0.0)
                    }
                    .padding()
                } //: VSTACK
                .blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.25), value: showNewTaskItem)
                
                // MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    BlankView(backgroundColor: isDarkMode ? .black : .gray,
                              backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                        .transition(.move(edge: .bottom))
                }
            } //: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .navigationBarHidden(true)
            .background(
                self.isDarkMode ?
                backgroundGradientDark.ignoresSafeArea() : backgroundGradientLight.ignoresSafeArea()
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
