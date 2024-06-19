//
//  RemoteImageView.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-04.
//

import SwiftUI

struct RemoteImageView: View {
    @StateObject private var loader: ImageLoader
    let placeholder: Image

    init(urlString: String, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader())
        self.placeholder = placeholder
        loader.load(from: urlString)
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(urlString: "https://i.pinimg.com/originals/69/03/e3/6903e3af13e344c22909bcdce1768077.png")
    }
}
