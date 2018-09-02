//
//  TaskOnlyTextFieldTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskOnlyTextFieldTableViewCell.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"
@implementation TaskOnlyTextFieldTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.texfFieldTitle];
        [self.texfFieldTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma marl - notificationDelegate
//禁用Emoji表情
 - (void)textViewDidChange:(NSNotification *)noti
{
    UITextField *textfiled = (UITextField *)noti.object;
	NSString *text = [textfiled.text stringByRemovingEmoji];
    if (![text isEqualToString:textfiled.text]) {
        textfiled.text = text;
    }
}

#pragma mark - setterAndGetter


- (UITextField *)texfFieldTitle
{
    if (!_texfFieldTitle)
    {
        _texfFieldTitle = [[UITextField alloc] init];
        _texfFieldTitle.returnKeyType = UIReturnKeyDone;
        _texfFieldTitle.font = [UIFont systemFontOfSize:14];
        _texfFieldTitle.placeholder = LOCAL(TITLE);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:nil object:_texfFieldTitle];
    }
    return _texfFieldTitle;
}

@end
