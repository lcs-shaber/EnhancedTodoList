//
//  TodoListView.swift
//  EnhancedTodoList
//
//  Created by Sophie Haber on 21.11.24.
//

import SwiftData
import SwiftUI

struct TodoListView: View {
    
    // MARK: Stored properties
    
    // Access the model context so we can "CRUD" data
    @Environment(\.modelContext) private var modelContext
    
    // The item currently being created
    @State private var newItemDetails = ""

    // Run a query to obtain the list of to-do items
    @Query private var items: [TodoItem]
    
    //make the list be able to be searched
    @State var searchText = ""
    
    // MARK: Computed properties
    
    // Provide list of to-do items filtered based on the search text
    var filteredItems: [TodoItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.details.lowercased().contains(searchText.lowercased())
            }
        }
    }
     
    // The user interface
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    
                    TextField("Enter a to-do item", text: $newItemDetails)
                    
                    Button("Add") {
                        addItem()
                    }
                 
                }
                .padding(20)

                if items.isEmpty {
                    
                    ContentUnavailableView(label: {
                        Label(
                            "Nothing to do",
                            systemImage: "powersleep"
                        )
                        .foregroundStyle(.green)
                    }, description: {
                        Text("To-do items will appear here once you add some.")
                    })
                    
                } else {
                    
                    NavigationStack {
                    List {
                        ForEach (filteredItems){
                            currentItem in
                            Label {
                                Text(currentItem.details)
                            } icon: {
                                Image(systemName: currentItem.isCompleted ? "checkmark.circle" : "circle")
                                    .onTapGesture {
                                        toggle(item: currentItem)
                                    }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .searchable(text: $searchText)
                }
                    .toolbar {
                        EditButton()
                    }
                   
                }
            }

            .navigationTitle("Tasks")
        }
       
    }
    
    // MARK: Functions
    func addItem() {
        let newToDoItem = TodoItem(details: newItemDetails)
        modelContext.insert(newToDoItem)
        newItemDetails = ""
    }
    
    func toggle(item: TodoItem) {
        if item.isCompleted {
            item.completedOn = nil
            item.isCompleted = false
        } else {
            item.completedOn = Date()
            item.isCompleted = true
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(items[offset])
        }
    }


}


#Preview {
    LandingView()
}
