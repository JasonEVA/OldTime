//
//  HMPopUpSelectView.m
//  HMClient
//
//  Created by lkl on 2017/8/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPopUpSelectView.h"

@implementation PopUpSelectModel

@end

@interface HMPopUpSelectView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;

@end

@implementation HMPopUpSelectView

+ (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title dataArray:(NSArray *)dataArr block:(void(^)(NSDictionary *))block{
    HMPopUpSelectView *popView = [[HMPopUpSelectView alloc] initWithFrame:frame];
    popView.dataList = dataArr;
    popView.dataSelectBlock = block;
    popView.backgroundColor = [UIColor clearColor];
    popView.popupTitle = title;
    popView.popUpType = PopUp_Whole;
    [popView initWithSubviews];
    return popView;
}

//把View的位置转换到当前试图中
+ (instancetype)initWithFrame:(CGRect)frame popUpRect:(CGRect)popUpRect dataArray:(NSArray *)dataArr block:(void(^)(NSDictionary *))block{
    HMPopUpSelectView *popView = [[HMPopUpSelectView alloc] initWithFrame:frame];
    popView.dataList = dataArr;
    popView.dataSelectBlock = block;
    popView.backgroundColor = [UIColor clearColor];
    popView.popUpRect = popUpRect;
    popView.popUpType = PopUp_Small;
    [popView initWithSubviews];
    return popView;
}

- (void)initWithSubviews{
    
    UIControl* closeControl = [[UIControl alloc]init];
    [self addSubview:closeControl];
    [closeControl addTarget:self action:@selector(popupCloseControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self createTableView];
    
    switch (_popUpType) {
        case PopUp_Small:
        {
            closeControl.backgroundColor = [UIColor clearColor];
            break;
        }
            
        case PopUp_Whole:
        {
            [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
            break;
        }
            
        default:
        {
            [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
            break;
        }
    }
    
    
}

- (void)createTableView
{
    if (!_dataList){
        return;
    }

    [self addSubview:self.tableView];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    switch (_popUpType) {
        case PopUp_Small:
        {
            float tableheight = _dataList.count * 45;
            if (tableheight > self.height - 50){
                tableheight = self.height- 50;
            }
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.popUpRect.origin.y/2+self.popUpRect.size.height);
                make.left.mas_equalTo(self.popUpRect.origin.x/2);
                make.width.mas_equalTo(self.popUpRect.size);
                make.height.mas_equalTo(tableheight);
            }];
            break;
        }
            
        case PopUp_Whole:
        {
            float tableheight = _dataList.count * 45 + 30;
            if (tableheight > self.height - 50){
                tableheight = self.height- 50;
            }
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(30);
                make.right.equalTo(self).offset(-30);
                make.center.equalTo(self);
                make.height.mas_equalTo(tableheight);
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)popupCloseControlClicked:(UIControl *)sender
{
    [self removeFromSuperview];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (_popUpType) {
        case PopUp_Small:
        {
            return 0;
            break;
        }
            
        case PopUp_Whole:
        {
            return !kStringIsEmpty(self.popupTitle) ? 30 : 0;
            break;
        }
            
        default:
            break;
    }
    return 0.001;
}

//区头的字体颜色设置
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header showBottomLine];
    header.textLabel.textColor = [UIColor mainThemeColor];
    header.textLabel.font = [UIFont font_28];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor whiteColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (_popUpType) {
        case PopUp_Small:
        {
            return nil;
            break;
        }
            
        case PopUp_Whole:
        {
            return !kStringIsEmpty(self.popupTitle) ? self.popupTitle : @"";
            break;
        }
            
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    NSString *testPeriod = [[_dataList objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",testPeriod]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *tempDic = [_dataList objectAtIndex:indexPath.row];
    if (self.dataSelectBlock) {
        self.dataSelectBlock(tempDic);
    }
    [self removeFromSuperview];
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView.layer setCornerRadius:10.0f];
        [_tableView.layer setMasksToBounds:YES];
//        [_tableView.layer setBorderColor:[UIColor commonCuttingLineColor].CGColor];
//        [_tableView.layer setBorderWidth:1.0f];
    }
    return _tableView;
}


@end
