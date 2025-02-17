// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14.0, *)
struct FormSectionHeader: View {
    
    @Environment(\.theme) var theme: ThemeSwiftUI
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(theme.colors.secondaryContent)
            .padding(.top, 32)
            .padding(.leading)
            .padding(.bottom, 8)
            .font(theme.fonts.footnote)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 14.0, *)
struct FormSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VectorForm {
            SwiftUI.Section(header: FormSectionHeader(text: "Section Header")) {
                FormPickerItem(title: "Item 1", selected: false)
                FormPickerItem(title: "Item 2", selected: false)
                FormPickerItem(title: "Item 3", selected: false)
            }
        }
    }
}
