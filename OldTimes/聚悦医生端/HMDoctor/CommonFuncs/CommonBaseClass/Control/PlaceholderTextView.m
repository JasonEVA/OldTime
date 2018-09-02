//
//  PlaceholderTextView.m
//  ZJKPatient
//
//  Created by yinqaun on 15/7/13.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "ZJKViewInc.h"

@interface PlaceholderTextView ()
{
    UILabel* lbPlaceholder;
    
}
@end

@implementation PlaceholderTextView

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(0,8,self.bounds.size.width - 16,16)];
        [self addSubview:lbPlaceholder];
        //[lbPlaceholder setHidden:YES];
        [lbPlaceholder setBackgroundColor:[UIColor clearColor]];
        [lbPlaceholder setTextColor:[UIColor colorWithHexString:@"999999"]];
        [lbPlaceholder setFont:self.font];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        [lbPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(8);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).with.offset(-8);
        }];
    }
    return self;
}

- (void) setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (lbPlaceholder)
    {
        [lbPlaceholder setFont:[UIFont font_30]];
        [lbPlaceholder setText:placeholder];
        float textHeight = [lbPlaceholder.text heightSystemFont:lbPlaceholder.font width:self.width - 16];
        if (textHeight > 16)
        {
            //需要换行
            [lbPlaceholder setHeight:textHeight + 3];
            [lbPlaceholder setNumberOfLines:0];
        }
    }
}

- (void) setText:(NSString *)text
{
    [super setText:text];
    BOOL showPlaceholder = (self.text.length == 0);
    if (lbPlaceholder)
    {
        [lbPlaceholder setHidden:!showPlaceholder];
    }
}

- (void)textChanged:(NSNotification *)notification
{
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    BOOL showPlaceholder = (self.text.length == 0);
    if (lbPlaceholder)
    {
        [lbPlaceholder setHidden:!showPlaceholder];
    }
}




@end
