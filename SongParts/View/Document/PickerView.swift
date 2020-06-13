//
//  PickerView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/12/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct PickerView<Select: View>: View {
    
    var viewController: UIHostingController<Select>
    
    init(_ view: Select) {
        self.viewController = UIHostingController(rootView: view)
    }
    
    var body: some View {
        Group {
            PickerViewController(controller: viewController)
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        PickerView(Text("Button!"))
    }
}
