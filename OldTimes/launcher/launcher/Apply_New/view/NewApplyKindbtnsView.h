//
//  NewApplyKindbtnsView.h
//  launcher
//
//  Created by conanma on 16/1/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passbackblock)(NSInteger);

@interface NewApplyKindbtnsView : UIView
@property (nonatomic) BOOL canappear;
@property (nonatomic, strong) passbackblock backblock;
- (void)setpassbackBlock:(passbackblock)block;
- (void)tapdismess;
- (void)appear;
///
-(instancetype)initWithArrayLogos:(NSArray *)arraylogo arrayTitles:(NSArray *)arrayTitle;
@end
