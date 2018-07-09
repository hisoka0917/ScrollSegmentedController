//
//  MySegmentedControl.swift
//  ScrollSegmentedController
//
//  Created by Wang Kai on 2018/7/9.
//  Copyright © 2018年 github. All rights reserved.
//

import UIKit

public class MySegmentedControl: UIView {

    public var sectionTitles: [String] = [] {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    public var segmentChangedHandler: ( _ index: Int) -> Void = { _ in }
    public var sectionIndicatorColor: UIColor = UIColor.blue
    public var sectionTitleColor: UIColor = UIColor.darkText
    public var sectionTitleSelectedColor: UIColor = UIColor.blue
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var enableSectionIndicatorAnimate: Bool = false
    private var segments: [UIButton] = []
    private let sectionIndicator: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 2))
    public var selectedIndex: Int = 0 {
        didSet {
            self.updateSelectedSegment()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public init(sectionTitles: [String]) {
        super.init(frame: CGRect.zero)
        self.sectionTitles = sectionTitles
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.backgroundColor = .white
        self.sectionIndicator.backgroundColor = self.sectionIndicatorColor
        self.addSubview(self.sectionIndicator)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSegmentsLayouts()
    }

    private func updateSegmentsLayouts() {
        let spacing: CGFloat = 8.0
        let whiteSpacing: CGFloat = CGFloat(self.sectionTitles.count) * spacing * 2
        let segmentWidth = ceil((self.width - whiteSpacing) / CGFloat(self.sectionTitles.count))
        if self.segments.count != self.sectionTitles.count {
            var originX: CGFloat = spacing
            self.segments.removeAll()
            for title in self.sectionTitles {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: originX, y: 0, width: segmentWidth, height: self.height)
                button.setTitle(title, for: .normal)
                button.setTitleColor(self.sectionTitleColor, for: .normal)
                button.setTitleColor(self.sectionTitleSelectedColor, for: .selected)
                button.titleLabel?.font = self.titleFont
                button.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
                self.addSubview(button)
                self.segments.append(button)
                originX += segmentWidth + spacing * 2
            }
        } else {
            var originX: CGFloat = spacing
            for button in self.segments {
                button.left = originX
                originX += segmentWidth + spacing * 2
            }
        }

        self.sectionIndicator.width = segmentWidth - spacing * 2
        self.sectionIndicator.left = spacing * 2 + CGFloat(self.selectedIndex) * (segmentWidth + spacing * 2.0)
        self.sectionIndicator.bottom = self.height
        self.bringSubview(toFront: self.sectionIndicator)

        self.updateSelectedSegment()
    }

    @objc private func segmentSelected(_ sender: UIButton) {
        self.selectedIndex = self.segments.index(of: sender)!
        self.segmentChangedHandler(self.selectedIndex)
    }

    private func updateSelectedSegment() {
        for button in self.segments {
            button.isSelected = false
        }
        let selectedSegment = self.segments[self.selectedIndex]
        selectedSegment.isSelected = true
        let centerX = selectedSegment.centerX
        UIView.animate(withDuration: self.enableSectionIndicatorAnimate ? 0.25 : 0.0) {
            self.sectionIndicator.centerX = centerX
        }
    }

}
