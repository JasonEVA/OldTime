//
//  MeMtSideDetailCell.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeMySideDetailCell.h"
#import <Masonry.h>


@interface MeMySideDetailCell()<MyToolBarDelegate>
@property (nonatomic, copy) NSString *content;
@end
@implementation MeMySideDetailCell
- (instancetype)initWithUnit:(NSString *)unit reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.unitLb setText:unit];
        [self.contentView addSubview:self.unitLb];
        self.txtFd = [UITextField new];
        [self.txtFd setTextColor:[UIColor whiteColor]];
        [self.txtFd setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.txtFd];
        [self.txtFd setKeyboardType:UIKeyboardTypeDecimalPad];
        [self.txtFd setInputAccessoryView:self.toolBar];
        if ([unit isEqualToString:@""]) {
            
            [self.txtFd mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.textLabel.mas_right).offset(10);
                make.right.equalTo(self).offset(-15);
                make.height.centerY.equalTo(self.contentView);
            }];
            
        } else {
            [self.txtFd mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.textLabel.mas_right).offset(10);
                make.right.equalTo(self).offset(-35);
                make.height.centerY.equalTo(self.contentView);
            }];
            [self.unitLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.txtFd.mas_right).offset(5);
                make.bottom.equalTo(self.textLabel);
            }];

        }
        
    }
    return self;
}
- (void)setDateInputView
{
    [self.txtFd setInputView:self.birthdayPickView];
}

- (void)dateChange:(UIDatePicker *)pickView
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate:pickView.date];
    [self.txtFd setText:currentDateStr];
}
#pragma mark - MytoolBar Delegate

- (void)MyToolBarDelegateCallBack_SaveClick
{
    [self.txtFd resignFirstResponder];
}

- (void)MyToolBarDelegateCallBack_CancelClick
{
    [self.txtFd resignFirstResponder];

}
- (UILabel *)unitLb
{
    if (!_unitLb) {
        _unitLb = [[UILabel alloc] init];
        [_unitLb setTextColor:[UIColor whiteColor]];
    }
    return _unitLb;
}

- (UIDatePicker *)birthdayPickView
{
    if (!_birthdayPickView) {
        _birthdayPickView = [[UIDatePicker alloc] init];
        [_birthdayPickView setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        [_birthdayPickView setBackgroundColor:[UIColor whiteColor]];
        [_birthdayPickView setDatePickerMode:UIDatePickerModeDate];
        [_birthdayPickView setMaximumDate:[NSDate date]];
        [_birthdayPickView addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    }
    return _birthdayPickView;
}

- (MyToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[MyToolBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        [_toolBar setMyDelegate:self];
        [_toolBar setMyTitel:@""];
    }
    return _toolBar;}

- (NSString *)content
{
    if (!_content) {
        _content = [[NSString alloc] init];
    }
    return _content;
}
@end
