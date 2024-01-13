//
//  MeasurementTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct MeasurementTypeView: View {
    var type: ChildMeasurementType
    
    @State var measurementPeriod: Int = 1
    @State private var showAddMeasurementView = false
    @Query private var measurements: [Measurement]
    
    
    init(type: ChildMeasurementType) {
        let id = type.child.persistentModelID
        let measurementType = type.measurementType.rawValue
        
        self._measurements = Query(filter: #Predicate<Measurement> { measurement in
            measurement.child?.persistentModelID == id
            &&
            measurement.typeValue == measurementType
        }, sort: \.createdAt)
        
        self.type = type
    }
    
    var body: some View {
        VStack {
            Picker("Measurement Period", selection: $measurementPeriod) {
                Text("D").tag(1)
                Text("W").tag(7)
                Text("M").tag(28)
                Text("Y").tag(365)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 10)
            .padding(.horizontal)
            
            VStack {
                Chart {
                    ForEach(measurements, id: \.self) {
                        LineMark(
                            x: .value("Day", $0.createdAt, unit: .second),
                            y: .value("\(type.measurementType.rawValue)", $0.value)
                        )
//                        .interpolationMethod(.catmullRom)
                        .symbol {
                            Circle()
//                                .fill(Color.clear)
//                                .strokeBorder(.accentColor, lineWidth: 2)
//                                .lineStyle(.init(lineWidth: 2))
                                .frame(width: 10, height: 10)
//                                .offset(y: -15)
                        }
                    }
                }
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: 3600 * 24 * measurementPeriod)
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 3))
                }
                
                //                .chartScrollPosition(x: <#T##Binding<Plottable>#>)
                .padding()
                
                List {
                    Section(header: Text(type.measurementType.getSymbol())
                    ) {
                        ForEach(measurements, id: \.self) { measurement in
                            NavigationLink(value: measurement) {
                                HStack {
                                    Text(String(format: "%g", measurement.value))
                                    Spacer()
                                    Text(measurement.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                                        .foregroundStyle(Color.gray)
                                }
                            }
                            
                        }
                    }
                }
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddMeasurementView.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddMeasurementView) {
            AddMeasurementView(measurement: Measurement(type: type.measurementType, value: 0, createdAt: Date()), child: type.child)
        }
        .navigationTitle("\(type.measurementType.rawValue)")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        MeasurementTypeView(type: ChildMeasurementType(child: Child(name: "Name", dob: Date(), gender: ""), measurementType: .height))
    }
}
