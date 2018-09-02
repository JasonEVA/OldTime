//
//  HMSuperviseChartView.m
//  HMClient
//
//  Created by jasonwang on 2017/7/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseChartView.h"
#import "HMSuperviseDetailBaseCollectionViewCell.h"
#import "HMSuperviseDetailXAxisCollectionViewCell.h"
#import "HMSuperviseDetailYAxisView.h"
#import "HMSuperviseInfoView.h"
#import "UIImage+EX.h"
#import "HMSuperviseDetailModel.h"
#import "HMSuperviseFirstDateView.h"
#import "HMSuperviseEachPointModel.h"
#import "HMSuperviseDetailXTYAxisView.h"

#define CHARTHEIGHT    (self.frame.size.height - XAXISHEIGHT)
#define CHARTWIDTH     (self.frame.size.width - YAXISWIDTH)
#define XAXISHEIGHT    50
#define YAXISWIDTH     50
#define XUNITWIDTH     (CHARTWIDTH / 7.0)

@interface HMSuperviseChartView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *XAxiscollectionView;   // X轴
@property (nonatomic, strong) HMSuperviseDetailYAxisView *YAxisView;   // Y轴
@property (nonatomic, strong) HMSuperviseInfoView *infoView;
@property (nonatomic, strong) UIView *XLine;
@property (nonatomic, strong) UIView *YLine;

@property (nonatomic) CGFloat minTarget;
@property (nonatomic) CGFloat maxTarget;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic) SESuperviseType type;
@property (nonatomic) NSInteger YCount;  // Y轴格数
@property (nonatomic) NSInteger YOffset; // Y轴最大最小数值浮动范围
@property (nonatomic,strong) NSMutableArray *showDateModelArr;
@property (nonatomic, strong) NSIndexPath *lastFirstXIndexPath;
@property (nonatomic) NSInteger showFirstMonth;
@property (nonatomic) NSInteger showFirstYear;
@property (nonatomic, strong) HMSuperviseFirstDateView *firstDateView;
@property (nonatomic, copy) AddNextPageBlock block;
@property (nonatomic, copy) NSString *kpiCode;
@property (nonatomic, strong) HMSuperviseDetailXTYAxisView *XTYAxisView;  // 血糖专用Y轴
@end

@implementation HMSuperviseChartView

