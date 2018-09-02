//
//  HealthPlanDateSelectView.h
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface HealthPlanDateSelectView : UIView
{
    
}
@property (nonatomic, readonly) UIButton* insbutton;
@property (nonatomic, readonly) UIButton* desbutton;

@property (nonatomic, retain) NSDate* date;
@end


typedef void(^rightDateBtnClickBlock)(void);

@interface HealthPlanSENavTitleView : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *dietRecordBtn;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) rightDateBtnClickBlock clickBlock;

@end

@interface HealthPlanSEAddDietView : UIView

@property (nonatomic, copy) NSString *dietType;
@property (nonatomic, strong) UITextView *tvFood;
@property (nonatomic, strong) UILabel *placeholderLb;
@property (nonatomic, strong) UIViewController *ownViewController;

- (void)setFoodTextView:(NSString *)text placeholder:(BOOL)isShow;
@end
