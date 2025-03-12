import PhotosUI
import SwiftUI

struct ImageUploader: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var images: [UIImage]
    let maxCount: Int

    var count: Int {
        return images.count
    }

    var remainingCount: Int {
        return maxCount - images.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        ImagePreviewCell(image: image) {
                            images.remove(at: index)
                        }
                    }
                    .padding([.top, .bottom], 8)

                    if remainingCount > 0 {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            AddImageCell()
                                .padding([.top, .bottom], 8)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedItem) { _, newValue in
            guard let item = newValue else { return }
            Task {
                guard let data = try? await item.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else { return }
                images.append(image)
                selectedItem = nil
            }
        }
    }
}

private struct ImagePreviewCell: View {
    let image: UIImage
    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white)
                    .background(Circle().fill(Color.black))
            }
            .offset(x: 8, y: -8)
        }
    }
}

private struct AddImageCell: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray)

            Image(systemName: "plus")
                .font(.title)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ImageUploader(images: .constant([]), maxCount: 3)
}
