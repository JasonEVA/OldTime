//
//  HMHistoryCollectTextTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMHistoryCollectTextTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface HMHistoryCollectTextTableViewCell ()
@property (nonatomic, strong) UILabel *textLb;         //文本

@end
@implementation HMHistoryCollectTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLb];
        [self configElements];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -private method
- (void)configElements {
    [self.textLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(15);
        make.left.equalTo(self.iconView);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)setDataWithModel:(MessageBaseModel *)model {
    [self setBaseDataWithModel:model];
    [self.textLb setText:model._content];
    [self configElements];
    
}
#pragma mark - init UI
- (UILabel *)textLb {
    if (!_textLb) {
        _textLb = [UILabel new];
        [_textLb setFont:[UIFont font_32]];
        [_textLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_textLb setText:@"fsdfsdfsdfsdf"];
        [_textLb setNumberOfLines:0];
        
    }
    return _textLb;
}

@end
