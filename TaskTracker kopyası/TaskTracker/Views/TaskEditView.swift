import SwiftUI

struct TaskEditView: View {
    var task: Task
    var onSave: ((Task) -> Void)?
    @Environment(\.dismiss) var dismiss

    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool

    init(task: Task, onSave: ((Task) -> Void)? = nil) {
        self.task = task
        self.onSave = onSave
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Görev Bilgileri")) {
                    TextField("Başlık", text: $title)
                    TextField("Açıklama", text: $description)
                    Toggle("Tamamlandı mı?", isOn: $isCompleted)
                }
            }
            .navigationTitle("Görevi Güncelle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let updatedTask = Task(
                            id: task.id,
                            title: title,
                            description: description,
                            isCompleted: isCompleted
                        )

                        APIService.shared.updateTask(task: updatedTask) {
                            onSave?(updatedTask)
                            dismiss()
                        }
                    }) {
                        Text("Kaydet")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}