- (instancetype)initWithFrame:(CGRect)frame kpiCode:(NSString *)kpiCode {
    if (self = [super initWithFrame:frame]) {
        [self configTypeWithKpiCode:kpiCode];
        self.kpiCode = kpiCode;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.YCount = 11;

        [self addSubview:self.YAxisView];
        [self.YAxisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.equalTo(@YAXISWIDTH);
            make.height.equalTo(@CHARTHEIGHT);
        }];

        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.YAxisView.mas_right);
            make.width.equalTo(@CHARTWIDTH);
            make.height.equalTo(@CHARTHEIGHT);
        }];
        
        [self addSubview:self.XAxiscollectionView];
        [self.XAxiscollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom);
            make.right.left.equalTo(self.collectionView);
            make.height.equalTo(@XAXISHEIGHT);
        }];
        
        [self addSubview:self.XLine];
        
        [self.XLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.collectionView);
            make.height.equalTo(@1);
        }];
        
        [self addSubview:self.YLine];
        [self.YLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self.collectionView);
            make.width.equalTo(@1);
        }];
        
        [self addSubview:self.firstDateView];
        
        if ([kpiCode isEqualToString:@"XT"]) {
            [self addSubview:self.XTYAxisView];
            [self.XTYAxisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self);
                make.width.equalTo(@(YAXISWIDTH+CHARTWIDTH));
                make.height.equalTo(@CHARTHEIGHT);
            }];
            [self.YAxisView setHidden: YES];
        }
        else {
            [self.YAxisView setHidden: NO];
        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if ([self.kpiCode isEqualToString:@"XT"]) {
        return;
    }
    
    CGFloat YheightUnit = self.collectionView.frame.size.height / (self.YCount);
    for (NSInteger i = 0; i < self.YCount; i++) {
        UIBezierPath *pathLine = [UIBezierPath bezierPath];
        
        [pathLine moveToPoint:CGPointMake(YAXISWIDTH, YheightUnit * (i+1))];
        
        [pathLine addLineToPoint:CGPointMake(self.frame.size.width, YheightUnit * (i+1))];
        
        [pathLine setLineWidth:1];
        CGFloat dashPattern[] = {3,1};// 3实线，1空白
        
        [pathLine setLineDash:dashPattern count:1 phase:1];
        
        [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
        
        [pathLine stroke];
    }
}

#pragma mark -private method
- (void)configElements {
    
}

- (void)configTypeWithKpiCode:(NSString *)kpiCode {
    if ([kpiCode isEqualToString:@"XY"]) {
        self.type = SESuperviseType_Pressure;
        self.YOffset = 20;
    }
    else if ([kpiCode isEqualToString:@"XL"]) {
        self.type = SESuperviseType_Common;
        self.YOffset = 10;
    }
    else if ([kpiCode isEqualToString:@"TZ"]) {
        self.type = SESuperviseType_Common;
        self.YOffset = 5;
    }
    else if ([kpiCode isEqualToString:@"OXY"]) {
        self.type = SESuperviseType_Common;
        self.YOffset = 5;
    }
    else if ([kpiCode isEqualToString:@"TEM"]) {
        self.type = SESuperviseType_Common;
        self.YOffset = 5;
    }
    else if ([kpiCode isEqualToString:@"NL"]) {
        self.type = SESuperviseType_Histogram;
        self.YOffset = 100;
    }
    else if ([kpiCode isEqualToString:@"XT"]) {
        self.type = SESuperviseType_BloodGlucose;
    }
    else if ([kpiCode isEqualToString:@"HX"]) {
        self.type = SESuperviseType_Common;
        self.YOffset = 100;
    }
    else if ([kpiCode isEqualToString:@"FLSZ"]) {
        self.type = SESuperviseType_PeakVelocity;
        self.YOffset = 100;
    }

}

- (void)XConnectionScrollToBottom {
    if (self.dataList && self.dataList.count) {
        
        [self.XAxiscollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataList.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

- (void)configXData:(CGFloat)offSetX {
    if (offSetX < 0) {
        return;
    }
    NSInteger i = [NSString stringWithFormat:@"%f",(offSetX / XUNITWIDTH)].integerValue;
    
    HMSuperviseDetailModel *model = self.dataList[i];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startday / 1000];
    NSInteger month = [date formattedDateWithFormat:@"MM"].integerValue;
    NSInteger year = [date formattedDateWithFormat:@"yyyy"].integerValue;
    [self.firstDateView fillDataWithDate:date superviseScreening:self.selectedScreening];
    self.showFirstYear = year;
    self.showFirstMonth = month;

    [self performSelector:@selector(reloadXCollection) withObject:nil afterDelay:0.000001];

}

- (void)reloadXCollection {
    [self.XAxiscollectionView reloadData];
}

- (void)configMaxMinTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget {
    if ([self.kpiCode isEqualToString:@"XY"]) {
        self.minTarget = 0;
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 10) + 1) * 10;

        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];
        
    }
    else if ([self.kpiCode isEqualToString:@"XL"]) {
        self.minTarget = 0;
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 10) + 1) * 10;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];
    
    }
    else if ([self.kpiCode isEqualToString:@"TZ"]) {
        self.minTarget = 0;
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 10) + 1) * 10;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];

    }
    else if ([self.kpiCode isEqualToString:@"OXY"]) {
        
        self.minTarget = MAX(minTarget-5, 0);
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 1) + 1) * 1;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];


    }
    else if ([self.kpiCode isEqualToString:@"TEM"]) {
        self.minTarget = 34;
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 1) + 1) * 1;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];

    }
    else if ([self.kpiCode isEqualToString:@"NL"]) {
        self.minTarget = 0;
        
        CGFloat unit = (2200 - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = tempString.integerValue;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];

    }
    else if ([self.kpiCode isEqualToString:@"XT"]) {
        self.minTarget = 0;
        self.maxTarget = maxTarget + 5;
        [self.XTYAxisView fillDataWithMax:self.maxTarget min:self.minTarget];
    }
    else if ([self.kpiCode isEqualToString:@"HX"]) {
        self.minTarget = MAX(minTarget-5, 0);
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 1) + 1) * 1;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];

    }
    else if ([self.kpiCode isEqualToString:@"FLSZ"]) {
        self.minTarget = 0;
        
        CGFloat unit = (maxTarget - self.minTarget) / self.YCount;
        NSString *tempString = [NSString stringWithFormat:@"%f",unit];
        NSInteger tempInt = ((tempString.integerValue / 10) + 1) * 10;
        
        NSMutableArray *YdataList = [NSMutableArray array];
        for (int i = 0; i < self.YCount; i++) {
            [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
        }
        self.maxTarget = self.minTarget + tempInt * (self.YCount);
        [self.YAxisView fillDataListWithArr:[[YdataList reverseObjectEnumerator] allObjects]];

    }
    
}
#pragma mark - event Response
- (void)showInfoViewClickWithIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [self.collectionView convertRect:[self.collectionView cellForItemAtIndexPath:indexPath].frame toView:[self.collectionView superview]];
    CGFloat cellXCenter = rect.origin.x + (XUNITWIDTH / 2);
    if (cellXCenter > ScreenWidth-15 || cellXCenter < YAXISWIDTH+10) {
        // 超出屏幕不响应
        return;
    }
    HMSuperviseDetailBaseCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.heightBtn setBackgroundColor:[UIColor colorWithHexString:@"EBFEFC"]];
    [self addSubview:self.infoView];
    [self.infoView showInfoViewWithArrowXCenter:cellXCenter Model:self.dataList[indexPath.row] superviseScreening:self.selectedScreening kpiCode:self.kpiCode];
}

