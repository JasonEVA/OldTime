//
//  NewSiteLeftIconImageView.h
//  HMClient
//
//  Created by jasonwang on 2016/11/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信左侧带未读数icon

#import <UIKit/UIKit.h>

@interface NewSiteLeftIconImageView : UIView
- (void)fillinImage:(UIImage *)image unreadCount:(NSInteger)unreadCount;
@end
