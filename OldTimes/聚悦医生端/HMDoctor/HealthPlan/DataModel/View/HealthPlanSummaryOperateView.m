//
//  HealthPlanSummaryOperateView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSummaryOperateView.h"

static const NSInteger kHealtPlanOperationBaseTag = 0x310;

@interface HealthPlanSummaryOperateView ()

@end

@implementation HealthPlanSummaryOperateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showTopLine];
    }
    return self;
}

- (void) setOpeartions:(NSArray*) opeartions
{
    NSMutableArray* buttons = [NSMutableArray array];
    
    [opeartions enumerateObjectsUsingBlock:^(NSNumber* operationNumber, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
         [self addSubview:button];
         
         [button setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
         [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
         NSString* operationTitle = [self operationTitle:operationNumber.integerValue];
         [button setTitle:operationTitle forState:UIControlStateNormal];
         
         [buttons addObject:button];
         [button setTag:(operationNumber.integerValue + kHealtPlanOperationBaseTag)];
         
         button.layer.cornerRadius = 5;
         button.layer.masksToBounds = YES;
         
         [button addTarget:self action:@selector(operateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     }];
    
    _operationButtons = buttons;
    [self layoutButtons];
}

- (NSString*) operationTitle:(EHealthPlanOperation) operation
{
    NSString* title = nil;
    switch (operation) {
        case HealthPlanOperation_None:
        {
            break;
        }
        case HealthPlanOperation_Commit:
        {
            title = @"提交";
            break;
        }
        case HealthPlanOperation_Confirm:
        {
            title = @"确认";
            break;
        }
    }
    return title;
}

- (void) layoutButtons
{
    
    [self.operationButtons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [button mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self).offset(5);
             make.bottom.equalTo(self).offset(-5);
             
             if (button == self.operationButtons.firstObject) {
                 make.left.equalTo(self).offset(15);
             }
             else
             {
                 UIButton* perButton = self.operationButtons[idx - 1];
                 make.left.equalTo(perButton.mas_right).offset(10);
                 make.width.equalTo(perButton);
             }
             
             if (button == self.operationButtons.lastObject) {
                 make.right.equalTo(self).offset(-15);
             }
         }];
     }];
}

#pragma mark button click event
- (void) operateButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    
    UIButton* button = (UIButton*) sender;
    EHealthPlanOperation operate = button.tag - kHealtPlanOperationBaseTag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(operateButtonClicked:)])
    {
        [self.delegate operateButtonClicked:operate];
    }
    
}


@end
