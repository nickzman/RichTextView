//
//  LatexParserProtocol.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Down
import iosMath

public protocol LatexParserProtocol: class {
    func extractLatex(from input: String, textColor: UIColor) -> NSAttributedString?
}

extension LatexParserProtocol {
    public func extractLatex(from input: String, textColor: UIColor) -> NSAttributedString? {

        let latexInput = self.extractLatexStringInsideTags(from: input)

        let label = MTMathUILabel()
        label.textColor = textColor
        label.latex = latexInput

        var newFrame = label.frame
        newFrame.size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.frame = newFrame

        guard let image = self.getImage(from: label) else {
            return nil
        }

        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        return NSAttributedString(attachment: textAttachment)
    }

    // MARK: - Helpers

    private func extractLatexStringInsideTags(from input: String) -> String {
        return input.getSubstring(inBetween: "[math]", and: "[/math]") ?? input
    }

    private func getImage(from label: MTMathUILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let verticalFlip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: label.frame.size.height)
        context.concatenate(verticalFlip)
        label.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
            return nil
        }
        UIGraphicsEndImageContext()
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
}

public class LatexParser: LatexParserProtocol {
    public init() {}
}
