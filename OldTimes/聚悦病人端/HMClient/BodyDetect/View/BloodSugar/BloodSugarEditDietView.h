//
//  BloodSugarEditDietView.h
//  HMClient
//
//  Created by lkl on 2017/7/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface BloodSugarEditDietView : UIView

@property (nonatomic, readonly) UITextView* tvSymptom;
@property (nonatomic, readonly) PlaceholderTextView* tv;
@property (nonatomic, strong) UIButton *btnAddPhoto;          //添加照片按钮
@property (nonatomic, strong) NSMutableArray *phonelist;      //图片数组
@property (nonatomic, strong) UIButton* commitButton;
@property (nonatomic, strong) UIButton* deleteButton;
-(void)resetLayout;

- (void)isHasPhotosOrDiet:(BOOL)isHas;

- (void)reloadPhotos:(NSArray *)photos;
@end
