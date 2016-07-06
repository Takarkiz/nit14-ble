//
//  StartViewController.swift
//  nit-formula14
//
//  Created by 澤田昂明 on 2016/07/06.
//  Copyright © 2016年 Takarki. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func drive(){
       self.performSegueWithIdentifier("toStart", sender: nil)
    }
    
    @IBAction func pit(){
        self.performSegueWithIdentifier("toPit", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
