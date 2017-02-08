//
//  LocationAndTimeViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class LocationAndTimeViewController : UIViewController, UITableViewDataSource,UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var locationAndTimeButton: UIButton!
    @IBOutlet weak var orderDetailButton: UIButton!
    @IBOutlet weak var confirmAndCheckOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var roomLayout:NSDictionary = ["Apartment":["101","102","103","104","105","106","107","108","109","110","201","202","203","204","205","206","207","208","209","210","301","302","303","304","305","306","307","308","309","310"],
                                   "Logan Library":["Second Floor Open Area", "Third Floor Open Area","L206","L207","L208","L209","L210","L211","L212","L213","L214","L215","L216","L218","L220","L221","L222","L223","L302","L306","L307","L308","L309","L310","L311","L312","Other"],
                                   "Blumberg":["Lobby","101","104","105","106","107","108","109","110","111","112","113","115","201", "202","203","204","205","206","207","208","209","210","211","212","301","302","303","304","305","306","307","308","309","310","311","312","401","402","403","404","405","406","407","408","409","410","411","412","Other"],
                                   "BSB":["003","004","005","006","007","008","009","011","012","013","014","015","016","017","018","022","100","104","106","107","108","109","110","111","112","113","114","115","116","118","120","122","124","126","128","130","131","201","202","203","204","206","207","208","209","210","211","212","213","214","215","216","218","220","222","224","226","228","230","231","301","302","303","304","306","307","308","309","310","311","312","313","314","315","316","318","320","322","324","326","328","330","331","First Floor Lobby","Other"],
                                   "Crapo":["G101","G103","G105","G106","G108","G110","G113","G115","G117","G119","G121","G123","G131","G132","G133","G134","G135","G136","G137","G138","G139","G141","G143","G145","G147","G149","G151","G153","G204","G205","G205A","G207","G209","G210A","G210B","G211","G212","G213","G214","G215A","G215B","G216","G217","G218","G219","G220","G221","G222","G304","G305","G306","G307","G308","G309","G310","G311","G313","G315","G317","Other"],
                                   "Lakeside":["101","102","103","104","106","107","108","109","110","111","112","113","114","115","116","First Floor Lobby","117","118","119","120","121","122","123","124","125","126","127","128","129","131","201","202","203","204","206","207","208","209","210","211","212","213","214","215","301","302","303","304","306","307","308","309","310","311","312","313","314","315","401","402","403","404","406","407","408","409","410","411","412","413","414","415","Other"],
                                   "Deming":["001","002","003","004","005","006","007","008","009","010","011","013","019","020","021","022","023","024","Living Room","Kitchen","Game Room","101A","103","104","105","107","109","112","114","116","117","118","119","121","201","202","203","204","205","206","207","208","209","210","212","214","215","216","217","218","219","220","221","222","301","302","303","304","305","306","306A","306B","307","307A","308","309","310","311","Other"],
                                   "Mees":["Lobby","101","104","105","106","107","108","109","110","111","112","113","115","201", "202","203","204","205","206","207","208","209","210","211","212","301","302","303","304","305","306","307","308","309","310","311","312","401","402","403","404","405","406","407","408","409","410","411","412","Other"],
                                   "Monech":["FL201","FL202","FL203","FL205","FL206","EL202","EL205","EL207","EL211","DL201","DL202","DL204A","DL204B","DL205","DL206","DL206A","DL207","CL202","CL202A","CL202B","CL203","CL204","CL205","CL206","CL207","CL208","FL101","FL101A","FL102","FL103","FL104","FL106","FL107","FL108","FL109","FL110","EL103","EL106","DL101","DL102","DL103","DL104","DL105","DL106","DL107","DL108","DL110","DL110A","DL110B","DL110C","DL110D","DL110E","DL110F","DL110G","DL115","DL116","DL117","DL117A","DL118","DL119","DL120","CL101","CL102A","CL102B","CL103","CL104","CL105","CL106","CL107","CL108","CL109","CL110","CL112","CL113","CL114","CL115","CL116","CL117","CL119","BL100","BL101","BL102","BL103","BL104","BL105","BL106","BL107","BL108","BL109","BL110","BL112","BL113","BL114","BL115","BL116","BL117","AL101","AL102","AL103","AL104","AL105","A101","A102","A102A","A103","A104","A105","A106","A107","A108","A109","A110","A111","A112","A113A","A113B","A113C","A113D","A115","A116","A121","A123","A124","A125","A126","A127","A128","A129","A130","A138","B100","B101","B102","B103A","B103B","B104","B105","B106","B107A","B107B","B108A","B108B","B108C","B109","B110","GM Room B111","C101","C101A","C102","C103","C103A","C104","C105","C106","C107","C108","C109","C110","C111","C112","C113","C114","C115","C115A","C116","C117","C118","D101","D101-A","D102","D103","D104","D105","D106","D107","D108","D109","D110","D111","D111-1","D112","D113","D114","D115","D116","D117","D118","E101","E102","E104","E105A","E105","E106","E107","F101","F102","F102A","F103","F104","F105","F106","F107","F108","F109","F110","F111","F112","F113","F114","A200","A200A","A201","A202","A203A","A203B","A203C","A203D","A204","A205","A206","A207","A208","A209","A210","A211","A212","A213","A214","A215","A216","A217","A218","A219","A220","B200","B201","B202","B203","B204","B205","B206","B207","C201","C202","C203","C204","C203A","C204","C205","C206","C207","C208","C209","C210","C211","C212","C214","C215","C216","C217","C218","D201","D202","D203","D204","D205","D206","D207","D208","D209","D210","D211","D212","D214","D215A","D215B","D216","D217","D218","D219","D220","D221","D222", "D223","D224","D225","D226","D227","D228","D229","D230","D231","D232","E201","E203","E204","E205","E206","E207","F203","F204","F205","F206","F210","F212","F214","F216","F217","F218","F220","F222","F224","F225","F226","F228","F230","F231","F233","Other"],
                                   "Myers":["M100","M100A","M101","M102","M103","M104","M105","M106","M107","M108","M110","M11","M112","M114","M115","M120","M122","M124","M125","M126","M129","M130","M133","M138","M142","M146","M148","M200","M201","M202","M203","M204","M206","M207","M208","M209","M210","M212","M214","M215","M220","M222","M224","M225","M226","M227","M230A","M230B","M230C","M230D","M233","M240A","M240B","M240C","M240D","M242","M246A","M246B","M246C","M246D","M246E","M246F","Other"],
                                   "Percopo":["001","002","003","005","006","007","008","009","010","011","012","013","014","015","016","017","018A","018B","018C","018D","019","021","023","025","029","031","035","040","042","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118A","118B","118C","118D","118E","118F","118G","119","120","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218A","218B","218C","218D","219","220","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","300","301","302","303","304","305","306","307","308","309","310","311","312","313","314","315","316","317","318A","318B","318C","318D","319","320","322","323","324","325","326","327","328","329","330","331","332","333","334","335","336", "Other"],
                                   "Scharpenberg":["Lobby","101","104","105","106","107","108","109","110","111","112","113","115","201", "202","203","204","205","206","207","208","209","210","211","212","301","302","303","304","305","306","307","308","309","310","311","312","401","402","403","404","405","406","407","408","409","410","411","412","Other"],
                                   "Skinner":["A1","A1A","A1B","A1C","A1D","A2","A2A","A2B","A2C","A2D","B1","B1A","B1B","B1C","B1D","B2","B2A","B2B","B2C","B2D","C1","C1A","C1B","C1C","C1D","C2","C2A","C2B","C2C","C2D","A3","A3A","A3B","A3C","A3D","A4","A4A","A4B","A4C","A4D","B3","B3A","B3B","B3C","B3D","B4","B4A","B4B","B4C","B4D","C3","C3A","C3B","C3C","C3D","C4","C4A","C4B","C4C","C4D","Other"],
                                   "Speed":["Lobby","001","002","003","Kitchen","013","015A","015B","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","123","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","301","302","303","304","305","306","307","308","309","310","311","312","313","314","315","316","317","318","319","320","321","322","323","324","Other"],
                                   "Olin":["O100","O100A","O109B","O101","O102","O102A","O102B","O103","O104","O104B","O105","O106","O107","O108","O108A","O109","O109A","O109B","O109C","O109D","O109E","O109F","O109G","O110","O111","O111A","O113","O113A","O115","O157","O159","O167","O169","O200","O200A","O200B","O200C","O201","O202","O203","O203-1","O204","O205","O206","O207","O207A","O207B","O207C","O207D","O207E","O207F","O207F","O208","O209","O210","O211","O212","O213","O214","O215","O216","O217","O218","O219","O220","O221","O222","O222A","O224","O225","O225A","O225B","O225C","O225D","O225E","O225F","O226","O227","O229","O231","O233","Other"],
                                   "Other": ["Other"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 49, green: 8, blue: 7, alpha: 0)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationAndTimeViewController.loadData),name:NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    func loadData(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "load"), object:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Quick Order")
        cell.accessoryType = .disclosureIndicator
        let defaults = UserDefaults.standard
        if indexPath.row == 0 {
            cell.textLabel?.text = "Quick Order"
            cell.detailTextLabel?.text = "Lakeside 203 at 9 pm"
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "Building"
            cell.detailTextLabel?.text = ""
            if defaults.object(forKey: "location") != nil {
                cell.detailTextLabel?.text = defaults.object(forKey: "location") as! String?
            }
            
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "Room"
            cell.detailTextLabel?.text = ""
            if defaults.object(forKey: "room") != nil {
                cell.detailTextLabel?.text = defaults.object(forKey: "room") as! String?
            }
        }else{
            cell.textLabel?.text = "Time"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            cell.detailTextLabel?.text = dateFormatter.string(from: Date())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1){
            selectBuilding()
        }
        if (indexPath.row == 2){
            selectRoom()
        }
        if (indexPath.row == 3){
            selectTime()
        }
    }
        
    func selectBuilding(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: LocationPickerViewController = storyboard.instantiateViewController(withIdentifier: "locationModal") as! LocationPickerViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modal.type = "location"
        modal.pickerData = ["Apartment", "Blumberg", "BSB", "Crapo", "Deming", "Lakeside", "Logan Library", "Mees", "Monech", "Myers", "Olin", "Percopo", "Scharpenberg",  "Skinner", "Speed", "Other"]
        self.present(modal, animated: true)
    }
    
    func selectRoom(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: LocationPickerViewController = storyboard.instantiateViewController(withIdentifier: "locationModal") as! LocationPickerViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modal.type = "room"
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "location") != nil {
            modal.pickerData = roomLayout.object(forKey: defaults.object(forKey: "location")) as! [String]
        }else{
            modal.pickerData = roomLayout.object(forKey: "Logan Library") as! [String]
        }
        self.present(modal, animated: true)
    }
    
    func selectTime(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: TimePickerViewController = storyboard.instantiateViewController(withIdentifier: "timeModal") as! TimePickerViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(modal, animated: true)
    }

}



