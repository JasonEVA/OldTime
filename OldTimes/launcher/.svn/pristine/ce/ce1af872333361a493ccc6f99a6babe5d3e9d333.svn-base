//
//  NewApplyDetailTitleTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDetailTitleTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "UIView+Util.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIImage+Manager.h"

//typedef enum
//{
//    UNACCEPT = 0,       // 不被接受
//    ACCEPT,             // 接受
//    CANCLED,            // 驳回
//    DEALING,            // 进行中
//    ACCEPTADNTRANSFER   // 待审批
//} APPLYEVENTSTATE;       // 请求事件状态

@interface NewApplyDetailTitleTableViewCell()
@property (nonatomic, strong) UILabel *lblTitle;
//@property (nonatomic , strong)  UIButton *stateBtn;
@end

@implementation NewApplyDetailTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblTitle];
//        [self.contentView addSubview:self.stateBtn];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setframes];
    }
    return self;
}

- (void)setframes
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.contentView).offset(-13);
    }];
    
//    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(12.5);
//        make.right.equalTo(self.contentView).offset(-12.5);
//        make.width.equalTo(@55);
//        make.height.equalTo(@20);
//    }];
}

- (void)setCCCellWithModel:(ApplyDetailInformationModel *)model {
    [self setTitle:model.A_TITLE];
}

- (void)setTitle:(NSString *)title {
    self.lblTitle.text = title;
}

- (CGFloat)getheight
{
    CGSize size = [self.lblTitle.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 26,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblTitle.font} context:NULL].size;
    if (size.height + 10 > 45)
    {
        return size.height + 12;
    }
    else
    {
        return 45;
    }
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.numberOfLines = 0;
        [_lblTitle setFont:[UIFont systemFontOfSize:15]];
        [_lblTitle setTextColor:[UIColor blackColor]];
        [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblTitle;
}
@end
