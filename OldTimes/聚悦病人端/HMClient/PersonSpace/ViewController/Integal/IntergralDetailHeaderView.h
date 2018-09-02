//
//  IntergralDetailHeaderView.h
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntergralDetailChooseControl: UIControl
- (void) setTitle:(NSString*) title;
@end

@interface IntergralDetailHeaderView : UIView

@property (nonatomic, strong) IntergralDetailChooseControl* chooseControl;
@end
