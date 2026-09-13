//
//  FlowLayout.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 30/08/26.
//
import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func makeCache(subviews: Subviews) -> CGFloat? {
        nil
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CGFloat?) -> CGSize {
        arrange(
            sizes: subviews.map { $0.sizeThatFits(.unspecified) },
            maxWidth: proposal.width ?? cache ?? .infinity
        ).totalSize
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CGFloat?) {
        cache = bounds.width

        let result = arrange(
            sizes: subviews.map { $0.sizeThatFits(.unspecified) },
            maxWidth: bounds.width
        )

        for (index, rect) in result.rects.enumerated() {
            subviews[index].place(
                at: .init(x: bounds.minX + rect.minX, y: bounds.minY + rect.minY),
                proposal: ProposedViewSize(rect.size)
            )
        }
    }


}

extension FlowLayout {
    private func arrange(sizes: [CGSize], maxWidth: CGFloat) -> (rects: [CGRect], totalSize: CGSize) {
        var rects: [CGRect] = []

        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for size in sizes {
            //Salto de línea
            if x + size.width > maxWidth && x > 0{
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            rects.append(
                CGRect(
                    x: x, y: y,
                    width: size.width, height: size.height
                )
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxX = max(maxX, x - spacing)
        }

        return (rects, .init(width: maxX, height: y + rowHeight))
    }
}
