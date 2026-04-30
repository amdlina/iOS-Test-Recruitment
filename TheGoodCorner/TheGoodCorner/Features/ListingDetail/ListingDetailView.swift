import SwiftUI

struct ListingDetailView: View {
    let item: ListingDisplayItem

    @Environment(\.dismiss) private var dismiss

    private let imageHeight: CGFloat = 400
    private let cardOverlap: CGFloat = 20

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerImage(width: proxy.size.width)

                        contentSheet
                            .offset(y: -cardOverlap)
                            .padding(.bottom, -cardOverlap)
                    }
                    .frame(minHeight: proxy.size.height + proxy.safeAreaInsets.top)
                }
                .background(Color(.systemGroupedBackground))
                .ignoresSafeArea(edges: .vertical)
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)

                transparentTopOverlay(safeAreaTop: proxy.safeAreaInsets.top)
                backButton()
                }
        }
    }

    private func headerImage(width: CGFloat) -> some View {
        RemoteListingImage(
            url: item.imageURL,
            title: item.title,
            width: width,
            height: imageHeight,
            cornerRadius: 0,
            contentMode: .fit,
            detailImage: true
        )
        .frame(width: width, height: imageHeight)
        .background(Color(.secondarySystemBackground))
    }

    private func transparentTopOverlay(safeAreaTop: CGFloat) -> some View {
        Rectangle()
            .fill(.clear)
            .background(
                Color(.systemBackground).opacity(0.4)
            )
            .frame(height: safeAreaTop )
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)
    }

    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.orange)
                .frame(width: 40, height: 40)
                .background(Color(.systemBackground).opacity(0.75), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 6)
        }
        .accessibilityLabel("Retour")
        .padding(.leading, 20)
        .padding(.top, 10)
    }

    private var contentSheet: some View {
            VStack(alignment: .leading, spacing: 14) {
                titlePriceAndBadges
                    .padding(.top, 24)

                Divider()
                    .padding(.vertical, 8)

                Label("Publiée le \(DateFormatter.listingDisplayDate.string(from: item.creationDate))", systemImage: "calendar")

                Divider()
                    .padding(.vertical, 8)

                descriptionSection
                
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .frame(minHeight: UIScreen.main.bounds.height - imageHeight + cardOverlap, alignment: .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.10), radius: 22, x: 0, y: -2)
    }

    private var titlePriceAndBadges: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Text(item.formattedPrice)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                Text(item.categoryName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.orange.opacity(0.12)))

                if item.isUrgent {
                    UrgentBadge(padH: 16, padV: 10)
                }
            }
        }
    }

    @ViewBuilder
    private var descriptionSection: some View {
        if let description = item.description, !description.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                Text("Description")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
