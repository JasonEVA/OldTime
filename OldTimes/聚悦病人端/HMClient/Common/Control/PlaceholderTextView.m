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

- (id) init
{
    self = [super init];
    if (self)
    {
        lbPlaceholder = [[UILabel alloc] init];
        [self addSubview:lbPlaceholder];
        [lbPlaceholder setNumberOfLines:0];
        
        //[lbPlaceholder setHidden:YES];
        [lbPlaceholder setBackgroundColor:[UIColor clearColor]];
        [lbPlaceholder setTextColor:[UIColor colorWithHexString:@"B1B1B1"]];
        [lbPlaceholder setFont:self.font];
        
        
        [lbPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.right.equalTo(self).with.offset(-8);
            make.left.and.top.equalTo(self).with.offset(8);
            make.width.equalTo(self).with.offset(-16);
            //make.right.equalTo(self).with.offset(-8);
            make.bottom.equalTo(self).with.offset(-8);
        }];
      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];       
    }
    return self;
}



- (void) setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (lbPlaceholder)
    {
        [lbPlaceholder setFont:self.font];
        [lbPlaceholder setText:placeholder];

      
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
