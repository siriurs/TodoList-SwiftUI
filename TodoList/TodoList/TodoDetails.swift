//
//  TodoDetails.swift
//  TodoList
//
//  Created by Bolin on 2020/4/14.
//  Copyright © 2020 xubolin. All rights reserved.
//

import SwiftUI

struct TodoDetails: View {
    @ObservedObject var main: Main
    let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStack {
                Button(action: {
                    self.keyWindow?.endEditing(true)
                    self.main.detailsShowing = false
                }) {
                    Text("取消").padding()
                }
                Spacer()
                Button(action: {
                    self.keyWindow?.endEditing(true)
                    if editingMode {
                        self.main.todos[editingIndex].title = self.main.detailsTitle
                        self.main.todos[editingIndex].dueDate = self.main.detailsDueDate
                    } else {
                        let newTodo = Todo(title: self.main.detailsTitle, dueDate: self.main.detailsDueDate)
                        self.main.todos.append(newTodo)
                    }
                    self.main.sort()
                    do {
                        let archivedData = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                        UserDefaults.standard.set(archivedData, forKey: "todos")
                    } catch {
                        print("error")
                    }
                    self.main.detailsShowing = false
                }) {
                    Text(editingMode ? "完成" : "添加").padding()
                }.disabled(main.detailsTitle == "")
            }
            SATextField(tag: 0, text: editingTodo.title, placeholder: "你要干嘛", changeHandler: { (newString) in
                self.main.detailsTitle = newString
            }) {
            }.padding(8)
                .foregroundColor(.white)
            DatePicker(selection: $main.detailsDueDate, displayedComponents: .date, label: {() -> EmptyView in
                
            })
            .padding()
            Spacer()
        }
    .padding()
    .background(Color("todoDetails-bg"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct TodoDetails_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetails(main: Main())
    }
}
