//
//  ContentView.swift
//  ToDo
//
//  Created by 이예민 on 2023/01/29.
//

import SwiftUI
import CoreData
import CoreLocation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.created, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var todoContent: String = ""
    @State private var showAddTodoModal = false
    @State private var weatherIcon: String = ""
    @ObservedObject var weather = WeatherData()
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        NavigationLink(destination: SettingView()) {
                            Label("", systemImage: "gearshape")
                                .labelStyle(IconOnlyLabelStyle())
                                .font(.system(size: 25))
                                .foregroundColor(Color("SecondColor"))
                                .padding()
                        }
                        Spacer()
                        VStack {
                            Text("오늘")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("SecondColor"))
                            Text(Formatter.weekDay.string(from: Date()))
                                .font(.system(size: 13))
                                .fontWeight(.medium)
                                .foregroundColor(Color("AccentColor"))
                        }
                        Spacer()
                        NavigationLink(destination: TrashView()) {
                            Label("", systemImage: "trash")
                                .labelStyle(IconOnlyLabelStyle())
                                .font(.system(size: 25))
                                .foregroundColor(Color("SecondColor"))
                                .padding()
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    TextField("여기에 할 일을 적어주세요", text: $todoContent)
                        .foregroundColor(Color("SecondColor"))
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
                        .onSubmit {
                            addItem()
                        }
                        .submitLabel(.done)
                    Divider()
                        .overlay(Color("SecondColor"))
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
                    if items.isEmpty {
                        Spacer()
                        Text("오늘은 할 일이 없으신가요?")
                            .foregroundColor(Color("SecondColor"))
                        Spacer()
                    } else {
                        List {
                            ForEach(items) { item in
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
                                        Button(action: {updateStarItems(item: item)}) {
                                            Label("", systemImage: item.star ? "star.fill" : "star")
                                                .labelStyle(IconOnlyLabelStyle())
                                                .environment(\.symbolVariants, .none)
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
                    Label("", systemImage: weather.weatherIcon)
                        .labelStyle(IconOnlyLabelStyle())
                        .font(.system(size: 60))
                        .foregroundColor(Color("SecondColor"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        .onAppear(perform: weather.getData)
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                weather.getData()
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.content = todoContent
            newItem.state = false
            newItem.star = false
            newItem.created = Date()
            print(newItem.created ?? "x")
            do {
                try viewContext.save()
                todoContent = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
    
    private func updateStarItems(item: Item) {
        withAnimation {
            item.star = !item.star
            do {
                try viewContext.save()
            } catch {
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
