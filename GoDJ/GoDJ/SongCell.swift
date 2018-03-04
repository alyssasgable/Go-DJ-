import UIKit

class SongCell: UITableViewCell {
    
    
    var songLabel: UILabel = {
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.sizeToFit()
        return $0
    }(UILabel())

	var imageItem = UIImageView()
    var cardView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(cardView)
		self.contentView.addSubview(songLabel)
        
        setupCell()
		imageItem.image = UIImage(named: "")
    }
    
    func setupCell() {
        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        
        
        cardView.snp.remakeConstraints { (make) in
            make.top.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        songLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
