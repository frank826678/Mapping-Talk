//
//  EditViewController.swift
//  MapTalk
//
//  Created by Frank on 2018/10/1.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EditViewController: UIViewController {
    
    @IBOutlet weak var editTableView: UITableView!
    
    var userInfo = ["性別","生日","感情狀態","居住地","體型","我想尋找"]
    var userSelected =  ["男","1993-06-06","單身","台北","臃腫","喝酒"]
    
    let gender = ["男生","女生","第三性別"]
    let relationship = ["不顯示","秘密","單身","穩定交往","交往中但保有交友空間","一言難盡"]
    let city = ["基隆市","台北市","新北市","桃園縣","新竹市","新竹縣","苗栗縣","台中市","彰化縣","南投縣","雲林縣","嘉義市","嘉義縣","台南市","高雄市","屏東縣","台東縣","花蓮縣","宜蘭縣","澎湖縣","金門縣","連江縣"]
    
    let bodyType = ["體型纖細","勻稱","中等身材","肌肉結實","微肉","豐滿"]
    let searchTarget = ["網上私聊","短暫浪漫","固定情人","開放式關係","先碰面再說","談心朋友"]
    
    var selectedSender: Int = 0
    
    var pickerView:UIPickerView!
    var datePicker: UIDatePicker!
    
    let fullScreenSize = UIScreen.main.bounds.size
    // personInfo: PersonalInfo = PersonalInfo()
    var personInfo: PersonalInfo?
    var date: Date?
    //var selectedDate: String = "1980-01-01"
    
    //var friend: String?
    
    // swiftlint:disable identifier_name
    var ref: DatabaseReference!
    // swiftlint:enable identifier_name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        editTableView.delegate = self
        editTableView.dataSource = self
        
        editTableView.register(UINib(nibName: "EditUserDataTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "EditUserData")
        editTableView.register(UINib(nibName: "EditContentTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "EditContent")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveClicked))
        
        ref = Database.database().reference() //重要 沒有會 nil
        
        downloadUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.topItem?.title = "     編輯資料"
        
        
    }
    
    @objc func saveClicked() {
        print("點擊了按下 Save 的按鈕")
        //上傳到 firebase
        uploadUserInfo()
    }
    
    func uploadUserInfo() {
//        //let value = genderChanged.(value)
//        //let title = genderChanged
//        print(genderSegment.selectedSegmentIndex)
//        
//        //應該要有個地方 存自己的年紀性別和經緯度來算距離
//        guard let datingNumber = datingNumber else { return }
//        guard let timeNumber = timeNumber else { return }
//        
//        //有可能沒按到約會類型和時間範圍 要給預設值或是設定?
//        guard let filterAllData: Filter = Filter(gender: genderSegment.selectedSegmentIndex,
//                                                 age: ageSegment.selectedSegmentIndex,
//                                                 location: locationSegment.selectedSegmentIndex,
//                                                 dating: datingNumber,
//                                                 time: timeNumber)    else { return }
//        
//        print("filterALLData 是 \(filterAllData)")
        print("*********")
        //print(userSelected)
        print("準備上傳的 userSelected 是\(userSelected)")
        
        //print("自己的位置是\(centerDeliveryFromMap)")
        //guard let text = messageTxt.text else { return }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        //guard let userName = Auth.auth().currentUser?.displayName else { return }
        
        //guard let userImage = Auth.auth().currentUser?.photoURL?.absoluteString else { return }
        
        //let createdTime = Date().millisecondsSince1970
        
        //let messageKey = self.ref.child("FilterData").child("PersonalChannel").child(friendChannel).childByAutoId().key
        
        
        //  "location": filterAllData.location,
        //         "location": ["lat": currentLocation.coordinate.latitude,"lon": currentLocation.coordinate.longitude],
        
        // 或是經緯度先給預設值 只要他有移動位置 就會更新他目前的位置 但是要是第一次進來直接媒合 這邊 setvalue 可能會取代掉正確的位置資訊  這邊可以試著用 update
        // 25°2'51"N   121°31'1"E 北車
        
        //此時的 userSelected 是 array
        self.ref.child("UserInfo").child(userId).setValue(userSelected) { (error, _) in
            
            if let error = error {
                
                print("Data could not be saved: \(error).")
                
            } else {
                
                print("Data saved successfully!")
                
            }
        }
        
        //searchFilterData(filterData: filterAllData)
        
    }
    
    func downloadUserInfo() {
       
        print("*********")
        //print(userSelected)
        //print("準備上傳的 userSelected 是\(userSelected)")
        
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        //此時的 userSelected 是 array
        self.ref.child("UserInfo").child(userId).observeSingleEvent(of: .value, with: { (snapshot)
            
            in
            
            print("找到的資料是\(snapshot)")
            
            //NSDictionary
            //var userSelected =  ["男","1993-06-06","單身","台北","臃腫","喝酒"]
            
            //這邊可以試著用 codable
            guard let value = snapshot.value as? NSArray else { return }
            print("*********1")
            
            print(value)
            
            guard let userGender = value[0] as? String else { return }
            guard let userBirthday = value[1] as? String else { return }
            guard let userRelationship = value[2] as? String  else { return }
            guard let userCity = value[3] as? String else { return }
            guard let userBodyType = value[4] as? String  else { return }
            guard let userSearchTarget = value[5] as? String else { return }
 
            print("*********2接回來的資料為")
            
            print(userRelationship)
            print(userSearchTarget)
            //可以接到資料
            
            self.userSelected[0] = userGender
            self.userSelected[1] = userBirthday
            self.userSelected[2] = userRelationship
            self.userSelected[3] = userCity
            self.userSelected[4] = userBodyType
            self.userSelected[5] = userSearchTarget
            
            self.editTableView.reloadData()
            
        })
        
    }

    
}

extension EditViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if section == 0 || section ==  1 || section ==  3 {
        
        if section == 1 {
            return 6
        } else {
            return 1
        }
        
    }
    
    // 設置每個 section 的 title 為一個 UIView
    // 如果實作了這個方法 會蓋過單純設置文字的 section title
    private func tableView(tableView: UITableView,
                           viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // 設置 section header 的高度
    private func tableView(tableView: UITableView,
                           heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        var title = "暱稱"
        
        if section == 0 {
            
            title = "暱稱"
            
        } else if section == 1 {
            
            title = "基本資料"
            
        } else if section == 2 {
            
            title = "專長 興趣"
            
        } else if section == 3 {
            
            title = "喜歡的國家"
            
        } else if section == 4 {
            
            title = "自己最近的困擾"
            
        } else if section == 5 {
            
            title = "想嘗試的事情"
            
        } else {
            
            title = "自我介紹"
            
        }
        
        return title
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditUserData", for: indexPath)
                as? EditUserDataTableViewCell {
                
                //cell.contentTextView.text = "FRANK"
                cell.baseView.contentTextView.text = "FRANK"
                
                
                return cell
            }
            
        case 1:
            
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditContent", for: indexPath)
                as? EditContentTableViewCell {
                
                cell.userInfoButton.tag = indexPath.row
                
                //全域 sender
                //                selectedSender = indexPath.row
                cell.userInfoButton.addTarget(self, action: #selector(userInfoButtonClicked(sender:)), for: .touchUpInside) //要加 .
                //cell.userInfoButton.titleLabel?.text = "123"
                cell.userInfoButton.setTitle(userSelected[indexPath.row], for: .normal)//设置按钮显示的文字
                //cell.userInfoButton..titleLabel?.font = UIFont.systemFont(ofSize: 23)
                //OK
                cell.userInfoButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                
                
                cell.userInfoLabel.text = userInfo[indexPath.row]
                
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditUserData", for: indexPath)
                as? EditUserDataTableViewCell {
                
                //cell.contentTextView.text = "吃飯，睡覺"
                cell.baseView.contentTextView.text = "吃飯，睡覺"
                
                return cell
            }
            
        case 3:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditUserData", for: indexPath)
                as? EditUserDataTableViewCell {
                
                //cell.contentTextView.text = "台灣"
                cell.baseView.contentTextView.text = "台灣"
                
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditUserData", for: indexPath)
                as? EditUserDataTableViewCell {
                
                //cell.contentTextView.text = "變胖了"
                cell.baseView.contentTextView.text = "變胖了"
                
                return cell
            }
            
        case 5:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditUserData", for: indexPath)
                as? EditUserDataTableViewCell {
                
                //cell.contentTextView.text = "跳海"
                cell.baseView.contentTextView.text = "跳海"
                
                return cell
            }
            
        case 6:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "EditUserData", for: indexPath)
                as? EditUserDataTableViewCell {
                
                //cell.contentTextView.text = "大家好 我是法克"
                cell.baseView.contentTextView.text = "大家好 我是法克"
                cell.delegate = self
                cell.baseView.delegate = self
                return cell
            }
            
            
            //return UITableViewCell()
            
        default:
            
            return  UITableViewCell()   //要有() 也因為上面有 -> UITableViewCell 所以一定要有一個回傳值
        }
        
        return  UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 100
    }
}

extension EditViewController: UITableViewDelegate{}

extension EditViewController: CellDelegate {
    
    //    func updateLocalData(data: Any) {
    //
    //        guard let text = data as? String else {
    //
    //            return
    //        }
    //
    //        guard let currentUser =  Auth.auth().currentUser else {
    //
    //            return
    //
    //        }
    //
    //        #warning ("改view")
    //
    //        guard let sectionIndex = allData.firstIndex(where: {$0.dataType == .previousComments(comments.count)}) else {
    //
    //            return
    //        }
    //
    //        comments.append(
    //            CommentModel(
    //                postDate: Date(),
    //                user: UserModel.groupMember(
    //                    image: "currentUser.photoURL",
    //                    name: currentUser.displayName!
    //                ),
    //                comment: text
    //            )
    //        )
    //
    //        allData[sectionIndex] = DataType(
    //            dataType: .previousComments(comments.count),
    //            data: comments)
    //
    //        self.tableView.reloadData()
    //    }
    
    func reszing(heightGap: CGFloat) {
        
        editTableView.contentInset.bottom += heightGap
        editTableView.contentOffset.y += heightGap
        
    }
    
    //    func cellButtonTapping(_ cell: UITableViewCell) {
    //
    //        guard let currentUser =  Auth.auth().currentUser else {
    //
    //            return
    //
    //        }
    //
    //        #warning ("update 這邊 order 的 data")
    //
    //        guard let sectionIndex = allData.firstIndex(where: {$0.dataType == .productItems(products.count)}) else {
    //
    //            return
    //        }
    //
    //        for (index) in products.indices {
    //
    //            guard let cell = tableView.cellForRow(
    //                at: IndexPath(row: index, section: sectionIndex)
    //                ) as? ProductItemTableViewCell else {
    //
    //                    return
    //            }
    //
    //            products[index].numberOfItem -= order[index].numberOfItem
    //            order[index].numberOfItem = 0
    //
    //            cell.updateView(product: products[index])
    //
    //        }
    //
    //        #warning ("更新 firebase 的資料後重新 fetch")
    //        joinMember.append(
    //            UserModel(
    //                userImage: currentUser.photoURL!.absoluteString,
    //                userName: currentUser.displayName!,
    //                numberOfEvaluation: 2,
    //                buyNumber: 3,
    //                averageEvaluation: 5.0
    //            )
    //        )
    //
    //        let banner = NotificationBanner(title: "加團成功", subtitle: "詳細資訊請到歷史紀錄區查詢", style: .success)
    //        banner.show()
    //
    //        #warning ("加團失敗的警告")
    //
    //        guard let index = allData.firstIndex(where: {$0.dataType == .joinGroup}),
    //            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: index)) as? JoinGroupTableViewCell else {
    //
    //                return
    //        }
    //
    //        cell.collectionView.reloadData()
    //
    //        tableView.reloadData()
    //    }
    
}

extension EditViewController: UIPickerViewDataSource {
    
    //@IBAction
    //let test = "3" Extensions must not contain stored properties
    
    @objc func userInfoButtonClicked(sender: UIButton) {
        
        let buttonRow = sender.tag
        selectedSender = buttonRow
        //let result = articles[buttonRow]
        if buttonRow == 1 {
            dateButtonPressed(buttonRow)
        } else {
            selectDatePick(buttonRow)
            
        }
        print(buttonRow) //OK 可以知道點了哪一個
    }
    
    func dateButtonPressed(_ sender: Any) {
        
        datePicker = UIDatePicker(frame: CGRect(
            x: -10, y: 0,
            width: fullScreenSize.width, height: 250))
        
        datePicker.datePickerMode = .date
        
        datePicker.date = Date()
        
        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
        title: "確定", style: UIAlertAction.Style.default) { (_) -> Void in
            
            print("選取的時間是\(self.datePicker.date)")
            let pickerDate = DateManager.share.formatDate(date: self.datePicker.date)
            
            self.userSelected[1] = pickerDate
            
            //date = pickerDate
            
            //            guard let cell = self.editTableView.cellForRow(at: IndexPath(row: 0, section: 1))
            //                as? EditContentTableViewCell else { return }
            //
            
            
            //            let pickerDate = DateManager.share.transformDate(date: self.datePicker.date)
            //
            //            self.date = pickerDate
            //
            //            print(pickerDate)
            //
            //            let titleDate = DateManager.share.formatDate(forTaskPage: pickerDate)
            //
            //            self.dateButton.setTitle(titleDate, for: .normal)
            
            print("轉換過的時間為\(pickerDate)")
            //要有 reload data 此時 model 已經改變
            self.editTableView.reloadData()
            
        })
        
        alertController.addAction(UIAlertAction(
            title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        
        alertController.view.addSubview(datePicker)
        
        //self.show(alertController, sender: nil)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //    func dateButtonPressed(_ sender: Any) {
    //
    //        datePicker = UIDatePicker(frame: CGRect(
    //            x: 0, y: 0,
    //            width: UIScreen.main.bounds.width - 5, height: 250))
    //
    //        datePicker.datePickerMode = .date
    //
    //        datePicker.date = Date()
    //
    //        let alertController: UIAlertController = UIAlertController(
    //            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
    //
    //        alertController.addAction(UIAlertAction(
    //        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in
    //
    //            //let pickerDate = DateManager.share.transformDate(date: self.datePicker.date)
    //
    //            //self.date = pickerDate
    //
    //            //print(pickerDate)
    //
    //            //let titleDate = DateManager.share.formatDate(forTaskPage: pickerDate)
    //
    //            //self.dateButton.setTitle(titleDate, for: .normal)
    //        })
    //
    //        alertController.addAction(UIAlertAction(
    //            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    //
    //        alertController.view.addSubview(datePicker)
    //
    //        self.show(alertController, sender: nil)
    //    }
    
    func selectDatePick(_ sender: Any) {
        //初始化UIPickerView
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //设置选择框的默认值
        //pickerView.selectRow(0, inComponent:0, animated:true)
        //把UIPickerView放到alert里面（也可以用datePick）
        
        let alertController: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            
                print("確定送出為\(self.pickerView.selectedRow(inComponent: 0))的 row")
                let rowInt = self.pickerView.selectedRow(inComponent: 0)
            
            //var userSelected =  ["男","1993-06-06","單身","台北","臃腫","喝酒"]
            
            if self.selectedSender == 0 {
               
                self.userSelected[0] = self.gender[rowInt]
                
            } else if self.selectedSender == 2 {
                
                self.userSelected[2] = self.relationship[rowInt]
            
            } else if self.selectedSender == 3 {
               
                self.userSelected[3] = self.city[rowInt]
                
            } else if self.selectedSender == 4 {
                
                self.userSelected[4] = self.bodyType[rowInt]
                
            } else if self.selectedSender == 5 {
                
                             self.userSelected[5] = self.searchTarget[rowInt]
                
            }
            
            self.editTableView.reloadData()
            
            print("目前的 userSelected 是\(self.userSelected)")
            //print("date select:" + String(self.pickerView.selectedRow(inComponent: 0)+1))
//            personInfo?.gender = gender[rowInt]
//                    personInfo?.relationship = relationship[rowInt]
//                    personInfo?.city = city[rowInt]
//                    personInfo?.bodyType = bodyType[rowInt]
//
//                    personInfo?.searchTarget = searchTarget[rowInt]
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler:nil))
        //let width = frameView.frame.width;
        
        //350
        pickerView.frame = CGRect(x: -10, y: 0, width: fullScreenSize.width, height: 250)
        alertController.view.addSubview(pickerView)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //@IBOutlet weak var frameView: UIView!
    
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        if selectedSender == 0 {
            return gender.count
        } else if selectedSender == 2 {
            return relationship.count
        } else if selectedSender == 3 {
            return city.count
        } else if selectedSender == 4 {
            return bodyType.count
        } else if selectedSender == 5 {
            return searchTarget.count
        } else {
            return 12
        }
        
        //return 12
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow rowInt: Int,
                    forComponent component: Int) -> String? {
        //少日期
        if selectedSender == 0 {
            return gender[rowInt]
        } else if selectedSender == 2 {
            return relationship[rowInt]
        } else if selectedSender == 3 {
            return city[rowInt]
        } else if selectedSender == 4 {
            return bodyType[rowInt]
        } else if selectedSender == 5 {
            return searchTarget[rowInt]
        } else {
            
            return String(rowInt+1)+""+String("個月")
            
        }
        
        
        //return String(rowInt+1)+""+String("個月")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow rowInt: Int, inComponent component: Int) {
        //        if component == 0 {
        //            // whatDay 設置為陣列 week 的第 row 項資料
        //            whatDay = week[row]
        //        } else {
        //            // 否則就是改變第二列
        //            // whatMeal 設置為陣列 meals 的第 row 項資料
        //            whatMeal = meals[row]
        //        }
        
        // 將改變的結果印出來
        //personInfo = PersonalInfo()
        
//        if selectedSender == 0 {
//
//        } else if selectedSender == 2 {
//            return relationship[rowInt]
//        } else if selectedSender == 3 {
//            return city[rowInt]
//        } else if selectedSender == 4 {
//            return bodyType[rowInt]
//        } else if selectedSender == 5 {
//            return searchTarget[rowInt]
//        }
        
//        personInfo = PersonalInfo(gender: gender[rowInt], relationship: relationship[rowInt], city: city[rowInt]
//            , bodyType: bodyType[rowInt], searchTarget: searchTarget[rowInt])
//
//
//        personInfo?.gender = gender[rowInt]
//        personInfo?.relationship = relationship[rowInt]
//        personInfo?.city = city[rowInt]
//        personInfo?.bodyType = bodyType[rowInt]
//
//        personInfo?.searchTarget = searchTarget[rowInt]
       
        //
        
        //        let gender: String
        //
        //        let relationship: String
        //
        //        let city: String
        //
        //        let bodyType: String
        //
        //        let searchTarget: String
        
        //friend = "123"
        //print("目前有選擇的是 \(personInfo) ，\(personInfo?.gender),\(friend)")
    }
    
}

extension EditViewController: UIPickerViewDelegate {}
