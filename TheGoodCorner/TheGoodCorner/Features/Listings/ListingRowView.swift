import SwiftUI

struct ListingRowView: View {
    let item: ListingDisplayItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                RemoteListingImage(
                    url: item.imageURL,
                    title: item.title,
                    size: 150,
                    width: nil,
                    height: 150,
                    cornerRadius: 18
                )
                .frame(maxWidth: .infinity)

                if item.isUrgent {
                    UrgentBadge(padH: 8, padV: 5)
                }
            }
            .padding(.top, 10)

            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(
                            height: UIFont.preferredFont(forTextStyle: .subheadline).lineHeight * 2,
                            alignment: .top
                        )

                Text(item.formattedPrice)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)

                Text(item.categoryName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        .accessibilityElement(children: .combine)
    }
}

