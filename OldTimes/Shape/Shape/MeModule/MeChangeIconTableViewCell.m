//
//  MeChangeIconTableViewCell.m
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeChangeIconTableViewCell.h"
#import <Masonry.h>
#import "UIColor+Hex.h"


@interface MeChangeIconTableViewCell()


@end

@implementation MeChangeIconTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor themeBackground_373737]];
        [self.textLabel setText:@"修改头像"];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        [self.contentView addSubview:self.myImageView];
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.myImageView.mas_height);
            make.right.equalTo(self).offset(-35);
            make.top.equalTo(self).offset(13);
            make.bottom.equalTo(self).offset(-13);
        }];
    }
    
    return  self;
}

- (void)setImageView:(UIImage *)image
{
    [self.myImageView setImage:image];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init UI

- (UIImageView *)myImageView
{
    
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_icon"]];
        _myImageView.layer.cornerRadius = 31;
        [_myImageView setClipsToBounds:YES];
    }
    return _myImageView;
}


@end
