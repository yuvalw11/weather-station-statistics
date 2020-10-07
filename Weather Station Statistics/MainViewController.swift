//
//  ViewController.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 16/12/2018.
//  Copyright © 2018 Yuval Weinstein. All rights reserved.
//

import Cocoa
import Charts


@available(OSX 10.15, *)
class MainViewController: NSViewController, DBObserver, ConnectionObserver, PresentationObserver {
    
    @IBOutlet weak var ModePopUpButton: NSPopUpButton!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var leftTextLabel: NSTextField!
    @IBOutlet weak var upperTextLabel: NSTextField!
    @IBOutlet weak var formTitle: NSTextField!
    @IBOutlet weak var graphView: NSView!
    
    @IBOutlet weak var loadingCircle: NSProgressIndicator!
    @IBOutlet weak var loadingCircleLabel: NSTextField!
    @IBOutlet weak var loadingCircleResult: NSImageView!
    
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var progressBarLabel: NSTextField!
    @IBOutlet weak var progressBarResult: NSImageView!
    
    let wsConnector: WsConnector
    let db: WeatherDatabase
    var graphHandlerViewController: GraphHandlerViewController?
    var currentPresentation: PresentationProtocol
    let homePresentation: HomePresentation
        
    required init?(coder: NSCoder) {
        self.wsConnector = WsConnector()
        self.db = WeatherDatabase()
        self.graphHandlerViewController = nil
        self.currentPresentation = EmptyPresentaion()
        self.homePresentation = HomePresentation(wsConnector: self.wsConnector, db: self.db)

        super.init(coder: coder)
        self.db.assignObserver(observer: self)
        self.wsConnector.assignConnectionObserver(observer: self)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GraphHandlerViewControllerSegue") {
            let destinationVC: GraphHandlerViewController = segue.destinationController as! GraphHandlerViewController
            self.graphHandlerViewController = destinationVC
        }
    }
    
    @IBAction func analyzePressed(_ sender: NSMenuItem) {
        //        let analizeSheet: NSViewController = {
        //            return self.storyboard!.instantiateController(withIdentifier: "analyzeSheet")
        //                as! NSViewController
        //
        //        }()
        //
        //        self.presentAsSheet(analizeSheet)
        //
        self.view.window?.title = "Weather Station Statistics"
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .csv file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = true;
        dialog.allowedFileTypes        = ["csv"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.urls // Pathname of the file
//            self.model.setNewFiles(csvUrls: result)
        }
    }
    
    @IBAction func ConnectWS(_ sender: Any) {
        performSegue(withIdentifier: "IPCOnfigSegue", sender: self)
    }
 
    func performWSConnecting(timeout: Int = 20) {
        if !self.wsConnector.isConnected {
            self.wsConnector.connect(ip: ApplicationSetup.wsIP, timeout: timeout)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.isEnabled = false
        self.ModePopUpButton.isEnabled = false
        
    }
    
    func getPresentation(mode: TimeMode, date: Date) -> PresentationProtocol {
        if mode == .Home {
            return self.homePresentation
        } else if mode == .Day {
            if self.db.dbDays.keys.contains(date) {
                let dayRecord = self.db.dbDays[date]!.first!
                let records = self.db.dbRecordsForDay[date]!
                return DayPresentation(dayRecord: dayRecord, recordsStatement: records)
            } else {
                return EmptyPresentaion()
            }
        } else if mode == .Month {
            if self.db.dbMonths.keys.contains(date) {
                let record = self.db.dbMonths[date]!.first!
                let dayRecords = self.db.dbDaysForMonth[date]!
                return MonthPresentation(monthRecord: record, dayStatement: dayRecords)
            } else {
                return EmptyPresentaion()
            }
        } else if mode == .Year{
            if self.db.dbYears.keys.contains(date) {
                let yearRecord = self.db.dbYears[date]!.first!
                let monthsRecords = self.db.dbMonthsForyear[date]!
                let daysRecords = self.db.dbDaysForYear[date]!
                return YearPresentation(yearRecord: yearRecord, monthsRecords: monthsRecords, daysRecords: daysRecords)
            } else {
                return EmptyPresentaion()
            }
        } else {
            if self.db.seasonal.hasDate(date: date) {
                return RainSeasonPresentation(record: db.seasonal.getRecordByDate(date: date)!, subRecords: RecordCollection(records: self.db.months.getRecordsForRange(from: date, to: Calendar.current.date(byAdding: DateComponents(year: 1), to: date)!)))
            } else {
                return EmptyPresentaion()
            }
            
        }
    }
        
    func recordsChanged() {
        DispatchQueue.main.async {
            self.datePicker.timeZone = TimeZone(secondsFromGMT: 0)
            let high = self.db.getHighestDate()
            let low = self.db.getLowestDate()
            self.datePicker.maxDate = high
            self.datePicker.minDate = low
            self.datePicker.dateValue = self.getSelectedDate()
            self.datePicker.isEnabled = true
            self.ModePopUpButton.isEnabled = true
            
            self.implementPresentation()
        }
    }
    
    func recordInserted(session: InsertSession) {
        DispatchQueue.main.async {
            if session.ended {
                self.progressBarLabel.stringValue = "Update complete"
                self.progressBar.stopAnimation(self)
                self.progressBar.isHidden = true
                self.progressBarResult.isHidden = false
                self.progressBarResult.image = NSImage(named: "true")
            } else if session.currentlyInserted == 0 {
                self.progressBarLabel.stringValue = "Getting new data"
                self.progressBar.isIndeterminate = true
                self.progressBar.isHidden = false
                self.progressBar.startAnimation(self)
                self.progressBarResult.isHidden = true
            } else {
                self.progressBar.isIndeterminate = false
                self.progressBar.minValue = 0
                self.progressBar.maxValue = Double(session.totalRecords)
                self.progressBar.doubleValue = Double(session.currentlyInserted)
            }
        }
    }
    
    func handleLookingForConnection() {
        DispatchQueue.main.async {
            self.loadingCircleLabel.stringValue = ""
            self.loadingCircle.isHidden = false
            self.loadingCircle.startAnimation(self)
            self.loadingCircleLabel.stringValue = "Looking for weather stations..."
            self.loadingCircleResult.isHidden = true
            self.progressBar.isHidden = true
            self.progressBarLabel.stringValue = ""
            self.progressBarResult.image = nil
        }
    }
    
    func handleFoundConnection() {
        DispatchQueue.main.async {
            self.loadingCircle.isHidden = true
            self.loadingCircle.stopAnimation(self)
            self.loadingCircleLabel.stringValue = "Wethaer station connected"
            self.loadingCircleResult.isHidden = false
            self.loadingCircleResult.image = NSImage(named: "true")
            self.ModePopUpButton.select(self.ModePopUpButton.item(withTitle: "Home"))
            
            self.db.set(wsConnector: self.wsConnector, queryForUpdatesEvery: 60)
        }
    }
    
    func handleNotFoundConnection() {
        DispatchQueue.main.async {
            self.loadingCircle.isHidden = true
            self.loadingCircle.stopAnimation(self)
            self.loadingCircleLabel.stringValue = "Wethaer station not found"
            self.loadingCircleResult.isHidden = false
            self.loadingCircleResult.image = NSImage(named: "false")
        }
    }
    
    func handleConnectionStopped() {
        DispatchQueue.main.async {
            self.loadingCircle.isHidden = true
            self.loadingCircle.stopAnimation(self)
            self.loadingCircleLabel.stringValue = "Wethaer station disconnected"
            self.loadingCircleResult.isHidden = false
            self.loadingCircleResult.image = NSImage(named: "false")
            self.performWSConnecting(timeout: 90)
        }
    }
    
    func getSelectedDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if self.ModePopUpButton.selectedItem?.title == "Daily" {
            dateFormatter.dateFormat = "d/M/yyyy"
        } else if self.ModePopUpButton.selectedItem?.title == "Monthly" {
            dateFormatter.dateFormat = "M/yyyy"
        } else if self.ModePopUpButton.selectedItem?.title == "Yearly" ||
            self.ModePopUpButton.selectedItem?.title == "Rain Season"{
            dateFormatter.dateFormat = "yyyy"
        }
        return dateFormatter.date(from: dateFormatter.string(from: self.datePicker.dateValue))!
    }
    
    @IBAction func modeChanged(_ sender: Any) {
        let modeStr = self.ModePopUpButton.selectedItem?.title
        let mode = TimeMode.init(rawValue: modeStr!)!
        if mode == .Home {
            self.datePicker.isHidden = true
        } else if mode == .Day {
            self.datePicker.isHidden = false
            self.datePicker.datePickerStyle = .clockAndCalendar
        } else if mode == .Month{
            self.datePicker.isHidden = false
            self.datePicker.datePickerStyle = .textFieldAndStepper
            self.datePicker.datePickerElements = .yearMonth
        } else {
            self.datePicker.isHidden = false
            self.datePicker.datePickerStyle = .textFieldAndStepper
            self.datePicker.datePickerElements = .yearMonth
        }
        self.implementPresentation()
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        self.implementPresentation()
    }
    
    private func implementPresentation() {
        let modeStr = self.ModePopUpButton.selectedItem?.title
        let mode = TimeMode.init(rawValue: modeStr!)!
        self.currentPresentation.removeObserver(observerToRemove: self)
        self.currentPresentation = self.getPresentation(mode: mode, date: self.getSelectedDate())
        self.currentPresentation.registerObserver(observerToAdd: self)
        self.updateView()
    }
    
    private func updateView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let leftAttributedString = NSMutableAttributedString(string: (self.currentPresentation.getLeftText()))
        leftAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, leftAttributedString.length))
        let upperAttributedString = NSMutableAttributedString(string: (self.currentPresentation.getCenterText()))
        upperAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, upperAttributedString.length))
        
        self.leftTextLabel.attributedStringValue = leftAttributedString
        self.upperTextLabel.attributedStringValue = upperAttributedString
        self.formTitle.stringValue = (self.currentPresentation.getTitle())
        let graphHandler = self.currentPresentation.getGraphHandlingProtocol()
        if graphHandler != nil {
            self.graphHandlerViewController?.setGraphHandler(handler: graphHandler)
            self.graphHandlerViewController?.updateView()
        } else {
            self.graphHandlerViewController?.deleteGraph()
        }
    }
    
    func presentationChanged() {
        DispatchQueue.main.async {
            self.updateView()
        }
    }
}



