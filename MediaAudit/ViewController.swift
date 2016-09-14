//
//  ViewController.swift
//  test
//
//  Created by Long, James A on 9/7/16.
//  Copyright © 2016 Long, James A. All rights reserved.
//

import Cocoa
import CryptoSwift

class ViewController: NSViewController {
	
	var url: NSURL?
	var checksumMap = NSMutableDictionary()
	var duplicateFileMap = NSMutableDictionary()
	var cancelled = false
	
	@IBOutlet weak var folderLabel: NSTextField!
	@IBOutlet weak var fileLabel: NSTextField!
	@IBOutlet weak var processingTimeLabel: NSTextField!
	@IBOutlet weak var processingCountLabel: NSTextField!
	@IBOutlet weak var selectButton: NSButton!
	@IBOutlet weak var processButton: NSButton!
	@IBOutlet var cancelButton: NSButton!
	@IBAction func cancelProcessing(sender: AnyObject) {
		self.cancelled = true
	}

	@IBOutlet weak var slider: NSProgressIndicator!
	@IBOutlet weak var statusLabel: NSTextField!

	@IBAction func browseDuplicates(sender: AnyObject) {
		
	}
	@IBAction func selectFolder(sender: AnyObject) {
		
		let dialog = NSOpenPanel();
		
		dialog.title                   = "Choose a folder";
		dialog.showsResizeIndicator    = true;
		dialog.showsHiddenFiles        = false
		dialog.canChooseDirectories    = true
		dialog.canChooseFiles          = false
		dialog.canCreateDirectories    = true
		dialog.allowsMultipleSelection = false
		
		if (dialog.runModal() == NSModalResponseOK) {
			url = dialog.URL
			
			guard
				let url = url,
				let folder = url.path
				else {
					return
			}
			folderLabel.stringValue = folder
			
			// Save selected Url
			NSUserDefaults.standardUserDefaults().setObject(folder, forKey: "folder")
			
	}  else {
			// User clicked on "Cancel"
			return
		}
	
	}


	@IBAction func processFolder(sender: AnyObject) {
		
		checksumMap.removeAllObjects()
		duplicateFileMap.removeAllObjects()
		cancelled = false
		slider.doubleValue = 0.0
		
		let startTime = NSDate()
		
		guard
			let url = self.url,
			let folder = url.path
			else {
				processButton.title = "Done"
				return
		}
		
		//		let folder = "/Users/v644112/Desktop"
		//		let url = NSURL(fileURLWithPath: folder, isDirectory: true)
		
		
		folderLabel.stringValue = folder
		processButton.title = "Processing..."
		
		if let urls = getFilesInFolder(url) {
			
			var count = 0
			let total = urls.count
			for url in urls {
				count += 1
				let currentFilename = url.path ?? ""
				fileLabel.stringValue = currentFilename
				NSRunLoop.mainRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:0.001))
				if let data = NSData(contentsOfFile: currentFilename) {
					let checksum = data.md5().toHexString()
						if let checksumFilename = self.checksumMap[checksum] {
							// dup
							print("file: \(checksumFilename) is a duplicate of \(currentFilename)")
							if let dups = duplicateFileMap[checksum] as? NSArray {
								let newdups = NSMutableArray()
								newdups.addObjectsFromArray(dups as [AnyObject])
								newdups.addObject(currentFilename)
								self.duplicateFileMap[checksum] = newdups
							} else {
								self.duplicateFileMap[checksum] = [checksumFilename, currentFilename]
							}
							
						} else {
							checksumMap[checksum] =  currentFilename
						}
				}
				let c = duplicateFileMap.count
				statusLabel.stringValue = "\(c) duplicate checksum\((c > 1) || (c == 0) ? "s" : "") found."

				let percent = Double(Float(count)/Float(total) * 100)
				slider.doubleValue = percent
				processButton.title = "Processing: \(Int(percent))%"
				processingTimeLabel.stringValue = "Processing time: [\(startTime.timeSinceStringCondensed())]"
				processingCountLabel.stringValue = "Processing file: [\(count) of \(total)]"
				NSRunLoop.mainRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:0.001))
				if cancelled {
					cancelButton.title = "Cancelled"
					return
				}
			}
		}
		processButton.title = "Done"
		
	}
	
	func updateStatusLabel(count: Int) {
			statusLabel.stringValue = "\(count) duplicate\((count > 1) || (count == 0) ? "s" : "") found."
	}
	
	
	func getFilesInFolder(url: NSURL) -> [NSURL]? {
		let keys = [NSURLNameKey, NSURLIsDirectoryKey]
		let enumerator = NSFileManager().enumeratorAtURL(url, includingPropertiesForKeys: keys, options: [.SkipsHiddenFiles], errorHandler: nil)!
		
		var urls: [NSURL] = []
		for case let url as NSURL in enumerator {
			guard let resourceValues = try? url.resourceValuesForKeys(keys),
				let isDirectory = resourceValues[NSURLIsDirectoryKey] as? Bool,
				let name = resourceValues[NSURLNameKey] as? String
				else {
					continue
			}
			
			if isDirectory {
				if name == "_extras" {
					enumerator.skipDescendants()
				}
			} else {
				urls.append(url)
			}
		}
		return urls
		
	}
		
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		// Retrieve last selected url
		if let folder = NSUserDefaults.standardUserDefaults().valueForKey("folder") as? String {
			self.url = NSURL(fileURLWithPath: folder, isDirectory: true)
			folderLabel.stringValue = folder
		}
		
		slider.doubleValue = 0.0
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