- (void)hideInfoViewClick {
    [self.infoView removeFromSuperview];
    self.infoView = nil;
}

#pragma mark - Delegate

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    if ([collectionView isEqual:self.collectionView]) {
        HMSuperviseDetailModel *model = self.dataList[indexPath.row];

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSuperviseDetailBaseCollectionViewCell at_identifier] forIndexPath:indexPath];
        
        BOOL isShowSolidLine;
        if (self.selectedScreening == SESuperviseScreening_Default) {
            // 默认按次
            isShowSolidLine = model.first > 0;
        }
        else {
            // 日均周均月均
            isShowSolidLine = YES;
        }
        
        [cell fillDataWithModel:model maxTarget:self.maxTarget minTarget:self.minTarget isShowSolidLine:isShowSolidLine isShowRightLinr:(indexPath.row == (self.dataList.count - 1)) type:self.type];

        __weak typeof(self) weakSelf = self;
        
        [cell getCellTouchStatus:^(BOOL isTouchDown, BOOL isTouchUp) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (isTouchDown) {
                [strongSelf showInfoViewClickWithIndexPath:indexPath];
            }
            
            if (isTouchUp) {
                [strongSelf hideInfoViewClick];
            }
        }];

    }
    else {
        // X轴cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSuperviseDetailXAxisCollectionViewCell at_identifier] forIndexPath:indexPath];
        HMSuperviseDetailModel *nowModel = self.dataList[indexPath.row];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:nowModel.startday / 1000];
        NSInteger month = [date formattedDateWithFormat:@"MM"].integerValue;
        NSInteger year = [date formattedDateWithFormat:@"yyyy"].integerValue;
        BOOL isShowMonth = NO;
        BOOL isShowYear = NO;
        __block NSInteger tempInt = -1;

        [self.showDateModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HMSuperviseDetailModel *tempModelOne = (HMSuperviseDetailModel *)obj;
            if (nowModel.startday == tempModelOne.startday) {
                tempInt = idx;
            }
        }];
        if (tempInt > -1) {
            if (tempInt < 1) {
                // 第一个显示全部年月日
                isShowYear = YES;
                isShowMonth = YES;
            }
            else {
                HMSuperviseDetailModel *lastModel = self.showDateModelArr[tempInt - 1];
                NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastModel.startday / 1000];
                NSInteger lastMonth = [lastDate formattedDateWithFormat:@"MM"].integerValue;
                NSInteger lastYear = [lastDate formattedDateWithFormat:@"yyyy"].integerValue;
                
                isShowYear = (year - lastYear);
                isShowMonth = ((month - lastMonth) || isShowYear);
            }

        }
        BOOL isHideDate;
        if (self.selectedScreening == SESuperviseScreening_Default) {
            // 默认按次
            isHideDate = !nowModel.first;
        }
        else {
            // 日均周均月均
            isHideDate = NO;
        }

        
        [cell fillDataWithDate:date isHide:isHideDate showDay:YES showMonth:isShowMonth showYear:isShowYear superviseScreeningType:self.selectedScreening];
        
        if (isShowMonth && ((month > self.showFirstMonth) || (year > self.showFirstYear))) {
           
            isShowMonth = YES;
        }
        else {
            isShowMonth = NO;
        }
        
        if (isShowYear && (year > self.showFirstYear)) {
            isShowYear = YES;
            isShowMonth = YES;
        }
        else {
            isShowYear = NO;
        }
        
        [cell fillDataWithDate:date isHide:isHideDate showDay:YES showMonth:isShowMonth showYear:isShowYear superviseScreeningType:self.selectedScreening];

    }
    
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        return CGSizeMake(XUNITWIDTH, self.collectionView.frame.size.height);
        
    }
    else {
        return CGSizeMake(XUNITWIDTH, XAXISHEIGHT);
    }
}

//定义每个UICollectionView 的 margin

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        NSLog(@"%f",[self.collectionView cellForItemAtIndexPath:indexPath].frame.origin.x);
    }
}


