//
//  NewCalendarWeekTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarWeekTableViewCell.h"
#import "NewCalendarWeekCollectionViewCell.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"
#import "DateTools.h"

@interface NewCalendarWeekTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UILabel * dayLabel ; // 几月几号
@property (nonatomic,strong) UILabel * weekLabel ;// 周几
@property (nonatomic,strong) UIButton * moreButton ; // 可滚动标示
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NewCalendarWeeksListModel * model ;
@property (nonatomic,strong) NSIndexPath * path ;

@end

@implementation NewCalendarWeekTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 3;
        
        self.collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        //注册Cell
        [self.collectionView registerClass:[NewCalendarWeekCollectionViewCell class] forCellWithReuseIdentifier:@"NewCalendarWeekCollectionViewCell"];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.weekLabel];
        [self.contentView addSubview:self.moreButton];
        
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(3);
            make.left.equalTo(self.contentView).offset(5);
            make.width.equalTo(@22);
            make.height.equalTo(@15);
        }];
        [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayLabel.mas_bottom).offset(3);
            make.centerX.equalTo(self.dayLabel);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-18);
        }];
        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.collectionView.mas_right);
        }];
        
    }
    return self;
}
- (void)setCellPath:(NSIndexPath *)path
{
    self.path = path;
}
- (void)setCellData:(NewCalendarWeeksListModel *)dataArray
{
    self.model = dataArray;
    self.startDate = self.model.srartTime;
    self.endDate = self.model.endTime;
    
    self.dayLabel.text = self.model.NO_Day;
    self.weekLabel.text = self.model.NO_Weeks;
    if (self.model.calendarArray.count > 5) {
        self.moreButton.hidden = NO;
    }else {
        self.moreButton.hidden = YES;
    }
    
    NSDate * date = [NSDate date];
    if ([date isLaterThanOrEqualTo:self.model.srartTime] && [date isEarlierThanOrEqualTo:self.model.endTime]) { // 当天
        self.dayLabel.backgroundColor = [UIColor colorWithRed:0 green:141/255.0 blue:251/255.0 alpha:1];
        self.dayLabel.textColor = [UIColor whiteColor];
    }else {
        self.dayLabel.backgroundColor = [UIColor whiteColor];
        self.dayLabel.textColor = [UIColor blackColor];
    }
    [self.collectionView reloadData];
}

- (void)moreButtonClick
{
    float width = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 1.2;
    float Offset_width ;
    if (width > self.collectionView.contentSize.width) {
        Offset_width = self.collectionView.contentSize.width - self.collectionView.bounds.size.width;
    }else {
        Offset_width = width - self.collectionView.bounds.size.width;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.contentOffset = CGPointMake(Offset_width, self.collectionView.contentOffset.y);
    }];
    
    
}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCalendarWeekCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewCalendarWeekCollectionViewCell" forIndexPath:indexPath];
    NewCalendarWeeksModel * model = self.model.calendarArray[indexPath.row];
    NSDate * date = [NSDate date];
    if (![date isLaterThanOrEqualTo:self.model.srartTime] || ![date isEarlierThanOrEqualTo:self.model.endTime]) { // 不是当天
        if ([model.type isEqualToString:@"company_festival"] || [model.type isEqualToString:@"statutory_festival"]) {
            self.dayLabel.textColor = [UIColor redColor];
        }
    }
    [cell setCellData:model];
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = (collectionView.frame.size.width- 3*4)/5;
    return CGSizeMake(width, 78);
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.calendarArray.count;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_calendarDelegate && [_calendarDelegate respondsToSelector:@selector(newCalendarWeekTableViewCell_SelectCalendarWithRow:num:)]) {
        [_calendarDelegate newCalendarWeekTableViewCell_SelectCalendarWithRow:self.path.row num:indexPath.row];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textColor = [UIColor blackColor];
        _dayLabel.font = [UIFont mtc_font_26];
        _dayLabel.layer.masksToBounds = YES;
        _dayLabel.layer.cornerRadius = 2.0;
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}
- (UILabel *)weekLabel
{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
        _weekLabel.font = [UIFont mtc_font_24];
    }
    return _weekLabel;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"more_btn_icon"] forState:UIControlStateNormal];
        [_moreButton setBackgroundColor:[UIColor whiteColor]];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.hidden = YES;
    }
    return _moreButton;
}


@end
