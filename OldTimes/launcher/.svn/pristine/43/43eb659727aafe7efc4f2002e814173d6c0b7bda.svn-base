//
//  NewApplyTextViewCell.m
//  launcher
//
//  Created by Dee on 16/8/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyTextViewCell.h"
#import <Masonry.h>
#import "NSString+HandleEmoji.h"
#import "NewApplyFormBaseModel.h"
@interface NewApplyTextViewCell ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView  *textView;

@property(nonatomic, strong)  UILabel *placeHolederLabel;

@property(nonatomic, strong) NewApplyFormBaseModel  *model;

@property(nonatomic, strong) UITableView  *tableView;

@property(nonatomic, copy) textViewLocaionCallBack  myBlock;

@end

@implementation NewApplyTextViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        static dispatch_once_t onceToken;

        [self initComponent];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - uitextFieldDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //禁用表情
    NSString *text = [NSString disable_EmojiString:textView.text];
    if (![text isEqualToString:textView.text]) {
        textView.text = text;
    }
    //限制字符
    if (text.length >= 500) {
        textView.text = [text substringWithRange:NSMakeRange(0, 500)];
    }
    
    self.model.try_inputDetail = textView.text;
    self.placeHolederLabel.hidden = textView.text.length;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //存放当前的位置
    CGRect convertRect = [self.contentView convertRect:self.textView.bounds  toView:nil];
    CGRect temprect = CGRectMake(convertRect.origin.x, convertRect.origin.y, self.textView.frame.size.width, self.textView.frame.size.height);
    if (self.myBlock) {
        self.myBlock(temprect);
    }
    return YES;
}


#pragma mark - interFaceMethod
- (void)setDataWithModel:(NewApplyFormBaseModel *)model
{
    self.model = model;
    if ([model.labelText isEqualToString:@"备注"]) {
        self.placeHolederLabel.text = self.model.labelText;
    }else{
        self.placeHolederLabel.text = [(id)model placeholder];
    }
    self.textView.text = self.model.try_inputDetail;
    self.placeHolederLabel.hidden = self.textView.text.length;
}

- (void)getLocationWithBlock:(textViewLocaionCallBack)block
{
    self.myBlock = block;
}

#pragma mark - privetaMethod
- (void)initComponent
{
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.placeHolederLabel];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 15));
    }];
    
    [self.placeHolederLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(7);
        make.left.equalTo(self.textView).offset(5);
    }];
}

#pragma mark - setterAndGetter

- (UITableView *)tableView
{
    
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeHolederLabel
{
    if (!_placeHolederLabel) {
        _placeHolederLabel = [[UILabel alloc] init];
        _placeHolederLabel.textColor = [UIColor lightGrayColor];
        _placeHolederLabel.userInteractionEnabled = YES;
        _placeHolederLabel.font = [UIFont systemFontOfSize:15];
    }
    return _placeHolederLabel;
}



@end
