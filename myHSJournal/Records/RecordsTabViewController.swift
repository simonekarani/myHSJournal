//
//  RecordsTabViewController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/1/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit
import Tabman
import Pageboy

class RecordsTabViewController: TabmanViewController {
    
    let highSchoolYearArray = ["Before High School", "Freshmen", "Sophomore", "Junior", "Senior"]

    private var viewControllers = [UIViewController(), UIViewController(), UIViewController(),
        UIViewController(), UIViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}

extension RecordsTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = highSchoolYearArray[index]
        return TMBarItem(title: title)
    }
}
