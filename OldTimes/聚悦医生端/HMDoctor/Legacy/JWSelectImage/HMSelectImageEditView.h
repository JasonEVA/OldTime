//
//  HMSelectImageEditView.h
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//  选择图片可编辑view

#import <UIKit/UIKit.h>

@protocol HMSelectImageEditViewDelegate <NSObject>
// 添加图片
- (void)HMSelectImageEditViewDelegateCallBack_addImage;
// 查看大图
- (void)HMSelectImageEditViewDelegateCallBack_showBigImageWithIndex:(NSIndexPath *)indexPath;

@end

@interface HMSelectImageEditView : UIView

@property (nonatomic) NSInteger maxCount;
@property (nonatomic, strong) NSMutableArray *selectedImageArr;
@property (nonatomic, weak) id<HMSelectImageEditViewDelegate> delegate;

- (instancetype)initWithMaxSelectedCount:(NSInteger)maxCount;
- (void)updateDataListWithArray:(NSArray *)imageArr;

@end
