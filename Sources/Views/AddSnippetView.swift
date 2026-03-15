import SwiftUI
import SwiftData

struct AddSnippetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var content = ""
    @State private var category = "默认"
    @State private var isFavorite = false

    var body: some View {
        NavigationStack {
            Form {
                Section("标题") {
                    TextField("输入标题", text: $title)
                }

                Section("内容") {
                    TextEditor(text: $content)
                        .frame(minHeight: 120)
                }

                Section("分类") {
                    TextField("输入分类", text: $category)
                }

                Section {
                    Toggle("收藏", isOn: $isFavorite)
                }
            }
            .navigationTitle("添加片段")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveSnippet()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }

    private func saveSnippet() {
        let snippet = Snippet(
            title: title,
            content: content,
            category: category.isEmpty ? "默认" : category,
            isFavorite: isFavorite
        )
        modelContext.insert(snippet)
        dismiss()
    }
}

#Preview {
    AddSnippetView()
        .modelContainer(for: Snippet.self, inMemory: true)
}
