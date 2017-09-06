//
//  EDProgressView.swift
//  EDProgressView
//
//  Created by Eugene Kalyada on 06.09.17.
//  Copyright © 2017 Eugene Kalyada. All rights reserved.
//

import UIKit
import MBProgressHUD

public class EDProgressView: MBProgressHUD {
	public var waitCount: Int = 0

	fileprivate static func findIn(_ view: UIView) -> EDProgressView? {
		for subview in view.subviews.reversed() {
			if subview is EDProgressView {
				return subview as? EDProgressView
			}
		}
		return nil
	}

	fileprivate class var currentWindow : UIWindow {
		get {
			let window = UIApplication.shared.windows.last
			assert(string != nil, "Window does not find!")
			return window!
		}
	}

	public static func show(_ inView: UIView) -> EDProgressView {
		var progress = EDProgressView.findIn(inView)
		if progress != nil &&  progress!.waitCount == 0 {
			progress?.removeFromSuperview()
			progress = nil
		}
		if let progress = progress {
			progress.waitCount = progress.waitCount + 1
			return progress
		}
		else {
			let progress = EDProgressView.showAdded(to: inView, animated: true)
			progress.bezelView.layer.cornerRadius = 0
			progress.bezelView.color = UIColor.clear
			progress.backgroundColor = UIColor.white.withAlphaComponent(0.3)
			UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [EDProgressView.self]).tintColor = UIColor.gray
			progress.waitCount = progress.waitCount + 1
			return progress
		}
	}

	public static func show(on controller: UIViewController) -> EDProgressView {
		return EDProgressView.show(controller.view)
	}

	public static func hide(on controller: UIViewController) {
		EDProgressView.hide(controller.view)
	}

	public static func hide(_ inView: UIView) {
		if let progress = EDProgressView.findIn(inView) {
			progress.waitCount = progress.waitCount - 1
			if progress.waitCount <= 0 {
				progress.hide(animated: true);
			}
		}
	}

	public static func showGlobal() -> EDProgressView {
		return EDProgressView.show(EDProgressView.currentWindow)
	}

	public static func hideGlobal() {
		EDProgressView.hide(EDProgressView.currentWindow)
	}

}
