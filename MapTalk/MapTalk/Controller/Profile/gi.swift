//
//  ProfileViewController.swift
//  MapTalk
//
//  Created by Frank on 2018/9/29.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import KeychainAccess
import NotificationBannerSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userImageShadowView: UIView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var storyHighlightsTextField: UITextField!
    
    var iconNameArray: [String] = ["個人資料", "聯絡我們", "登出裝置"]
    
    var iconImageArray: [String] = ["new3-pencil-50", "new3-new-post-50", "new4-logout-100"]
    
    // swiftlint:disable identifier_name
    var ref: DatabaseReference!
    // swiftlint:enable identifier_name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "Profile")
        
        storyHighlightsTextField.delegate = self
        
        ref = Database.database().reference()
        
        profileTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        setStoryHighlightsTextField()
        profileTableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func setStoryHighlightsTextField() {
        
        storyHighlightsTextField.borderStyle = UITextField.BorderStyle.none
        storyHighlightsTextField.layer.borderWidth = 2
        storyHighlightsTextField.layer.borderColor = #colorLiteral(red: 0.4588235294, green: 0.6078431373, blue: 1, alpha: 1)
        storyHighlightsTextField.layer.cornerRadius = 30
        //storyHighlightsTextField.frame.width/2
        //iconBackgroundView.frame.width/2
        
    }
    
    func setImage() {
        
        userImage.layer.cornerRadius = 60
        userImage.clipsToBounds = true
        userImageShadowView.clipsToBounds = false
        
        userImageShadowView.layer.applySketchShadow(color: #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1), alpha: 1, x: 0, y: 0, blur: 15, spread: 15, corner: 60)
        
        guard let userDisplayName = Auth.auth().currentUser?.displayName else { return }
        guard let photoSmallURL =  Auth.auth().currentUser?.photoURL?.absoluteString else { return }
        
        let bigPhotoURL = URL(string: photoSmallURL + "?height=500")
        
        //userImage.kf.setImage(with: URL(string: photoSmallURL))
        userImage.kf.setImage(with: bigPhotoURL)
        userName.text = userDisplayName
    }
    
    // 沒有按鈕 做心情動態的動作 結束編輯後執行
    // 鍵盤推掉後執行
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("輸入的內容為\(storyHighlightsTextField.text)")
        
        if let textFieldInput = storyHighlightsTextField.text {
            if textFieldInput == "" {
                BaseNotificationBanner.warningBanner(subtitle: "請輸入您的心情動態")
            } else {
                print("輸入的內容2 為\(textFieldInput)")
                guard let userId = Auth.auth().currentUser?.uid else {
                    BaseNotificationBanner.warningBanner(subtitle: "目前為匿名模式 請登出後使用 Facebook 登入")
                    return }
                
                let userStatus = ["text": textFieldInput]
                
                let childUpdates = ["/location/\(userId)/message": userStatus]
                
                ref.updateChildValues(childUpdates)
                
                //20181020
                let userDefaults = UserDefaults.standard
                
                let myselfGender = userDefaults.value(forKey: "myselfGender")
                
                let userGender = ["gender": myselfGender]
                
                let childUpdatesGender = ["/location/\(userId)/gender": userGender]
                
                ref.updateChildValues(childUpdatesGender)
                BaseNotificationBanner.successBanner(subtitle: "心情動態將顯示在地圖上")
            }
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //var number = 0
        
        guard let textFieldText = textField.text else {
            
            return true
            
        }
        
//        for index in 0...textFieldText.count - 1 {
//            let char : unichar = (textFieldText as NSString).character(at: index)
//
//            if (char >= 0x4E00) {
//                number += 2
//            }else {
//                number += 1
//            }
//        }
        
        //let count = textFieldText.count + string.count - range.length
        //確認幾個字是可以正常顯示的 中英文長度不同 但單元相同ˊ˙
        let count = textFieldText.count + string.count - range.length
        return count <= 14
        
//        let countOfWords = string.characters.count +  textField.text!.characters.count — range.length
//        if countOfWords > 10{
//            return false
//        }
//        wordsCountLabel.text = String(countOfWords)
//        return true

    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//
//    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "Profile", for: indexPath)
            as? ProfileTableViewCell {
            
            cell.iconName.text = iconNameArray[indexPath.row]
            
            cell.iconImage.image = UIImage.setIconTemplate(iconName: iconImageArray[indexPath.row])
            //pencilBtn.addTarget(self, action: "pencilBtnPressed", for: UIControl.Event.touchUpInside)
            cell.iconButton.tag = indexPath.row
            cell.iconButton.addTarget(self, action: #selector(iconBtnClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    @objc func iconBtnClicked(sender: UIButton) {
        
        let indexPath = sender.tag
        
        if indexPath == 0 {
            //configure action when tap cell 1
            print("點了個人資料")
            performSegue(
                withIdentifier: String(describing: UserInfoController.self),
                sender: indexPath
            )
            
        } else if indexPath == 1 {
            
            print("點了聯絡我們")
            performSegue(
                withIdentifier: String(describing: ContactUsViewController.self),
                sender: indexPath
            )
            
        } else if indexPath == 2 {
            
            print("點了登出裝置")
            logOut()
        }
    }
    
    private func logOut() {
        
        let alertController =  UIAlertController.showActionSheet(
        defaultOption: ["登出"]) { (action) in
            
            let alert = UIAlertController.showAlert(
                title: "登出",
                message: "您是否要登出帳號？",
                defaultOption: ["確定"]) { (_) in
                    
                    let keychain = Keychain(service: "com.frank.MapTalk")
                    
                    do {
                        
                        try keychain.remove(FirebaseType.uuid.rawValue)
                        
                        try keychain.remove("anonymous")
                        
                        try Auth.auth().signOut()
                        
                        self.resetDefaults()
                        
                        print("登出成功及清空 user")
                        
                        AppDelegate.shared.switchToLoginStoryBoard()
                        
                    } catch {
                        
                        BaseNotificationBanner.warningBanner(subtitle: "登出失敗，請確認網路")
                        print("登出失敗，請確認網路")
                        return
                    }
                    
            }
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { keys in
            defaults.removeObject(forKey: keys)
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate {}

extension ProfileViewController: UITextFieldDelegate {}