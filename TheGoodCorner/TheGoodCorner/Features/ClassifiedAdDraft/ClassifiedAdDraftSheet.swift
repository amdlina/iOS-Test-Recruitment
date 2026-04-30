import SwiftUI

struct ClassifiedAdDraftSheet: View {
    @ObservedObject var viewModel: ClassifiedAdDraftViewModel

    let categories: [CategoryItem]
    let onDiscard: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDiscardConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Titre de l’annonce", text: $viewModel.draft.title)
                        .textInputAutocapitalization(.sentences)

                    Picker("Catégorie", selection: $viewModel.draft.categoryId) {
                        Text("Non sélectionnée").tag(Int?.none)
                        ForEach(categories) { category in
                            Text(category.name).tag(Optional(category.id))
                        }
                    }

                    TextField("Prix", text: $viewModel.draft.price)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Informations principales")
                }

                Section {
                    TextEditor(text: $viewModel.draft.description)
                        .frame(minHeight: 120)
                        .accessibilityLabel("Description de l’annonce")
                } header: {
                    Text("Description")
                } footer: {
                    Text("Ce brouillon est sauvegardé localement sur ce téléphone, sans appel backend.")
                }

                Section {
                    TextField("Nom du contact", text: $viewModel.draft.contactName)
                        .textInputAutocapitalization(.words)

                    TextField("Email du contact", text: $viewModel.draft.contactEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text("Contact")
                }

                Section {
                    Button("Réinitialiser le formulaire") {
                        viewModel.resetDraft()
                    }
                    .accessibilityHint("Vide le formulaire et conserve un brouillon local vide")

                    Button("Supprimer le brouillon", role: .destructive) {
                        isShowingDiscardConfirmation = true
                    }
                    .accessibilityHint("Supprime le brouillon local sauvegardé sur cet appareil")
                }
            }
            .navigationTitle("Nouvelle annonce")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
            .onChange(of: viewModel.draft) { draft in
                viewModel.save(draft)
            }
            .confirmationDialog(
                "Supprimer le brouillon local ?",
                isPresented: $isShowingDiscardConfirmation,
                titleVisibility: .visible
            ) {
                Button("Supprimer", role: .destructive) {
                    viewModel.discardDraft()
                    onDiscard()
                }
                Button("Annuler", role: .cancel) { }
            } message: {
                Text("Cette action efface le brouillon sauvegardé sur cet appareil.")
            }
        }
    }
}
