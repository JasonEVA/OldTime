//
//  PersonServiceComPlainContentTableViewCell.m
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServiceComPlainContentTableViewCell.h"


@interface PersonServiceComPlainContentTableViewCell ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView  *textview;

@property(nonatomic, strong) UILabel  *placeHodlerLabel;

@property(nonatomic, copy) getContentCallBackBlock myBlock;


@end

@implementation PersonServiceComPlainContentTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark -- interafacetMethod
- (void)getContentWithBlock:(getContentCallBackBlock)block
{
    self.myBlock = block;
}

#pragma mark -- uitextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHodlerLabel.hidden = self.textview.text.length;
    if (self.myBlock) {
        self.myBlock(textView.text);
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma makr -- privataMethod

- (void)createFrame
{
    [self.contentView addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@115);
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.contentView addSubview:self.placeHodlerLabel];
    [self.placeHodlerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.textview).offset(15);
        make.right.equalTo(self.textview).offset(-15);
        make.bottom.lessThanOrEqualTo(self.textview);
    }];
}

#pragma mark -- setterAndGetter
- (UILabel *)placeHodlerLabel
{
    if (!_placeHodlerLabel)
    {
        _placeHodlerLabel = [[UILabel alloc] init];
        _placeHodlerLabel.textColor = [UIColor commonGrayTextColor];
        _placeHodlerLabel.text = @"点击添加下方的标签，也可点击本区域输入内容。一个月只能评价一次哦，请认真评价~";
        [_placeHodlerLabel setFont:[UIFont systemFontOfSize:15]];
        [_placeHodlerLabel setNumberOfLines:0];
    }
    return _placeHodlerLabel;
}

- (UITextView *)textview
{
    if (!_textview)
    {
        _textview = [[UITextView alloc] init];
        _textview.delegate = self;
        _textview.textContainerInset = UIEdgeInsetsMake(12, 12, 0, 12);
        [_textview setFont:[UIFont font_30]];
        [_textview.layer setCornerRadius:7.5];
        [_textview.layer setBorderColor:[[UIColor colorWithHexString:@"dddddd"] CGColor]];
        [_textview.layer setBorderWidth:0.5];
        
//        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//        [topView setBarStyle:UIBarStyleBlack];
//        
//        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleDone target:self action:nil];
//        
//        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        
//        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//        
//        
//        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
//        
//        [topView setItems:buttonsArray];
//        [_textview setInputAccessoryView:topView];
    }
    return _textview;
}


@end
