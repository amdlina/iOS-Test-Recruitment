import SwiftUI

struct RemoteListingImage: View {
    let url: URL?
    let title: String
    var size: CGFloat = 96
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var cornerRadius: CGFloat = 12
    var contentMode: ContentMode = .fill
    var detailImage: Bool = false
    

    private var imageWidth: CGFloat? {
        width ?? size
    }

    private var imageHeight: CGFloat? {
        height ?? size
    }

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case let .success(image):
                        if !detailImage {
                            image
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                                .accessibilityLabel("Image de l’annonce \(title)")
                        } else {
                            image
                                .resizable()
                                .scaledToFill()
                        }
                    case .empty:
                        ZStack {
                            Color(.secondarySystemBackground)
                            ProgressView()
                                .accessibilityLabel("Chargement de l’image")
                        }
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: imageWidth, height: imageHeight)
        .frame(maxWidth: width == nil ? nil : .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .clipped()
    }

    private var placeholder: some View {
        ZStack {
            Color(.secondarySystemBackground)

            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
        }
    }
}
