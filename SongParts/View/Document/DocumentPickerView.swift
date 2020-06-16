//
//  PickerView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/12/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct DocumentPickerView: View {
    
    var viewController: UIHostingController<EmptyView> = UIHostingController(rootView: EmptyView())
    
    var body: some View {
        DocumentPicker()
    }
}

struct PickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        DocumentPickerView()
    }
}
