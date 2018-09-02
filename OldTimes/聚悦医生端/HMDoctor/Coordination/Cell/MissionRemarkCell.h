//
//  MissionRemarkCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/5/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionRemarkCell : UITableViewCell
@property (nonatomic, strong) UITextView *textView;

- (void)hidePlaceholder:(BOOL)hide;
@end
