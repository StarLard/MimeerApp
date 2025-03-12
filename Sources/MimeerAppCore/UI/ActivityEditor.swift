//
//  ActivityEditor.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/27/23.
//

import MimeerKit
import OSLog
import SwiftUI

struct ActivityEditor: View {
    var existingActivity: Activity?
    var displayPriority: UInt
    @State private var title: String
    @State private var note: String
    @State private var icon: SFSymbol
    @State private var color: Color
    @State private var colorResolved: Color.Resolved!
    @State private var isCancelConfirmationDialogPresented = false
    @State private var isIconCustomizerPresented = false
    @FocusState private var titleFieldIsFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.self) var environment

    init(displayPriority: UInt) {
        self.displayPriority = displayPriority
        self._title = State(initialValue: "")
        self._note = State(initialValue: "")
        self._icon = State(initialValue: .sparkles)
        self._color = State(initialValue: ColorPalette.defaultColorOptions.randomElement()!)
    }

    init(existingActivity: Activity) {
        self.existingActivity = existingActivity
        self.displayPriority = existingActivity.displayPriority
        self._title = State(initialValue: existingActivity.title)
        self._note = State(initialValue: existingActivity.note)
        self._icon = State(initialValue: existingActivity.icon)
        self._color = State(initialValue: Color(existingActivity.color))
    }

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        withAnimation {
                            if !hasChanges {
                                dismiss()
                            } else {
                                isCancelConfirmationDialogPresented.toggle()
                            }
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: saveChanges)
                        .disabled(!hasChanges || !requiredFieldsArePopulated)
                }
            }
            .confirmationDialog("Cancel", isPresented: $isCancelConfirmationDialogPresented) {
                Button("Discard Changes", role: .destructive) {
                    withAnimation {
                        dismiss()
                    }
                }

                Button("Cancel", role: .cancel) {
                    isCancelConfirmationDialogPresented = false
                }
            }
            .navigationTitle(existingActivity == nil ? "New Activity" : "Edit Activity")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $isIconCustomizerPresented) {
                    NavigationStack {
                        IconCustomizer(icon: $icon, color: $color)
                    }
                }
            #endif
            .onChange(of: color, initial: true) {
                colorResolved = color.resolve(in: environment)
            }
            .onAppear {
                titleFieldIsFocused = true
            }
    }

    // MARK: Private

    private var content: some View {
        #if os(iOS)
            Form {
                VStack(spacing: 16) {
                    iconPicker
                    titleField
                }

                Section {
                    TextField("Note", text: $note, prompt: Text("Add a note"))
                }
            }
            .contentMargins(.top, 16)
        #elseif os(macOS)
            VStack(alignment: .leading, spacing: 16) {
                Text(existingActivity == nil ? "New Activity" : "Edit Activity")
                    .font(.title)

                HStack {
                    iconPicker
                    Divider()
                    Form {
                        ColorPicker("Color", selection: $color, supportsOpacity: false)
                        titleField
                        TextField("Note", text: $note, prompt: Text("Add a note"))
                    }
                }
            }
            .padding(24)
            .fixedSize(horizontal: false, vertical: true)
        #endif
    }

    private var iconPicker: some View {
        Button {
            isIconCustomizerPresented.toggle()
        } label: {
            ZStack(alignment: .topTrailing) {
                IconPreview(color: color, icon: icon, size: iconPreviewSize)

                Color.accentColor
                    .clipShape(Circle())
                    .frame(width: iconEditBadgeSize, height: iconEditBadgeSize)
                    .overlay {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .padding(2)
                    }
                    .offset(x: iconEditBadgeOffset, y: -iconEditBadgeOffset)
            }
        }
        .buttonStyle(.plain)
        #if os(iOS)
            .padding(.top)
        #elseif os(macOS)
            .padding(.trailing)
            .popover(isPresented: $isIconCustomizerPresented) {
                ScrollView {
                    IconPalette(icon: $icon)
                }
                .frame(width: 240, height: 240)
                .padding(8)
            }
        #endif
    }

    private var iconPreviewSize: IconPreview.Size {
        #if os(iOS)
            .large
        #elseif os(macOS)
            .medium
        #endif
    }

    private var iconEditBadgeSize: CGFloat {
        #if os(iOS)
            36
        #elseif os(macOS)
            24
        #endif
    }

    private var iconEditBadgeOffset: CGFloat {
        #if os(iOS)
            16
        #elseif os(macOS)
            12
        #endif
    }

    private var titleField: some View {
        #if os(iOS)
            TextField("Title", text: $title, prompt: Text("Title"))
                .multilineTextAlignment(.center)
                .font(.title.bold())
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(.quaternary))
                .focused($titleFieldIsFocused)
        #elseif os(macOS)
            TextField("Title", text: $title, prompt: Text("Add a title"))
                .focused($titleFieldIsFocused)
        #endif
    }

    private var hasChanges: Bool {
        guard let existingActivity else { return !title.isEmpty || !note.isEmpty }
        return existingActivity.title != title
            || existingActivity.note != note
            || existingActivity.color != colorResolved
            || existingActivity.icon != icon
    }

    private var requiredFieldsArePopulated: Bool {
        !title.isEmpty
    }

    private func saveChanges() {
        guard hasChanges, requiredFieldsArePopulated else {
            assertionFailure()
            return
        }
        withAnimation {
            if let existingActivity {
                existingActivity.title = title
                existingActivity.icon = icon
                existingActivity.color = colorResolved
                existingActivity.note = note
            } else {
                modelContext.insertNewActivity(
                    title: title, icon: icon, color: colorResolved, note: note,
                    displayPriority: displayPriority)
            }
            dismiss()
        }
    }
}

#Preview {
    ActivityEditor(displayPriority: 0)
}
