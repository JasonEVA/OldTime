//
//  HMGridCollectionViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGridCollectionViewCell.h"


@implementation HMMixGridContentSizeFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    self.oldBounds = self.collectionView.bounds;
    if (!self.itemAttributesDataArray)
    {
        [self refreshLayoutAttributes];
    }
}

-(void)refreshLayoutAttributes
{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger sectionCount = self.sectionCountBlock();
    CGFloat startY = 0.0f;
    for (NSInteger section=0; section < sectionCount; section++)
    {
        CGFloat startX = 0.0f;
        CGFloat maxHeight = 0.0f;
        NSInteger itemCount = self.itemCountBlock(section);
        for (NSInteger item = 0; item<itemCount; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize itemSize = self.itemSizeBlock(indexPath);
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(startX, startY, itemSize.width, itemSize.height);
            [resultArray addObject:attributes];
            startX += itemSize.width;
            maxHeight = MAX(maxHeight, itemSize.height);
        }
        startY += maxHeight;
    }
    self.itemAttributesDataArray = resultArray;
}

-(CGSize)collectionViewContentSize
{
    NSInteger sectionCount = self.sectionCountBlock();
    CGFloat startY = 0.0f;
    CGFloat maxWidth = 0.0f;
    for (NSInteger section=0; section < sectionCount; section++)
    {
        CGFloat startX = 0.0f;
        CGFloat maxHeight = 0.0f;
        NSInteger itemCount = self.itemCountBlock(section);
        for (NSInteger item = 0; item<itemCount; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize itemSize = self.itemSizeBlock(indexPath);
            startX += itemSize.width;
            maxHeight = MAX(maxHeight, itemSize.height);
            maxWidth = MAX(maxWidth, startX);
        }
        startY += maxHeight;
    }
    return CGSizeMake(maxWidth, startY);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    for (NSInteger section=0; section < indexPath.section; section++)
    {
        NSInteger itemCount = self.itemCountBlock(section);
        index += itemCount;
    }
    index += indexPath.item;
    return [self.itemAttributesDataArray objectAtIndex:index];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.oldBounds.size.width == newBounds.size.width && self.oldBounds.size.height == newBounds.size.height)
    {
        return NO;
    }
    
    return YES;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.itemAttributesDataArray;
}

@end



@implementation HMGridCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.textContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(3.0f, 0.5f*self.bounds.size.height, self.bounds.size.width - 3.0f, 0.0f)];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.textContentLabel];
        
        self.borderLeftLine = [UIImageView new];
        [self addSubview:self.borderLeftLine];
        
        self.borderRightLine = [UIImageView new];
        [self addSubview:self.borderRightLine];
        
        self.borderTopLine = [UIImageView new];
        [self addSubview:self.borderTopLine];
        
        self.borderBottomLine = [UIImageView new];
        [self addSubview:self.borderBottomLine];
    }
    return self;
}


-(void)configurationContentText:(NSString *)content
{
    [self.textContentLabel setText:content];
    [self layoutSubviews];
}

-(void)configurationBorder:(BOOL)haveLeft haveRight:(BOOL)haveRight haveTop:(BOOL)haveTop haveBottom:(BOOL)haveBottom lineWidth:(CGFloat)lineWidth borderColor:(UIColor*)borderColor itemSize:(CGSize)itemSize
{
    [self.borderLeftLine setHidden:!haveLeft];
    [self.borderRightLine setHidden:!haveRight];
    [self.borderTopLine setHidden:!haveTop];
    [self.borderBottomLine setHidden:!haveBottom];
    [self.borderLeftLine setFrame:CGRectMake(0.0f, 0.0f, lineWidth, itemSize.height)];
    [self.borderRightLine setFrame:CGRectMake(itemSize.width - lineWidth, 0.0f, lineWidth, itemSize.height)];
    [self.borderTopLine setFrame:CGRectMake(0.0f, 0.0f, itemSize.width, lineWidth)];
    [self.borderBottomLine setFrame:CGRectMake(0.0f, itemSize.height - lineWidth, itemSize.width, lineWidth)];
    [self.borderLeftLine setBackgroundColor:borderColor];
    [self.borderRightLine setBackgroundColor:borderColor];
    [self.borderTopLine setBackgroundColor:borderColor];
    [self.borderBottomLine setBackgroundColor:borderColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self.textContentLabel sizeThatFits:CGSizeMake(self.textContentLabel.frame.size.width, self.frame.size.height)];
    size = CGSizeMake(MIN(size.width, self.bounds.size.width - 6.0f), MIN(self.bounds.size.height - 6.0f, size.height));
    [self.textContentLabel setFrame:CGRectMake(3.0f, 0.5f*(self.bounds.size.height - size.height), self.bounds.size.width - 6.0f, size.height)];
    [self.textContentLabel setAdjustsFontSizeToFitWidth:YES];
}


@end
