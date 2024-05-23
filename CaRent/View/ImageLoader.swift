//
//  ImageLoader.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-04.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    func load(from urlString: String) {
        if let image = UIImage(named: urlString) {
            // Load image from assets
            self.image = image
        } else if let url = URL(string: urlString) {
            // Load image from remote URL
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .assign(to: \.image, on: self)
        }
    }

    deinit {
        cancellable?.cancel()
    }
}

