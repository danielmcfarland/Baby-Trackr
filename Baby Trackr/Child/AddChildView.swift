//
//  AddChildView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import SwiftUI

struct AddChildView: View {
    
    enum FocusedField {
        case childName
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var child: Child = Child(name: "", dob: Date(), gender: "male")
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        IconView(size: .large, icon: child.initialSymbol)
                        Spacer()
                    }
                    .listRowInsets(.init(top: 25, leading: 0, bottom: 25, trailing: 0))
                    
                    TextField("", text: $child.name, prompt: Text("Child Name").foregroundColor(.gray))
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .autocapitalization(.words)
                        .textContentType(.name)
                        .lineLimit(1)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.indigo)
                        .listRowInsets(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                        .focused($focusedField, equals: .childName)
                    
                    DatePicker(selection: $child.dob, in: ...Date(), displayedComponents: .date, label: {
                        Text("Date of Birth")
                            .foregroundStyle(Color.gray)
                    })
                    
                    DatePicker(selection: $child.dob, in: ...Date(), displayedComponents: .hourAndMinute, label: {
                        Text("Time of Birth")
                            .foregroundStyle(Color.gray)
                    })
                    
                    
                    .padding(.bottom, 10)
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                    }) {
                        Text("Add")
                    }
                    .disabled(child.name == "" || child.gender == "")
                }
            }
            .onAppear {
                focusedField = .childName
            }
        }
    }
    
    func save() -> Void {
        withAnimation {
            modelContext.insert(child)
            dismiss()
        }
    }
}

#Preview {
    AddChildView()
}
