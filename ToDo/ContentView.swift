//
//  ContentView.swift
//  ToDo
//
//  Created by 이예민 on 2023/01/29.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.content, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var todoContent: String = ""
    
    var body: some View {
        ZStack {
            Color("PrimaryColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {}) {
                        Label("", systemImage: "gearshape")
                            .font(.system(size: 25))
                            .foregroundColor(Color("SecondColor"))
                            .padding()
                    }
                    Spacer()
                    VStack {
                        Text("오늘")
                            .font(.system(size: 30))
                            .foregroundColor(Color("SecondColor"))
                        Text(Formatter.weekDay.string(from: Date()))
                            .font(.system(size: 13))
                            .foregroundColor(Color("AccentColor"))
                    }
                    Spacer()
                    Button(action: {}) {
                        Label("", systemImage: "plus")
                            .font(.system(size: 25))
                            .foregroundColor(Color("SecondColor"))
                            .padding()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                List {
                    ForEach(items) { item in
                        Text(item.content ?? "")
                            .font(.system(size: 20))
                            .foregroundColor(Color("SecondColor"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowBackground(Color("PrimaryColor"))
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .environment(\.defaultMinListRowHeight, 70)
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.content = todoContent
            
            do {
                try viewContext.save()
                todoContent = ""
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
