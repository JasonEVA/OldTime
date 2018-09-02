//
//  TrainEffectOnEachPartView.h
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 训练计划下部训练效果View

#import <UIKit/UIKit.h>
#import "TrainGetTrainInfoModel.h"



@interface TrainEffectOnEachPartView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UICollectionView *collectView;

- (void)setMyData:(TrainGetTrainInfoModel *)model;
@end
