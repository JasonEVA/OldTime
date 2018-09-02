//
//  ApplicationRemainTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationRemainTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"

@interface ApplicationRemainTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ApplicationRemainTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Interface Method
- (void)hasRemain:(BOOL)remain {
    self.userInteractionEnabled = remain;
    self.titleLabel.text = LOCAL((remain ? APPLY_GETNEW_COMMENTS : APPLY_NOMORE_COMMENTS));
}

#pragma mark - Initializer
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:LOCAL(APPLY_GETNEW_COMMENTS)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    }
    return _titleLabel;
}

@end
