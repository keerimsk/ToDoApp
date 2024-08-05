//
//  ContentView.swift
//  ToDoApp
//
//  Created by Kerim Sakız on 5.08.2024.
//

import SwiftUI

struct ContentView: View {
    // Görevlerin ve yeni görev metninin durumunu saklamak için state
    @State private var tasks: [TaskItem] = []
    @State private var newTask: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Yeni görev eklemek için TextField ve Button
            HStack {
                TextField("Yeni Görev:", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    withAnimation {
                        addTask()
                    }
                }) {
                    Text("Ekle")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
            
            // Görev listesini gösteren List
            List {
                ForEach(tasks) { task in
                    TaskRow(task: task, toggleTask: toggleTask, deleteTask: deleteTask)
                        .transition(.move(edge: .trailing))
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
    
    // Yeni görev ekleme fonksiyonu
    func addTask() {
        if !newTask.isEmpty {
            let newTaskItem = TaskItem(id: UUID(), name: newTask, isCompleted: false)
            tasks.append(newTaskItem)
            newTask = ""
        }
    }
    
    // Görevin tamamlanma durumunu değiştirme fonksiyonu
    func toggleTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            withAnimation {
                tasks[index].isCompleted.toggle()
            }
        }
    }
    
    // Görevi silme fonksiyonu
    func deleteTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
        }
    }
}

// Görev modelini tanımladım
struct TaskItem: Identifiable {
    let id: UUID
    var name: String
    var isCompleted: Bool
}

// Her bir görevi temsil eden satır
struct TaskRow: View {
    var task: TaskItem
    var toggleTask: (UUID) -> Void
    var deleteTask: (UUID) -> Void
    
    var body: some View {
        HStack {
            Text(task.name)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
            
            Spacer()
            
            Button(action: {
                deleteTask(task.id)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: .gray.opacity(0.2), radius: 3)
        .onTapGesture {
            toggleTask(task.id)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
