//
//  NewApplyTitleTextViewCell.m
//  launcher
//
//  Created by Dee on 16/8/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyTitleTextViewCell.h"
#import <Masonry.h>
#import "NSString+HandleEmoji.h"
#import "NewApplyFormBaseModel.h"

//@interface new : <#superclass#>
//
//@end

@implementation NewApplyTitleTextViewCell

//+ (NSString *)identifier
//{
//    return NSStringFromClass([self class]);
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//        
////        [self initComponent];
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//
//#pragma mark - uitextFieldDelegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//    //禁用表情
//    NSString *text = [NSString disable_EmojiString:textView.text];
//    if (![text isEqualToString:textView.text]) {
//        textView.text = text;
//    }
//    self.model.try_inputDetail = textView.text;
//    self.placeHolederLabel.hidden = textView.text.length;
//}
//
//#pragma mark - UIKeyBoardNotification
//
//- (void)keyboardWillShow:(NSNotification *)noti
//{
//    NSDictionary *dict = noti.userInfo;
//    CGRect endRect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect convertRect = [self.contentView convertRect:self.textView.frame  toView:self.tableView.superview];
//    NSLog(@"X:%f - Y:%f",convertRect.origin.x,convertRect.origin.y);
//}
//
//- (void)keyboardWillHide:(NSNotification *)noti
//{
//    NSLog(@"notiForHide:%@",noti);
//}
//
//#pragma mark - privetaMethod
//- (void)initComponent
//{
//    [self.contentView addSubview:self.textView];
//    [self.contentView addSubview:self.placeHolederLabel];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 15));
//    }];
//    
//    [self.placeHolederLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.textView).offset(7);
//        make.left.equalTo(self.textView).offset(5);
//    }];
//}
//
//
//#pragma mark - setterAndGetter
//
//- (UITableView *)tableView
//{
//    
//    UIView *tableView = self.superview;
//    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
//        tableView = tableView.superview;
//    }
//    return (UITableView *)tableView;
//}
//
//
//- (UITextView *)textView
//{
//    if (!_textView) {
//        _textView = [[UITextView alloc] init];
//        _textView.font = [UIFont systemFontOfSize:15];
//        _textView.delegate = self;
//    }
//    return _textView;
//}
//
//- (UILabel *)placeHolederLabel
//{
//    if (!_placeHolederLabel) {
//        _placeHolederLabel = [[UILabel alloc] init];
//        _placeHolederLabel.textColor = [UIColor lightGrayColor];
//        _placeHolederLabel.userInteractionEnabled = YES;
//        _placeHolederLabel.font = [UIFont systemFontOfSize:15];
//    }
//    return _placeHolederLabel;
//}



@end
