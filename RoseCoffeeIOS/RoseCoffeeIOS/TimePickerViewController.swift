
class TimePickerViewController : UIViewController {
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var picker: UIDatePicker!
    var selectedTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.layer.cornerRadius = 10
        
        picker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTime(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(selectedTime, forKey: "time")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func timeChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        selectedTime = dateFormatter.string(from: sender.date)

    }
    
}

