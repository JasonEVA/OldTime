//
//  NewApplyDetailTableViewCell.m
//  launcher
//
//  Created by Dee on 16/8/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDetailTableViewCell.h"
#import "UIFont+Util.h"
#import <Masonry.h>
@implementation NewApplyDetailTableViewCell
+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.applyDetailLabel];
        [self.applyDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.left.greaterThanOrEqualTo(self.contentView).offset(80);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}


#pragma mark - setterAndGetter
- (UILabel *)applyDetailLabel
{
    if (!_applyDetailLabel) {
        _applyDetailLabel = [[UILabel alloc] init];
        _applyDetailLabel.font = [UIFont mtc_font_30];
        _applyDetailLabel.textColor = [UIColor blackColor];
    }
    return _applyDetailLabel;
}
@end
