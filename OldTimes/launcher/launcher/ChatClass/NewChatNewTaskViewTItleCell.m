//
//  NewChatNewTaskViewTItleCell.m
//  launcher
//
//  Created by Dee on 16/7/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewChatNewTaskViewTItleCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"
@interface NewChatNewTaskViewTItleCell ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField  *titleField;

@property(nonatomic, copy) getTitleTextCallBack myBlcok;

@end


@implementation NewChatNewTaskViewTItleCell
+ (NSString *)identifier
{
  return  NSStringFromClass([self class]);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFrame];
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - interfaceMethod

- (void)setTitle:(NSString *)title
{
    self.titleField.text = title;
}

- (void)getTextWithBlock:(getTitleTextCallBack)block
{
    self.myBlcok = block;
}

- (void)setEndEditing
{
    [self textFieldDidEndEditing:self.titleField];
}

#pragma mark - privateMethod
- (void)createFrame
{
    [self.contentView addSubview:self.titleField];
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.top.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - uitextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.myBlcok) {
        self.myBlcok(textField.text);
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

#pragma mark - setterAndGetter
- (UITextField *)titleField
{
    if (!_titleField)
    {
        _titleField = [[UITextField alloc] init];
        _titleField.placeholder = LOCAL(MISSION_FOR_TASK_TITL);//@"任务标题";
        [_titleField setTextColor:[UIColor blackColor]];
        [_titleField setBackgroundColor:[UIColor whiteColor]];
        [_titleField setFont:[UIFont systemFontOfSize:15]];
        [_titleField setDelegate:self];
        _titleField.returnKeyType = UIReturnKeyDone;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_titleField];
		
    }
    return _titleField;
}
@end
