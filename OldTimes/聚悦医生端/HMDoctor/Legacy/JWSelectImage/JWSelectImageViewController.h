//
//  JWSelectImageViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSelectImageEditView.h"

@interface JWSelectImageViewController : UIViewController
@property (nonatomic, strong) HMSelectImageEditView *selectImageView;
- (instancetype)initWithMaxSelectedCount:(NSInteger)maxCount;
@end
