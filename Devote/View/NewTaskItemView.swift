//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Егор Шереметов on 30.01.2022.
//

import SwiftUI
import Combine


struct NewTaskItemView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var task: String = ""
    @State private var description: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    @State private var taskIsValid: Bool = true
    
    private let taskLimit: Int = 15
    
    // MARK: - FUNCTIONS
    private func limitText(_ threshold: Int) {
        if task.count >= threshold {
            task = String(task.prefix(threshold))
            taskIsValid = false
        } else {
            taskIsValid = true
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.details = description
            newItem.id = UUID()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            description = ""
            hideKeyboard()
            isShowing = false
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            VStack (spacing: 16) {
                HStack {
                    Text("Name")
                        .fontWeight(.bold)
                        .foregroundColor(.pink.opacity(0.75))
                    Spacer()
                }
                .padding(.leading)
                
                TextField("New Task", text: $task)
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .onReceive(Just(task)) { _ in limitText(taskLimit)}
                    .overlay (alignment: .trailing) {
                        Text("\(task.count)/\(taskLimit)")
                            .padding()
                            .foregroundColor(taskIsValid ? .gray : .red)
                            .opacity(0.5)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(taskIsValid ? .gray : .red)
                            .opacity(0.5)
                    }
                    .cornerRadius(10)
                
                HStack {
                    Text("Decsription")
                        .fontWeight(.bold)
                        .foregroundColor(.pink.opacity(0.75))
                    Spacer()
                }
                .padding(.leading)
                
                TextEditor(text: $description)
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray)
                            .opacity(0.5)
                    }
                    .cornerRadius(10)
                    .frame(maxHeight: 120)
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
                
                Button {
                    addItem()
                } label: {
                    Spacer()
                    Text("Save")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(10)
            } //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(isDarkMode ? Color(UIColor.tertiarySystemBackground) : .white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.65), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
    }
}

// MARK: - PREVIEW
struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
