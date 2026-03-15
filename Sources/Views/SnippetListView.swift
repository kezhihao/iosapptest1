import SwiftUI
import SwiftData

struct SnippetListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Snippet.updatedAt, order: .reverse) private var snippets: [Snippet]
    @State private var showingAddSnippet = false
    @State private var selectedCategory: String? = nil
    @State private var searchText = ""

    private var categories: [String] {
        Array(Set(snippets.map { $0.category })).sorted()
    }

    private var filteredSnippets: [Snippet] {
        var result = snippets
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        List {
            if !categories.isEmpty {
                Section("分类") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryChip(
                                title: "全部",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }
                            ForEach(categories, id: \.self) { category in
                                CategoryChip(
                                    title: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            Section {
                if filteredSnippets.isEmpty {
                    EmptyStateView()
                } else {
                    ForEach(filteredSnippets) { snippet in
                        SnippetRowView(snippet: snippet)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteSnippet(snippet)
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                    }
                }
            } header: {
                Text("片段列表")
            }
        }
        .searchable(text: $searchText, prompt: "搜索片段")
        .navigationTitle("QuickClip")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSnippet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSnippet) {
            AddSnippetView()
        }
    }

    private func deleteSnippet(_ snippet: Snippet) {
        modelContext.delete(snippet)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

struct SnippetRowView: View {
    let snippet: Snippet

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(snippet.title)
                    .font(.headline)
                if snippet.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            Text(snippet.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            Text(snippet.category)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("还没有片段")
                .font(.headline)
            Text("点击 + 添加你的第一个文本片段")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

#Preview {
    SnippetListView()
        .modelContainer(for: Snippet.self, inMemory: true)
}
