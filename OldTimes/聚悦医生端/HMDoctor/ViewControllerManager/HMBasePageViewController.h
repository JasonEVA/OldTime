//
//  HMBasePageViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMBasePageViewController : UIViewController
{
    
}

@property (nonatomic, retain) NSString* controllerId;
@property (nonatomic, retain) id paramObject;

- (id) initWithControllerId:(NSString*) aControllerId;
@end
