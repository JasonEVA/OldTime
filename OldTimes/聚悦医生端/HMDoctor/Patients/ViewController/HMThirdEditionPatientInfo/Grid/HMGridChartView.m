//
//  HMGridChartView.m
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGridChartView.h"
#import "HMGridCollectionViewCell.h"

@interface HMMixGirdContentSizeCollectionView : UICollectionView

-(void)resetContentSize;

@end

@implementation HMMixGirdContentSizeCollectionView

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:CGSizeMake(MAX(self.contentSize.width, contentSize.width), contentSize.height)];
}
-(void)resetContentSize
{
    [super setContentSize:self.bounds.size];
}

@end




@interface HMGridChartView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)HMMixGirdContentSizeCollectionView *formContentView;
@property(nonatomic,strong)HMMixGridContentSizeFlowLayout *formLayout;

@end

@implementation HMGridChartView

///单元格文字
- (NSString*)text:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:textForRow:column:)))
    {
        NSString *text = [self.delegate listChart:self textForRow:row column:column];
        if (text)
        {
            return text;
        }
        return @"";
    }
    return @"";
}
///单元格文字颜色
- (UIColor*)textColor:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:textColorForRow:column:)))
    {
        UIColor *color = [self.delegate listChart:self textColorForRow:row column:column];
        if (color)
        {
            return color;
        }
        return self.textColor;
    }
    return self.textColor;
}
////单元格文字字体
- (UIFont*)textFont:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:fontForRow:column:)))
    {
        UIFont *font = [self.delegate listChart:self fontForRow:row column:column];
        if (font)
        {
            return font;
        }
        return self.textFont;
    }
    return self.textFont;
}
///单元格文本位置
- (CGRect)textRect:(NSInteger)row column:(NSInteger)column
{
    return CGRectInset([self rect:row column:column], 2.5f, 2.5f);
}
///单元格背景色
- (UIColor*)color:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:backgroundColorForRow:column:)))
    {
        UIColor *color = [self.delegate listChart:self backgroundColorForRow:row column:column];
        if (color)
        {
            return color;
        }
        return self.listBackgroundColor;
    }
    return self.listBackgroundColor;
}
///表单范围
- (CGRect)itemsBounds
{
    CGRect listBounds = self.bounds;
    if (DelegateResponds(@selector(boundsForList:)))
    {
        listBounds = [self.delegate boundsForList:self];
    }
    return listBounds;
}
////单元格大小
- (CGSize)size:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:itemSizeForRow:column:)))
    {
        return [self.delegate listChart:self itemSizeForRow:row column:column];
    }
    return CGSizeMake([self itemsBounds].size.width/[self columns], [self itemsBounds].size.height/[self rows]);
}
///单元格位置
- (CGRect)rect:(NSInteger)row column:(NSInteger)column
{
    CGFloat x = [self itemsBounds].origin.x;
    CGFloat y = [self itemsBounds].origin.y;
    for (NSInteger i=0; i<row; i++)
    {
        y += [self size:i column:column].height;
    }
    for (NSInteger j=0; j<column; j++)
    {
        x += [self size:row column:j].width;
    }
    CGSize size = [self size:row column:column];
    return CGRectMake(x, y, size.width, size.height);
}
///单元格边框颜色
- (UIColor*)borderColor:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        UIColor *color = [self.delegate listChart:self borderColorForRow:row column:column];
        if (color)
        {
            return color;
        }
        return self.borderColor;
    }
    return self.borderColor;
}
////总行数
- (NSInteger)rows
{
    NSInteger rows = 1;
    if (DelegateResponds(@selector(rowForList:)))
    {
        rows = [self.delegate rowForList:self];
    }
    return rows;
}
///总列数
- (NSInteger)columns
{
    NSInteger columns = 1;
    if (DelegateResponds(@selector(columnForList:)))
    {
        columns = [self.delegate columnForList:self];
    }
    return columns;
}
///是否绘制上边框
- (BOOL)borderForTop:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row - 1;
    NSInteger influenceColumn = column;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        if ([self.delegate listChart:self borderColorForRow:row column:column])
        {
            return YES;
        }
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
        
    }
    return NO;
}
///是否绘制下边框
- (BOOL)borderForBottom:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row + 1;
    NSInteger influenceColumn = column;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
        
    }
    return YES;
}
///是否绘制左边框
- (BOOL)borderForLeft:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row;
    NSInteger influenceColumn = column - 1;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        if ([self.delegate listChart:self borderColorForRow:row column:column])
        {
            return YES;
        }
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
        
    }
    return NO;
}
//是否绘制右边框
- (BOOL)borderForRight:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row;
    NSInteger influenceColumn = column + 1;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
    }
    return YES;
}

