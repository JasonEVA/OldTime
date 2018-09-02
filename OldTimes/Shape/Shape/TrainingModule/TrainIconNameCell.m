//
//  TrainIconNameCell.m
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainIconNameCell.h"
#import "MyDefine.h"
#import <Masonry.h>

@implementation TrainIconNameCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.myImageView];
        [self addSubview:self.nameLb];
        
        [self.myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(self.myImageView.mas_width);
            make.left.equalTo(self.mas_left).offset(16);
        }];
        [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myImageView.mas_right).offset(10);
            make.centerY.equalTo(self.myImageView);
        }];
    }
    return self;
}

- (void)setMyData:(TrainGetDayTrainInfoModel *)model
{
    [self.nameLb setText:model.supplierName];
    //头像无url
}

- (UIImageView *)myImageView
{
    
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc]init];
        [_myImageView setImage:[UIImage imageNamed:@"me_icon"]];
        _myImageView.layer.cornerRadius = _myImageView.frame.size.height / 2;
        [_myImageView setClipsToBounds:YES];
    }
    return _myImageView;
}

- (UILabel *)nameLb
{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        [_nameLb setText:@"Shape官方"];
        [_nameLb setTextColor:[UIColor whiteColor]];
        _nameLb.font = [UIFont systemFontOfSize:16];
    }
    return _nameLb;
}

@end
