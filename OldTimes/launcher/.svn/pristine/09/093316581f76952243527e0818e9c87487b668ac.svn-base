//
//  MeTextFieldTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeTextFieldTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "NSString+HandleEmoji.h"

@implementation MeTextFieldTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.tfdOriginal];
        [self CreateFrames];
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}
- (void)awakeFromNib {
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)CreateFrames
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@25);
    }];
    
    [self.tfdOriginal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@25);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
}

- (void)setTfdaligent:(aligent)aligent
{
    if (aligent == aligent_left)
    {
        self.tfdOriginal.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        self.tfdOriginal.textAlignment = NSTextAlignmentRight;
    }
}

#pragma mark - Notification
- (void)textFieldTextDidChange:(NSNotification *)notifcation {
	UITextField *textfiled = (UITextField *)notifcation.object;
	NSString *text = [textfiled.text stringByRemovingEmoji];
	if (![text isEqualToString:textfiled.text]) {
		textfiled.text = text;
	}
	
}

#pragma mark - Initializer
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont mtc_font_30];
        [_lblTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lblTitle;
}

- (UITextField *)tfdOriginal
{
    if (!_tfdOriginal)
    {
        _tfdOriginal = [[UITextField alloc] init];
        _tfdOriginal.textAlignment = NSTextAlignmentLeft;
        _tfdOriginal.font = [UIFont mtc_font_30];
        _tfdOriginal.returnKeyType = UIReturnKeyDone;
        _tfdOriginal.clearButtonMode = YES;
        _tfdOriginal.textColor = [UIColor blackColor];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_tfdOriginal];
    }
    return _tfdOriginal;
}

@end
