//
//  PersonSpaceNavigationView.h
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSpaceNavigationView : UIView
{
    
}
@property (nonatomic, strong) UIImageView* ivPartrait;    //头像
- (void) setStaffInfo;
- (void) setStaffAuthentication:(NSString*) authent;

@end
