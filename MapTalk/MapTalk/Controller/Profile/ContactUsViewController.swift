//
//  ContactUsViewController.swift
//  MapTalk
//
//  Created by Frank on 2018/10/1.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //下面這行沒用
        //navigationController?.title = "聯絡我們"
//        self.navigationController?.navigationBar.topItem?.title = "Your Title"
        
        //self.view.backgroundColor = .clear
        //self.view.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.7137254902, blue: 1, alpha: 1)
          self.view.backgroundColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "     聯絡我們"
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