-(CGSize)itemDefaultSize
{
    return CGSizeMake([self itemsBounds].size.width*1.0f/[self columns], [self itemsBounds].size.height*1.0f/[self rows]);
}

-(void)runClickFunction:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:clickForRow:column:)))
    {
        [self.delegate listChart:self clickForRow:row column:column];
    }
}
-(UIColor *)listBackgroundColor
{
    if (!_listBackgroundColor)
    {
        return self.backgroundColor;
    }
    else
    {
        return _listBackgroundColor;
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _borderColor = [UIColor lightGrayColor];
        _borderWidth = 1.0f/[UIScreen mainScreen].scale;
        _textFont = [UIFont systemFontOfSize:14.0f];
        _textColor = [UIColor blackColor];
        _alignment = NSTextAlignmentCenter;
        _cornerRadius = 5.0f;
        self.formLayout = [[HMMixGridContentSizeFlowLayout alloc]init];
        typeof(self) __weak weakself = self;
        [self.formLayout setItemCountBlock:^NSInteger(NSInteger section)
         {
             return [weakself columns];
         }];
        [self.formLayout setItemSizeBlock:^CGSize(NSIndexPath *indexPath)
         {
             return [weakself size:indexPath.section column:indexPath.item];
         }];
        [self.formLayout setSectionCountBlock:^NSInteger
         {
             return [weakself rows];
         }];
        self.formContentView = [[HMMixGirdContentSizeCollectionView alloc]initWithFrame:[self itemsBounds] collectionViewLayout:self.formLayout];
        [self.formContentView setDataSource:self];
        [self.formContentView setDelegate:self];
        [self.formContentView setBackgroundColor:[self listBackgroundColor]];
        [self.formContentView registerClass:[HMGridCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.formContentView];
    }
    return self;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self rows];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self columns];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self size:indexPath.section column:indexPath.item];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat totalWidth = 0.0f;
    for (NSInteger i=0; i<[self columns]; i++)
    {
        totalWidth += [self size:section column:i].width;
    }
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, collectionView.bounds.size.width - totalWidth);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1.0f]];
    [cell.textContentLabel setFont:[self textFont:indexPath.section column:indexPath.item]];
    [cell configurationContentText:[self text:indexPath.section column:indexPath.item]];
    [cell configurationBorder:[self borderForLeft:indexPath.section column:indexPath.item] haveRight:[self borderForRight:indexPath.section column:indexPath.item] haveTop:[self borderForTop:indexPath.section column:indexPath.item] haveBottom:[self borderForBottom:indexPath.section column:indexPath.item] lineWidth:self.borderWidth borderColor:[self borderColor:indexPath.section column:indexPath.item] itemSize:[self size:indexPath.section column:indexPath.item]];
    [cell.textContentLabel setTextAlignment:self.alignment];
    [cell.textContentLabel setTextColor:[self textColor:indexPath.section column:indexPath.item]];
    [cell setBackgroundColor:[self color:indexPath.section column:indexPath.item]];
    
    //    printf("(%li,%li) ",(long)indexPath.section,(long)indexPath.row);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (DelegateResponds(@selector(listChart:clickForRow:column:)))
    {
        [self.delegate listChart:self clickForRow:indexPath.section column:indexPath.item];
    }
}


-(void)reloadData
{
    [self.formContentView resetContentSize];
    [self.formLayout refreshLayoutAttributes];
    CGFloat maxWidth = 0.0f;
    for (NSInteger section = 0; section < [self rows]; section++)
    {
        CGFloat totalWidth = 0.0f;
        for (NSInteger i=0; i<[self columns]; i++)
        {
            totalWidth += [self size:section column:i].width;
        }
        maxWidth = MAX(maxWidth, totalWidth);
    }
    [self.formContentView setContentSize:CGSizeMake(MAX(MAX(self.formContentView.contentSize.width, maxWidth), self.formContentView.bounds.size.width), self.formContentView.contentSize.height)];
    [self.formContentView reloadData];
    
}

@end




