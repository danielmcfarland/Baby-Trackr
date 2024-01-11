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
                        ChildInitialsView(child: child)
                        Spacer()
                    }
                    .listRowInsets(.init(top: 25, leading: 0, bottom: 25, trailing: 0))
                    
                    TextField("", text: $child.name, prompt: Text("Child Name").foregroundColor(.gray))
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.accentColor)
                        .listRowInsets(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                        .focused($focusedField, equals: .childName)
                    
                    Picker("Gender", selection: $child.gender) {
                        Text("Male").tag("male")
                        Text("Female").tag("female")
                    }
                    .pickerStyle(.segmented)
                    
                    DatePicker(selection: $child.dob, label: {
                        Text("Date of Birth")
                    })
                    .padding(.bottom, 10)
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Add Child")
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
                        Text("Done")
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

struct ChildInitialsView: View {
    var child: Child
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.accentColor)
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(color: .accentColor.opacity(0.4), radius: 20, x: 0, y: 0)
            
            Text(child.initials)
                .foregroundStyle(Color.white)
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
        }
    }
}
