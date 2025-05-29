import SwiftUI

struct TaskListView: View {
    @State private var tasks: [Task] = []
    @State private var showAddForm = false
    @State private var selectedTask: Task?

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    Button {
                        selectedTask = task
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(task.title)
                                    .font(.headline)
                                if task.isCompleted {
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Görevler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddForm) {
                TaskFormView {
                    refreshTasks()
                }
            }
            .sheet(item: $selectedTask) { task in
                TaskEditView(task: task) { updatedTask in
                    refreshTasks()
                }
            }
            .onAppear {
                refreshTasks()
            }
        }
    }

    func refreshTasks() {
        APIService.shared.fetchTasks { result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case .failure(let error):
                print("❌ Hata: \(error.localizedDescription)")
            }
        }
    }

    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            APIService.shared.deleteTask(taskId: task.id) {
                refreshTasks()
            }
        }
    }
}