//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [self.XAxiscollectionView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
    else {
        [self.collectionView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
    [self configXData:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x < 0) {
        // 加载下一页数据
        if (self.block) {
            self.block();
        }
        
    }
}
#pragma mark - request Delegate

#pragma mark - Interface
- (void)addDataWithDataList:(NSArray *)dataList maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget {
    NSArray *temp = [[dataList reverseObjectEnumerator] allObjects];

    if (self.page < 2) {
        // 第一页
        [self.dataList removeAllObjects];
        [self.showDateModelArr removeAllObjects];
        [self.dataList addObjectsFromArray:temp];
    }
    else {
        NSMutableArray *tempMub = [NSMutableArray array];
        [tempMub addObjectsFromArray:temp];
        [tempMub addObjectsFromArray:self.dataList];
        self.dataList = tempMub;
    }
    
    if (self.selectedScreening == SESuperviseScreening_Default) {
        __block NSMutableArray *tempArr = [NSMutableArray array];
        [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HMSuperviseDetailModel *model = (HMSuperviseDetailModel *)obj;
            if (model.first > 0) {
                [tempArr addObject:obj];
            }
        }];
        self.showDateModelArr = tempArr;
    }
    else {
        self.showDateModelArr = self.dataList;
    }
    
    [self configMaxMinTarget:maxTarget minTarget:minTarget];
    
    [self.collectionView reloadData];
    [self.XAxiscollectionView reloadData];
    
    if (self.page < 2) {
        // 第一页滚到最右边
        [self configXData:0];
        [self performSelector:@selector(XConnectionScrollToBottom) withObject:nil afterDelay:0.00001];
    }
    else {
        // 分页加载滚到原地
        if (temp && temp.count) {
            [self.XAxiscollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:temp.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }

}

- (void)addNextPageAction:(AddNextPageBlock)block {
    self.block = block;
}
#pragma mark - init UI

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView setShowsHorizontalScrollIndicator:NO];

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
                
        [_collectionView registerClass:[HMSuperviseDetailBaseCollectionViewCell class] forCellWithReuseIdentifier:[HMSuperviseDetailBaseCollectionViewCell at_identifier]];
        
        //        [_collectionView registerClass:[HMSEMainStartHealthClassCollectionViewCell class] forCellWithReuseIdentifier:[HMSEMainStartHealthClassCollectionViewCell at_identifier]];
        //        [_collectionView registerClass:[HMSEMainStartToolBoxCollectionViewCell class] forCellWithReuseIdentifier:[HMSEMainStartToolBoxCollectionViewCell at_identifier]];
        
    }
    return _collectionView;
}

- (UICollectionView *)XAxiscollectionView {
    if (!_XAxiscollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        _XAxiscollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_XAxiscollectionView setShowsHorizontalScrollIndicator:NO];

        _XAxiscollectionView.dataSource = self;
        _XAxiscollectionView.delegate = self;
        [_XAxiscollectionView setBackgroundColor:[UIColor whiteColor]];
        
        [_XAxiscollectionView registerClass:[HMSuperviseDetailXAxisCollectionViewCell class] forCellWithReuseIdentifier:[HMSuperviseDetailXAxisCollectionViewCell at_identifier]];
        //        [_collectionView registerClass:[HMSEMainStartToolBoxCollectionViewCell class] forCellWithReuseIdentifier:[HMSEMainStartToolBoxCollectionViewCell at_identifier]];
        
    }
    return _XAxiscollectionView;
}

- (HMSuperviseDetailYAxisView *)YAxisView {
    if (!_YAxisView) {
        _YAxisView = [[HMSuperviseDetailYAxisView alloc] initWithFrame:CGRectMake(0, 0, 50, CHARTHEIGHT)];
        [_YAxisView fillDataListWithArr:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    }
    return _YAxisView;
}

- (HMSuperviseDetailXTYAxisView *)XTYAxisView {
    if (!_XTYAxisView) {
        _XTYAxisView = [[HMSuperviseDetailXTYAxisView alloc] initWithFrame:CGRectMake(0, 0, YAXISWIDTH + CHARTWIDTH, CHARTHEIGHT)];
    }
    return _XTYAxisView;
}

- (HMSuperviseInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[HMSuperviseInfoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CHARTHEIGHT)];
    }
    return _infoView;
}

- (UIView *)XLine {
    if (!_XLine) {
        _XLine = [UIView new];
        [_XLine setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _XLine;
}
- (UIView *)YLine {
    if (!_YLine) {
        _YLine = [UIView new];
        [_YLine setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _YLine;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)showDateModelArr {
    if (!_showDateModelArr) {
        _showDateModelArr = [NSMutableArray array];
    }
    return _showDateModelArr;
}

- (HMSuperviseFirstDateView *)firstDateView {
    if (!_firstDateView) {
        _firstDateView = [[HMSuperviseFirstDateView alloc] initWithFrame:CGRectMake(YAXISWIDTH, CHARTHEIGHT, XUNITWIDTH, XAXISHEIGHT)];
    }
    return _firstDateView;
}


@end
