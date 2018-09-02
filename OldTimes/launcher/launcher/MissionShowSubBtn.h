//
//  MissionShowSubBtn.h
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionShowSubBtn : UIButton

@property(nonatomic, assign) BOOL  isShow;

- (void)setCountWithStr:(NSString *)str;

@end
