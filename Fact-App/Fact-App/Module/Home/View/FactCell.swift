//
//  FactCell.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import UIKit

class FactCell: UITableViewCell {
   
    var lblTitle : UILabel = {
        let lblTitle = UILabel()
        lblTitle.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        return lblTitle
    }()
     let lblDescription : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let imgView : URLImageView = {
        let imageView = URLImageView(frame: CGRect(x: 0,y: 0,width: 40,height: 40))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "person.circle.fill")
        }
        return imageView
    }()

    public var fact : Fact!{
        didSet{
            self.lblTitle.text = fact.title
            self.lblDescription.text = fact.description
            if #available(iOS 13.0, *) {
                imgView.placeholder = UIImage(systemName: "person.circle.fill")
            }
            imgView.setImageWithURL(urlString: fact.imageHref) { (isComplete) in
            }
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        lblTitle.text = "Hello"
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblDescription)
//        contentView.addSubview(imgView)
        contentView.addSubview(imgView)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.text = "Hello"
//        self.addSubview(lblDescription)
//        self.addSubview(imgView)
        // Initialization code
//        setupConstraints()
//        self.addSubview(lblTitle)
    }
    private func setupConstraints(){
//        self.lblTitle.anchor(top:topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 30, height: 30, enableInsets: true)
//        lblTitle.leadingAnchor

        let marginGuide = contentView.layoutMarginsGuide

        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        lblTitle.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive  = true
        lblTitle.numberOfLines = 0
        
        imgView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 40).isActive  = true
        imgView.widthAnchor.constraint(equalToConstant: 40).isActive  = true



        
        lblDescription.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        lblDescription.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive  = true
        lblDescription.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive = true
        lblDescription.numberOfLines = 0
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class PentagonView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let h = size.height * 0.85      // adjust the multiplier to taste

        // calculate the 5 points of the pentagon
        let p1 = self.bounds.origin
        let p2 = CGPoint(x:p1.x + size.width, y:p1.y)
        let p3 = CGPoint(x:p2.x, y:p2.y + h)
        let p4 = CGPoint(x:size.width/2, y:size.height)
        let p5 = CGPoint(x:p1.x, y:h)

        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.addLine(to: p5)
        path.close()

        // fill the path
        UIColor.red.set()
        path.fill()
    }
}
