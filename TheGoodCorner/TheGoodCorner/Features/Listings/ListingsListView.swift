import SwiftUI

struct ListingsListView: View {
    @StateObject private var viewModel: ListingsListViewModel

    init(viewModel: ListingsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                content
            }
            .navigationTitle("TheGoodCorner")
            .task {
                if case .idle = viewModel.state {
                    await viewModel.load()
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ListingsLoadingView()

        case .loaded(let items):
            
            VStack(spacing: 0) {
                categoriesSection
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(items) { item in
                            NavigationLink {
                                
                            } label: {
                                ListingRowView(
                                    item: item
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 20)
                }
            }
            
        case .empty(let message):
            ListingsStateView(
                systemImage: "tray",
                title: "Aucune annonce",
                message: message,
                buttonTitle: nil,
                action: nil
            )
            
        case .error(let message):
            ListingsStateView(
                systemImage: "wifi.exclamationmark",
                title: "Chargement impossible",
                message: message,
                buttonTitle: "Réessayer"
            ) {
                Task { await viewModel.retry() }
            }
        }
    }
    
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChipView(
                    title: "Tout",
                    isSelected: viewModel.selectedCategoryId == nil
                ) {
                    viewModel.selectedCategoryId = nil
                }
                
                ForEach(viewModel.categories) { category in
                    CategoryChipView(
                        title: category.name,
                        isSelected: viewModel.selectedCategoryId == category.id
                    ) {
                        viewModel.selectedCategoryId = category.id
                    }
                }
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 20)
        }
    }
}

private struct ListingCardView: View {
    let item: ListingDisplayItem

    var body: some View {
        HStack(spacing: 14) {
            listingImage

            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(item.formattedPrice)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text(item.categoryName)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

    @ViewBuilder
    private var listingImage: some View {
        AsyncImage(url: item.imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                placeholderImage
            case .empty:
                ProgressView()
            @unknown default:
                placeholderImage
            }
        }
        .frame(width: 96, height: 96)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .font(.title2)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@ViewBuilder
private func CategoryChipView(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        HStack(spacing: 6) {
            Text(title)
                .font(.subheadline)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
        }
        .background(
            Capsule()
                .fill(isSelected ? Color.orange.opacity(0.15) : Color(.systemGray6))
        )
        .overlay(
            Capsule()
                .stroke(isSelected ? Color.orange : Color(.systemGray4), lineWidth: isSelected ? 1.5 : 1)
        )
        .foregroundStyle(isSelected ? Color.orange : Color.primary)
    }
    .padding(.vertical, 1)
    .buttonStyle(.plain)
    .accessibilityAddTraits(isSelected ? .isSelected : [])
}

private struct ListingsLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Chargement des annonces…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

private struct ListingsStateView: View {
    let systemImage: String
    let title: String
    let message: String
    let buttonTitle: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3.weight(.bold))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            if let buttonTitle, let action {
                Button(buttonTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
            }
        }
        .padding(24)
    }
}
