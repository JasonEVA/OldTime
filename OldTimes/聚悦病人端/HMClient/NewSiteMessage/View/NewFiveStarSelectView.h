//
//  NewFiveStarSelectView.h
//  HMClient
//
//  Created by jasonwang on 2017/3/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//  评价 5星选择view

#import <UIKit/UIKit.h>

typedef void(^NewFiveStarSelectViewCallBackBlock)(NSInteger starCount);

@interface NewFiveStarSelectView : UIView
@property(nonatomic, strong) UILabel  *commentStarLabel;
@property(nonatomic, strong) NSMutableArray  <UIButton *>*starBtnArray;
@property(nonatomic, copy)  NewFiveStarSelectViewCallBackBlock myBlock;

- (instancetype)initWithName:(NSString *)name;

- (void)getStarCountWithBlock:(NewFiveStarSelectViewCallBackBlock)blcok;

//改变星星状态
- (void)changeStarStatus:(NSInteger)tag;
//星星不可点击
- (void)starDisenable;
@end
