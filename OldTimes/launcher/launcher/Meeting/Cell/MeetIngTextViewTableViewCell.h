//
//  MeetIngTextViewTableViewCell.h
//  launcher
//
//  Created by Conan Ma on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetIngTextViewTableViewCell : UITableViewCell

@property (nonatomic, readonly) UITextView *textView;

+ (NSString *)identifier;

- (void)setContent:(NSString *)content;

@end
