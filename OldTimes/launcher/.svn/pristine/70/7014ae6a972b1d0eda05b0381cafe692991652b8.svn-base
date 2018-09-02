//
//  MeSuggestEditTitleTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeSuggestEditTitleTableViewCell.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "MyDefine.h"

@interface MeSuggestEditTitleTableViewCell ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField  *textFld;

@end

@implementation MeSuggestEditTitleTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.textFld];
        [self createFrame];
    }
    return self;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFld endEditing:YES];
    return YES;
}

#pragma mark - SetterAndGetter
- (void)createFrame
{
    [self.textFld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
}

- (UITextField *)textFld
{
    if (!_textFld)
    {
        _textFld = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textFld.delegate = self;
        _textFld.placeholder = LOCAL(ME_INPUT_BACKSUGGEST);
    }
    return _textFld;
}

@end
