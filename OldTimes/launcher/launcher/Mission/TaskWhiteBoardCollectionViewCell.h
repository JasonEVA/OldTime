//
//  TaskWhiteBoardCollectionViewCell.h
//  launcher
//
//  Created by William Zhang on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  白板CollectionView Cell

#import <UIKit/UIKit.h>

@class TaskWhiteBoardCollectionViewCell;

typedef void(^TaskWhiteBoardCollectionCellDeleteBlock)(TaskWhiteBoardCollectionViewCell *collectionViewCell);
typedef void(^TaskWhiteBoardCollectionCellDidEditBlock)(TaskWhiteBoardCollectionViewCell *collectionViewCell, NSString *editedString);

@interface TaskWhiteBoardCollectionViewCell : UICollectionViewCell

/** textfield是否可以输入 */
@property (nonatomic, assign) BOOL canEdit;
/** 是否是新的白板 */
@property (nonatomic, assign) BOOL newWhite;

@property (nonatomic, assign) BOOL canDelete;

@property (nonatomic, strong) NSString *title;

+ (NSString *)identifier;

- (void)shakeShake:(BOOL)canShake;

- (void)clickDelete:(TaskWhiteBoardCollectionCellDeleteBlock)deleteBlock edit:(TaskWhiteBoardCollectionCellDidEditBlock)editBlock;

@end
