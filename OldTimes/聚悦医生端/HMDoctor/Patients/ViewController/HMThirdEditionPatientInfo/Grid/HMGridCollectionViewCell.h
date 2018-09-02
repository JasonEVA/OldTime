//
//  HMGridCollectionViewCell.h
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMixGridContentSizeFlowLayout : UICollectionViewFlowLayout

@property(nonatomic,copy)NSInteger (^sectionCountBlock)(void);
@property(nonatomic,copy)NSInteger (^itemCountBlock)(NSInteger section);
@property(nonatomic,copy)CGSize (^itemSizeBlock)(NSIndexPath *indexPath);
@property(nonatomic,assign)CGRect oldBounds;
@property(nonatomic,strong)NSMutableArray *itemAttributesDataArray;

-(void)refreshLayoutAttributes;

@end

@interface HMGridCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *textContentLabel;
@property(nonatomic,strong)UIImageView *borderLeftLine;
@property(nonatomic,strong)UIImageView *borderTopLine;
@property(nonatomic,strong)UIImageView *borderRightLine;
@property(nonatomic,strong)UIImageView *borderBottomLine;

-(void)configurationContentText:(NSString*)content;
-(void)configurationBorder:(BOOL)haveLeft haveRight:(BOOL)haveRight haveTop:(BOOL)haveTop haveBottom:(BOOL)haveBottom lineWidth:(CGFloat)lineWidth borderColor:(UIColor*)borderColor itemSize:(CGSize)itemSize
;

@end
