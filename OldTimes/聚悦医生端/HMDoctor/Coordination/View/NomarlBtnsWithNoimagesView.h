//
//  NomarlBtnsWithNoimagesView.h
//  launcher
//
//  Created by 马晓波 on 16/2/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passbackblock)(NSInteger);

@interface NomarlBtnsWithNoimagesView : UIView
@property (nonatomic) BOOL canappear;
@property (nonatomic, strong) passbackblock backblock;
- (void)setpassbackBlock:(passbackblock)block;
- (void)tapdismess;
- (void)appear;
///
-(instancetype)initWithArrayTitles:(NSArray *)arrayTitle;
-(instancetype)initWithArrayLogos:(NSArray *)arraylogo arrayTitles:(NSArray *)arrayTitle;
@end
