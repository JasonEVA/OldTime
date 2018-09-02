//
//  NomarlDealWithEventView.h
//  launcher
//
//  Created by conanma on 15/12/17.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    viewtype_selfdefine,
    viewtype_edit,
    viewtype_deal,
}viewtype;

typedef void(^passbackblock)(NSInteger);

@interface NomarlDealWithEventView : UIView
@property (nonatomic) BOOL canappear;
@property (nonatomic, copy) passbackblock backblock;
- (void)setpassbackBlock:(passbackblock)block;
- (void)tapdismess;
- (void)appear;
///
-(instancetype)initWithArrayLogos:(NSArray *)arraylogo arrayTitles:(NSArray *)arrayTitle;
//两种 一种编辑  一种审批
-(instancetype)initWithType:(viewtype)type;
@end
