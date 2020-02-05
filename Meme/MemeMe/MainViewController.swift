//
//  MainViewController.swift
//  MemeMe
//
//  Created by Kay Khine win on 5/2/20.
//  Copyright © 2020 Kay Khine win. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createMeme(_ sender: Any) {
        performSegue(withIdentifier: "createMeme", sender: self)
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
