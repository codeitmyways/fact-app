//
//  URLImageView.swift
//  Fact-App
//
//  Created by Sumit meena on 25/02/21.
//

import UIKit

protocol URLImageViewInput {
    var url: String! { get set }
    var placeholder: UIImage! { get set }
}

class URLImageView:RoundedImageView, URLImageViewInput {
    var url: String!


    var placeholder: UIImage!

    typealias CompletionHandler = (_ success: Bool) -> Void
    typealias CompletionHandlerImage = (_ success: UIImage) -> Void

    private lazy var cacheDir: String = {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }()
    private static let imageCache = NSCache<NSString, UIImage>()
    private static var tasks: [URL: DispatchSemaphore] = [:]
    private static var queue = DispatchQueue(label: "URLImageView", attributes: .concurrent)

    func setImageWithURL(urlString: String?, completion: @escaping CompletionHandler) {
//        self.image = nil
        if let urlValue = urlString {
            self.url = urlValue
            self.load(from: urlValue, completion: completion)
        }
    }
    private func load(from url: String, completion: @escaping CompletionHandler) {
        guard let url = URL(string: url) else { return }
        
        if(!UIApplication.shared.canOpenURL(url)) {
            return
        }

        let fileName: NSString = "\(url.host!)_\(url.path.replacingOccurrences(of: "/", with: "_"))" as NSString
        let fullPath = URL(fileURLWithPath: "\(self.cacheDir)/\(fileName)")

        if let placeholders = URLImageView.imageCache.object(forKey: fileName) {
            self.image = image
            completion(true)
            return
        }

        DispatchQueue.global().async {
            if let semaphore = URLImageView.tasks[url] {
                semaphore.wait()

                if let image = URLImageView.imageCache.object(forKey: fileName) {
                    self.reload(image: image, for: url)
                }

                semaphore.signal()
                completion(true)
                return
            }

            URLImageView.queue.async(flags: .barrier) {
                URLImageView.tasks[url] = DispatchSemaphore(value: 0)
            }

           if let image = self.readLocal(fullPath){
            URLImageView.imageCache.setObject(image, forKey: fileName)
            self.reload(image: image, for: url)
            URLImageView.queue.async(flags: .barrier) {
                let semaphore = URLImageView.tasks[url]
                URLImageView.tasks[url] = nil
                semaphore?.signal()
                completion(true)
                
            }
            
           } else{
            self.readRemote(url, fullPath) { (image) in

                URLImageView.imageCache.setObject(image, forKey: fileName)
                self.reload(image: image, for: url)
                URLImageView.queue.async(flags: .barrier) {
                    let semaphore = URLImageView.tasks[url]
                    URLImageView.tasks[url] = nil
                    semaphore?.signal()
                    completion(true)
                    
                }
                
            }
            }// self.readRemote(url, fullPath)

           
        }
    }

    private func reload(image: UIImage, for url: URL) {
        DispatchQueue.main.async {
            if let currentUrl = self.url, url == URL(string: currentUrl) { // check actual url
                UIView.transition(with: self,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.image = image
                }, completion: nil)
            }
        }
    }

    private func readLocal(_ path: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: path) else { return nil }
        guard let image = UIImage(data: data) else {
            try? FileManager.default.removeItem(at: path) // broken image saved
            return nil
        }

        return image
    }

    private func readRemote(_ url: URL, _ path: URL,completationHandlerImage:@escaping CompletionHandlerImage){
       
        URLSession.shared.dataTask(with: url) { (data, request, error) in
            if let data = data {
                if let image = UIImage(data: data){
                    do {
                        try data.write(to: path)

                    } catch {
                        try? FileManager.default.removeItem(at: path) // broken image saved, low space

                    }
                    completationHandlerImage(image)
                }

            }
        }.resume()


//        do {
//            try data.write(to: path)
//        } catch {
//            try? FileManager.default.removeItem(at: path) // broken image saved, low space
//        }
//
//        return image
    }
}
@IBDesignable class RoundedImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.updateUI()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.updateUI()
        }
    }

    override var image: UIImage? {
        didSet {
            if image != nil {
                self.avtarView?.removeFromSuperview()
            }
        }
    }
    var statusView: UIView?
    private var statusViewHeight: CGFloat = 10
    var avtarView: UILabel?
    func updateUI() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.masksToBounds = true
        
    }
   
    
    private func updateFrame() {
        if let view = self.statusView {
            var rect = view.frame
            rect.origin = CGPoint(x: self.frame.maxX - rect.height - 2, y: self.frame.maxY - rect.width - 2)
            view.frame = rect
            view.layer.cornerRadius = rect.width / 2
            view.layer.masksToBounds = true
        }
        if let view = self.avtarView {
            view.frame = self.bounds
            view.layer.cornerRadius = self.layer.cornerRadius
            view.layer.masksToBounds = self.layer.masksToBounds
        }
    }
    override func layoutSubviews() {
        self.updateFrame()
    }
    func setAvtar(string: String?) {
        if let avtar = string {
            if avtarView == nil {
                self.addSubview(self.avtarView!)
                self.superview?.bringSubviewToFront(self)
            }
            self.avtarView?.text = avtar
        } else {
            self.avtarView?.removeFromSuperview()
            self.avtarView = nil
        }
    }
}
