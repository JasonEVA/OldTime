//
//  HMSelectPatientGroupHeaderView.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HMAllSelectBottonClick)();

@interface HMSelectPatientGroupHeaderView : UIControl
- (void)setGroupName:(NSString *)name;
- (void)setIsExpanded:(BOOL)isExpanded;
- (void)fillCount:(NSString *)count;
- (void)setIsSelected:(BOOL)selected;

- (void)allSelectBottonClick:(HMAllSelectBottonClick)click;

@end
