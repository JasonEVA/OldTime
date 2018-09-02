//
//  CalendarTextFieldTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarTextFieldTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"


@interface CalendarTextFieldTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) void(^textBlock)(NSString *);

@end

@implementation CalendarTextFieldTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            NSInteger s;
            if ([[UIScreen mainScreen] scale] == 3)
            {
                s = 18;
            }
            else
            {
                s = 15;
            }
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, s, 0, 15));
        }];
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interface Method
- (void)textEndEditingBlock:(void (^)(NSString *))textBlock {
    self.textBlock = textBlock;
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textBlock) {
        self.textBlock(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark - Notification
- (void)textFieldTextDidChange:(NSNotification *)notifcation {
	UITextField *textfiled = (UITextField *)notifcation.object;
	NSString *text = [textfiled.text stringByRemovingEmoji];
	if (![text isEqualToString:textfiled.text]) {
		textfiled.text = text;
	}
	
}

#pragma mark - Getter
- (NSString *)cellText {
    return self.textField.text;
}

- (void)setTitle:(NSString *)titile {
    self.textField.text = titile;
}

#pragma mark - Initializer
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor blackColor];
        _textField.placeholder = LOCAL(CALENDAR_ADD_TITLE);
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_textField];
    }
    return _textField;
}
@end
