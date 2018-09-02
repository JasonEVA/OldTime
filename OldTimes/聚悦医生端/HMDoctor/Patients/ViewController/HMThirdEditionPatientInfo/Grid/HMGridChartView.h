//
//  HMGridChartView.h
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IF_T_FF(s,r,section,row) if(r == row && s == section)
#define EF_T_FF(s,r,section,row) else if(r == row && s == section)
#define IF_FF(x,m) if(x == m)
#define EF_FF(x,m) else if(x == m)

@class HMGridChartView;

@protocol HMGridChartViewDelegate
@optional
////表单行数
- (NSInteger)rowForList:(HMGridChartView*)list;
////表单列数
- (NSInteger)columnForList:(HMGridChartView*)list;
////表单显示范围
- (CGRect)boundsForList:(HMGridChartView*)list;
////表单某一格的边框颜色
- (UIColor*)listChart:(HMGridChartView*)list borderColorForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一行的背景颜色
- (UIColor*)listChart:(HMGridChartView*)list backgroundColorForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格的大小
- (CGSize)listChart:(HMGridChartView*)list itemSizeForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格字体的大小
- (UIFont*)listChart:(HMGridChartView*)list fontForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格字体的颜色
- (UIColor*)listChart:(HMGridChartView*)list textColorForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格的文字
- (NSString*)listChart:(HMGridChartView*)list textForRow:(NSInteger)row column:(NSInteger)column;
////点击触发事件
-(void)listChart:(HMGridChartView*)list clickForRow:(NSInteger)row column:(NSInteger)column;

@end

#define DelegateResponds(selector) (self.delegate != nil && [(NSObject*)self.delegate respondsToSelector:selector])

@interface HMGridChartView : UIView

@property(nonatomic,strong)UIColor *listBackgroundColor;
@property(nonatomic,strong)UIColor *borderColor;
@property(nonatomic,assign)CGFloat borderWidth;
@property(nonatomic,assign)CGFloat cornerRadius;
@property(nonatomic,strong)UIFont *textFont;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,assign)NSTextAlignment alignment;
@property(nonatomic,assign)id<HMGridChartViewDelegate> delegate;

-(CGSize)itemDefaultSize;
-(void)reloadData;

@end
