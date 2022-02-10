//
//  BindedDevicesView.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import SwiftUI

struct BindedDevicesView: View {
    @StateObject var output: BindedDevicesPresenter

    var body: some View {
        VStack {
            ForEach(output.deviceItems ?? [], id: \.self) { item in
                HStack {
                    Text(item.title ?? "")
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
        .onAppear(perform: output.viewDidAppear)
        .navigationTitle("Привязанные устройства")
    }
}
