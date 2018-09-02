//
//  NewCalendarCardFlowLayout.m
//  launcher
//
//  Created by kylehe on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarCardFlowLayout.h"

@implementation NewCalendarCardFlowLayout

- (instancetype)init
{
    if (self = [super init])
    {
        //设置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //最小间距
        self.minimumLineSpacing = 20.0;
        //每个section之间的间距
        self.sectionInset = UIEdgeInsetsMake(0, 30, 30, 0);
    }
    return self;
}

//返回最终的偏移点
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGFloat offsetAdjustment = MAXFLOAT;
    
    //单页翻  design by conan
    if (self.collectionView.contentOffset.x >= proposedContentOffset.x)
    {
        proposedContentOffset.x = self.collectionView.contentOffset.x - self.collectionView.frame.size.width/2;
    }
    else
    {
        proposedContentOffset.x = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    }
    
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds)/ 2.0);//collectionView落在屏幕中点的x坐标
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    //获取布局属性
    
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];

    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        //
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

//做一个缩放效果
static CGFloat const ActiveDistance = 350;
static CGFloat const ScaleFactor = 0.05;

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat normalizedDistance = distance / ActiveDistance;
        CGFloat zoom = 1 + ScaleFactor*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        attributes.zIndex = 1;
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end
