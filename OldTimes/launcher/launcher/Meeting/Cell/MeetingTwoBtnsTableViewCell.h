//
//  MeetingTwoBtnsTableViewCell.h
//  launcher
//
//  Created by Conan Ma on 15/8/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingTwoBtnsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UIButton *btnShare;

+(NSString*)identifier;

@end
