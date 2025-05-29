import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var showSuccessAlert = false
    @State private var motivationMessage = ""

    var onSave: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            Form {
                TextField("Görev Başlığı", text: $title)
                TextField("Açıklama", text: $description)
            }
            .navigationTitle("Yeni Görev")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        let newTask = Task(
                            id: Int.random(in: 1000...9999),
                            title: title,
                            description: description,
                            isCompleted: false
                        )

                        APIService.shared.addTask(task: newTask) {
                            motivationMessage = "🎉 Yeni görev başarıyla eklendi!"
                            showSuccessAlert = true
                            onSave?()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
            .alert("Görev Eklendi ✅", isPresented: $showSuccessAlert) {
                Button("Tamam") {
                    dismiss()
                }
            } message: {
                Text(motivationMessage)
            }
        }
    }
}

