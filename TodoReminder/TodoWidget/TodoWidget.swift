//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by satoutakeshi on 2020/08/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> RecentTodoEntry {
        RecentTodoEntry(date: Date(), title: "Widget開発", priority: 2, id: UUID())
    }

    func getSnapshot(in context: Context, completion: @escaping (RecentTodoEntry) -> ()) {
        if context.isPreview {
            let entry = RecentTodoEntry(date: Date(), title: "Widget開発", priority: 2, id: UUID())
            completion(entry)
        } else {
            do {
                let store = TodoListStore()
                let todoLists = try store.fetchTodayItems()
                let entries = todoLists.map { (todoList) -> RecentTodoEntry in
                    RecentTodoEntry(todoItem: todoList)
                }
                guard let first = entries.first else {
                    return
                }
                completion(first)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let store = TodoListStore()
            let todoLists = try store.fetchTodayItems()
            let entries = todoLists.map { (todoList) -> RecentTodoEntry in
                RecentTodoEntry(todoItem: todoList)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct RecentTodoEntry: TimelineEntry {
    let date: Date
    let title: String
    let priority: Int
    let id: UUID

    init(date: Date, title: String, priority: Int, id: UUID) {
        self.date = date
        self.title = title
        self.priority = priority
        self.id = id
    }

    init(todoItem: TodoListItem) {
        self.date = todoItem.startDate
        self.title = todoItem.title
        self.priority = todoItem.priority
        self.id = todoItem.id
    }
}

// Widgetを表示するView
struct TodoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .foregroundColor(makePriorityColor(priority: entry.priority))
                    .clipShape(ContainerRelativeShape())
                    .overlay (
                        Text(entry.title)
                            .font(.title)
                            .lineLimit(nil)
                            .foregroundColor(.white)
                    )
            }
            VStack(alignment: .trailing) {
                Text(entry.date, style: .date)
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                Text(entry.date, style: .time)
                    .font(.caption)
            }
        }
        .padding(8)
        .widgetURL(makeURLScheme(id: entry.id))
    }

    private func makePriorityColor(priority: Int) -> Color {
        switch priority {
            case 0:
                return .green
            case 1:
                return .yellow
            case 2:
                return .red
            default:
                return .black
        }
    }

    func makeURLScheme(id: UUID) -> URL {
        let url = URL(string: "todolist://detail")!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "id", value: id.uuidString)]
        print("urlcom \(urlComponents)")
        return urlComponents!.url!
    }
}

@main
struct TodoWidget: Widget {
    // widgetの種類識別子
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        // 編集がないWidget
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)

        }
        // Widget gallary のタイトル
        .configurationDisplayName("Todo Reminder")
        // Widget gallaryの説明
        .description("直近のTodoListをお知らせします")
        .supportedFamilies([.systemSmall])
    }
}

struct TodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodoWidgetEntryView(entry: RecentTodoEntry(date: Date(), title: "Widget開発", priority: 2, id: UUID()))
            // previewContextでwidgetの大きさをプレビューできる
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
