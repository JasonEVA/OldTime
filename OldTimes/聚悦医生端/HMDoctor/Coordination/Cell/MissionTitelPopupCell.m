//
//  MissionTitelPopupCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionTitelPopupCell.h"
#import "UIFont+Util.h"

@implementation MissionTitelPopupCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}


#pragma mark - Initializer


- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont font_28];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    }
    return _lblTitle;
}

@end
