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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.contentView.addSubview(songLabel)
		songLabel.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		imageItem.image = UIImage(named: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
