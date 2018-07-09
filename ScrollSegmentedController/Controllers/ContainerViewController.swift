//
//  ContainerViewController.swift
//  ScrollSegmentedController
//
//  Created by Wang Kai on 2018/7/9.
//  Copyright © 2018年 github. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate {
    private var mainScrollView: UIScrollView!
    private var segmentControl: MySegmentedControl = MySegmentedControl(sectionTitles: ["Section1", "Section2"])
    private var contentScrollView: UIScrollView!
    private var headerView: UIView!
    private let headerHeight: CGFloat = 100.0
    private let segmentHeight: CGFloat = 44.0
    private weak var currentChildViewController: UIViewController?
    private var pageWidth: CGFloat = 320.0
    private var pageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = .bottom
        self.mainScrollView = UIScrollView(frame: self.view.bounds)
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        }
        self.mainScrollView.contentSize = CGSize(width: self.view.width,
                                                 height: self.view.height + headerHeight)
        self.mainScrollView.delegate = self
        self.mainScrollView.scrollsToTop = true
        self.view.addSubview(self.mainScrollView)

        self.headerView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.mainScrollView.width,
                                               height: headerHeight))
        self.headerView.backgroundColor = UIColor.blue
        self.mainScrollView.addSubview(self.headerView)

        self.segmentControl.frame = CGRect(x: 0,
                                           y: headerHeight,
                                           width: self.mainScrollView.width,
                                           height: segmentHeight)
        self.segmentControl.segmentChangedHandler = { [unowned self] index in
            self.contentScrollView.setContentOffset(CGPoint(x: self.pageWidth * CGFloat(index), y: 0), animated: true)
            self.pageIndex = index
            self.currentChildViewController = self.childViewControllers[index]
            self.updateCurrentChildVC()
        }
        self.mainScrollView.addSubview(self.segmentControl)

        let contentHeight = self.mainScrollView.height - headerHeight - segmentHeight
        self.contentScrollView = UIScrollView(frame: CGRect(x: 0,
                                                            y: headerHeight + segmentHeight,
                                                            width: self.mainScrollView.width,
                                                            height: contentHeight))
        self.contentScrollView.backgroundColor = UIColor.lightGray
        self.contentScrollView.isPagingEnabled = true
        self.contentScrollView.contentSize = CGSize(width: self.mainScrollView.width * 2,
                                                    height: self.contentScrollView.height)
        self.contentScrollView.delegate = self
        self.mainScrollView.addSubview(self.contentScrollView)

        let childVC1 = MyTableViewController(style: .plain, number: 1)
        childVC1.tableView.frame = self.contentScrollView.bounds
        childVC1.tableView.isScrollEnabled = false
        childVC1.tableView.scrollsToTop = false
        self.contentScrollView.addSubview(childVC1.tableView)

        let childVC2 = MyTableViewController(style: .plain, number: 2)
        childVC2.tableView.frame = CGRect(x: self.contentScrollView.width,
                                          y: 0,
                                          width: self.contentScrollView.width,
                                          height: self.contentScrollView.height)
        childVC2.tableView.isScrollEnabled = false
        childVC2.tableView.scrollsToTop = false
        self.contentScrollView.addSubview(childVC2.tableView)

        self.addChildViewController(childVC1)
        self.addChildViewController(childVC2)
        self.currentChildViewController = childVC1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.pageWidth = self.contentScrollView.width
        self.mainScrollView.frame = self.view.bounds
        self.mainScrollView.contentSize = CGSize(width: self.view.width,
                                                 height: self.view.height + headerHeight)
        self.contentScrollView.frame = CGRect(x: 0,
                                              y: headerHeight + segmentHeight,
                                              width: self.mainScrollView.width,
                                              height: self.mainScrollView.height - headerHeight - segmentHeight)
        self.contentScrollView.contentSize = CGSize(width: self.mainScrollView.width * 2,
                                                    height: self.contentScrollView.height)

        for (index, childVC) in self.childViewControllers.enumerated() {
            if let tableView = (childVC as? UITableViewController)?.tableView {
                var tableFrame = self.contentScrollView.bounds
                tableFrame.origin.x = CGFloat(index) * self.contentScrollView.width
                tableView.frame = tableFrame
            }
        }
    }

    private func updateCurrentChildVC() {
        if let tableview = (self.currentChildViewController as? UITableViewController)?.tableView {
            let mainOffsetY = self.mainScrollView.contentOffset.y
            let tableOffsetY = tableview.contentOffset.y
            if mainOffsetY > self.headerHeight && tableOffsetY != mainOffsetY - self.headerHeight {
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: self.headerHeight + tableOffsetY),
                                                     animated: false)
            } else if mainOffsetY <= self.headerHeight {
                tableview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.contentScrollView {
            let page: Int = Int(scrollView.contentOffset.x / self.pageWidth)
            self.segmentControl.selectedIndex = page
            self.pageIndex = page
            self.currentChildViewController = self.childViewControllers[page]
            self.updateCurrentChildVC()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            if let tableview = (self.currentChildViewController as? UITableViewController)?.tableView {
                let contentHeight = tableview.contentSize.height
                self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.width,
                                                         height: contentHeight + self.headerHeight + self.segmentHeight)
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            let offsetY = scrollView.contentOffset.y
            if let tableview = (self.currentChildViewController as? UITableViewController)?.tableView {
                var tableFrame = tableview.frame
                var segmentFrame = self.segmentControl.frame
                var headerFrame = self.headerView.frame
                if offsetY > self.headerHeight {
                    segmentFrame.origin.y = offsetY
                    self.segmentControl.frame = segmentFrame
                    self.contentScrollView.frame = CGRect(x: 0,
                                                          y: offsetY + self.segmentHeight,
                                                          width: self.mainScrollView.frame.size.width,
                                                          height: self.view.frame.size.height - self.segmentHeight)
                    tableFrame.size.height = self.contentScrollView.frame.size.height
                    tableview.frame = tableFrame
                    tableview.contentOffset = CGPoint(x: 0, y: offsetY - self.headerHeight)
                } else if offsetY > 0 {
                    segmentFrame.origin.y = self.headerHeight
                    self.segmentControl.frame = segmentFrame
                    let contentHeight = self.mainScrollView.height - self.headerHeight - self.segmentHeight + offsetY
                    self.contentScrollView.frame = CGRect(x: 0,
                                                          y: self.headerHeight + self.segmentHeight,
                                                          width: self.mainScrollView.width,
                                                          height: contentHeight)
                    tableFrame.size.height = self.contentScrollView.height
                } else {
                    headerFrame.origin.y = offsetY
                    self.headerView.frame = headerFrame
                    segmentFrame.origin.y = self.headerHeight + offsetY
                    self.segmentControl.frame = segmentFrame
                    tableview.contentOffset = CGPoint(x: 0, y: offsetY)
                }
            }
        } else if scrollView == self.contentScrollView {

        }
    }

}
