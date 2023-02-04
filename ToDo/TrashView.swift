//
//  TrashView.swift
//  ToDo
//
//  Created by 이예민 on 2023/02/03.
//

import SwiftUI
import CoreData

struct TrashView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.created, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    private var filteredItems: [Item] {
        items.filter { $0.trash == true }
    }
    
    var body: some View {
        ZStack {
            Color("PrimaryColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("휴지통")
                    .font(.system(size: 32))
                    .foregroundColor(Color("SecondColor"))
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                Divider()
                    .overlay(Color("SecondColor"))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                if filteredItems.isEmpty {
                    Spacer()
                    Text("휴지통이 비어있습니다")
                        .foregroundColor(Color("SecondColor"))
                    Spacer()
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            Text(item.content ?? "")
                                .font(.system(size: 20))
                                .foregroundColor(Color("SecondColor"))
                                .strikethrough(item.state ? true : false)
                                .fontWeight(item.star ? .bold : .light)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .onTapGesture {
                                    updateItems(item: item)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(action: {deleteItems(item: item)}) {
                                        Label("", systemImage: "trash")
                                            .labelStyle(IconOnlyLabelStyle())
                                    }
                                }
                                .tint(Color("AccentColor"))
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button(action: {rollBackItems(item: item)}) {
                                        Label("", systemImage: "arrowshape.turn.up.backward.fill")
                                            .labelStyle(IconOnlyLabelStyle())
                                    }
                                    
                                }
                                .tint(Color("SecondColor"))
                        }
                        .listRowBackground(Color("PrimaryColor"))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .environment(\.defaultMinListRowHeight, 70)
                }
            }
        }
    }
    
    private func deleteItems(item: Item) {
        withAnimation {
            viewContext.delete(item)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func updateItems(item: Item) {
        withAnimation {
            item.state = !item.state
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func rollBackItems(item: Item) {
        withAnimation {
            item.trash = !item.trash
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TrashView_Previews: PreviewProvider {
    static var previews: some View {
        TrashView()
    }
}
