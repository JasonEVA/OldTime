//
//  HMAssistIndicesDetailTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/7/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAssistIndicesDetailTableViewCell.h"
#import "HMGridChartView.h"

@interface HMAssistIndicesDetailTableViewCell ()

@end

@implementation HMAssistIndicesDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont font_30]];
        [_titleLabel setText:@"aaaaa"];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        _valueLabel = [UILabel new];
        [self.contentView addSubview:_valueLabel];
        [_valueLabel setFont:[UIFont font_30]];
        [_valueLabel setTextColor:[UIColor commonGrayTextColor]];
        [_valueLabel setTextAlignment:NSTextAlignmentRight];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.lessThanOrEqualTo(_titleLabel.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-12.5);
        }];
        
        UIView *cutLintView = [UIView new];
        [self.contentView addSubview:cutLintView];
        [cutLintView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [cutLintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-1);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)setAssistDetail:(CheckItemDetailModel *)detailModel index:(NSInteger)index
{
    NSArray *leftTitle;
    if ([detailModel.fillType isEqualToString:@"1"]) {
        leftTitle = @[@"检验机构",@"检验日期"];
        switch (index) {
            case 0:
                [_valueLabel setText:detailModel.orgAllName];
                break;
                
            case 1:
                [_valueLabel setText:detailModel.checkTime];
                break;
                
            default:
                break;
        }
    }
    else{
        leftTitle = @[@"检验机构",@"检验科室",@"检验日期"];
        CheckIteminsepecJsonDetailModel *insepecCheckJsonModel;
        if (!kDictIsEmpty(detailModel.insepecCheckJsonObject)) {
            insepecCheckJsonModel = [CheckIteminsepecJsonDetailModel mj_objectWithKeyValues:detailModel.insepecCheckJsonObject];
        }
        switch (index) {
            case 0:
                [_valueLabel setText:detailModel.orgName];
                break;
                
            case 1:
                [_valueLabel setText:insepecCheckJsonModel.depName];
                break;
                
            case 2:
                [_valueLabel setText:detailModel.checkTime];
                break;
                
            default:
                break;
        }
    }
    [_titleLabel setText:[leftTitle objectAtIndex:index]];
}

@end

//图片
@interface HMAssistDetailImgTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, copy) NSMutableArray *bigImgArray;

@end

@implementation HMAssistDetailImgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgView = [UIImageView new];
        [self.contentView addSubview:self.imgView];
        [self.imgView setImage:[UIImage imageNamed:@"img_default"]];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
        }];
        
        if (!_bigImgArray) {
            _bigImgArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)setDetailImageUrl:(NSString *)imgUrl
{
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
}

@end

//网格
@interface HMAssistDetailGridTableViewCell ()<HMGridChartViewDelegate>

@property (nonatomic, strong) HMGridChartView *chatView;
@property (nonatomic, strong) NSArray *columnTitleArray;

@property (nonatomic, copy) NSMutableArray *rowTitleArray;
@property (nonatomic, copy) NSMutableArray *resultArray;
@property (nonatomic, copy) NSMutableArray *unitArray;
@property (nonatomic, copy) NSMutableArray *referenceValueArray;
@property (nonatomic, copy) NSMutableArray *flagArray;
@end

@implementation HMAssistDetailGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _columnTitleArray = @[@"检查指标",@"结果",@"单位",@"参考值",@"标识"];
        
        _rowTitleArray = [[NSMutableArray array] init];
        _resultArray = [[NSMutableArray array] init];
        _unitArray = [[NSMutableArray array] init];
        _referenceValueArray = [[NSMutableArray array] init];
        _flagArray = [[NSMutableArray array] init];
        
    }
    return self;
}


- (void)setDetailGridArray:(NSArray *)array
{
    if (kArrayIsEmpty(array)) {
        return;
    }
    
    [array enumerateObjectsUsingBlock:^(CheckItemIndexDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [_rowTitleArray addObject:model.title];
        [_resultArray addObject:model.result];
        [_unitArray addObject:model.unit];
        [_referenceValueArray addObject:model.referenceValue];
        [_flagArray addObject:model.flag];
    }];
    
    _chatView = [[HMGridChartView alloc] initWithFrame:CGRectMake(12.5, 10, kScreenWidth-25, (array.count + 1) * 45)];
    [self.contentView addSubview:_chatView];
    [_chatView setBorderWidth:1.0f];
    [_chatView setDelegate:self];
    [_chatView.layer setBorderColor:[UIColor mainThemeColor].CGColor];
    [_chatView.layer setBorderWidth:1.0f];
    [_chatView.layer setCornerRadius:5.0f];
    [_chatView.layer setMasksToBounds:YES];
}

#pragma mark -- HMGridChartViewDelegate
-(NSInteger)rowForList:(HMGridChartView *)list
{
    return _rowTitleArray.count + 1;
}

-(NSInteger)columnForList:(HMGridChartView *)list
{
    return _columnTitleArray.count;
}

-(UIColor*)listChart:(HMGridChartView *)list textColorForRow:(NSInteger)row column:(NSInteger)column
{
    if (row == 0)
    {
        return [UIColor whiteColor];
    }
    return [UIColor commonGrayTextColor];
}

//-(CGSize)listChart:(ListChartView *)list itemSizeForRow:(NSInteger)row column:(NSInteger)column
//{
//    return CGSizeMake(100.0f, 60.0f);
//}

-(NSString*)listChart:(HMGridChartView *)list textForRow:(NSInteger)row column:(NSInteger)column
{
    if (row == 0)
    {
        IF_T_FF(row, column, 0, column){return [_columnTitleArray objectAtIndex:column];}
    }
    else
    {
        switch (column) {
            case 0:
                IF_T_FF(row, column, row, 0){return [_rowTitleArray objectAtIndex:row - 1];}
                break;
 
            case 1:
                IF_T_FF(row, column, row, 1){return [_resultArray objectAtIndex:row - 1];}
                break;
                
            case 2:
                IF_T_FF(row, column, row, 2){return [_unitArray objectAtIndex:row - 1];}
                break;
                
            case 3:
                IF_T_FF(row, column, row, 3){return [_referenceValueArray objectAtIndex:row - 1];}
                break;
                
            case 4:
                IF_T_FF(row, column, row, 4){return [_flagArray objectAtIndex:row - 1];}
                break;
            default:
                break;
        }
        
    }
    
    return @"";
}
-(UIColor*)listChart:(HMGridChartView *)list backgroundColorForRow:(NSInteger)row column:(NSInteger)column
{
    if (row == 0)
    {
        return [UIColor mainThemeColor];
    }
    return nil;
}

- (CGSize)listChart:(HMGridChartView*)list itemSizeForRow:(NSInteger)row column:(NSInteger)column
{
    float width = (self.frame.size.width-25)/5;
//    if (column == 0) {
//        return CGSizeMake(columnW * 1.5, 45);
//    }
    return CGSizeMake(width, 45);
}

@end


//项目显示
@interface HMAssistDetailItemView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *valueLineView;
@end

@implementation HMAssistDetailItemView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setFont:[UIFont font_30]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setBackgroundColor:[UIColor mainThemeColor]];
        [_titleLabel showRightLine];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.left.top.bottom.equalTo(self);
        }];
        
        _valueLabel = [UILabel new];
        [self addSubview:_valueLabel];
        [_valueLabel setNumberOfLines:0];
        [_valueLabel setFont:[UIFont font_30]];
        [_valueLabel setTextColor:[UIColor commonGrayTextColor]];
        [_valueLabel setBackgroundColor:[UIColor whiteColor]];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right);
            make.top.bottom.right.equalTo(self);
        }];
        
        _lineView = [UIView new];
        [self addSubview:_lineView];
        [_lineView setBackgroundColor:[UIColor whiteColor]];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_titleLabel);
            make.height.mas_equalTo(@1);
        }];
        
        _valueLineView = [UIView new];
        [self addSubview:_valueLineView];
        [_valueLineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [_valueLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_valueLabel);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

@end

@interface HMAssistDetailItemTableViewCell ()

@property (nonatomic, strong) UIView *gridView;
@property (nonatomic, strong) HMAssistDetailItemView *abnormalView;
@property (nonatomic, strong) HMAssistDetailItemView *abstractView;
@property (nonatomic, strong) HMAssistDetailItemView *examineView;
@property (nonatomic, strong) HMAssistDetailItemView *resultView;
@end

@implementation HMAssistDetailItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.gridView = [UIView new];
        [self.contentView addSubview:self.gridView];
        [self.gridView setBackgroundColor:[UIColor whiteColor]];
        [self.gridView.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [self.gridView.layer setBorderWidth:1.0f];
        [self.gridView.layer setCornerRadius:5.0f];
        [self.gridView.layer setMasksToBounds:YES];
        [self.gridView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
        }];
        
        _abnormalView = [[HMAssistDetailItemView alloc] init];
        [self.gridView addSubview:_abnormalView];
        [_abnormalView.titleLabel setText:@"异常"];
        [_abnormalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.gridView);
            make.height.mas_equalTo(@45);
        }];

        _abstractView = [[HMAssistDetailItemView alloc] init];
        [self.gridView addSubview:_abstractView];
        [_abstractView.titleLabel setText:@"病情摘要"];
        [_abstractView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_abnormalView.mas_bottom);
            make.left.right.equalTo(_abnormalView);
            make.height.mas_equalTo(@45);
        }];
        
        _examineView = [[HMAssistDetailItemView alloc] init];
        [self.gridView addSubview:_examineView];
        [_examineView.titleLabel setText:@"检查所见"];
        [_examineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_abstractView.mas_bottom);
            make.left.right.equalTo(_abnormalView);
            make.height.mas_equalTo(@45);
        }];
        
        _resultView = [[HMAssistDetailItemView alloc] init];
        [self.gridView addSubview:_resultView];
        [_resultView.titleLabel setText:@"检查结果"];
        [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_examineView.mas_bottom);
            make.left.right.equalTo(_abnormalView);
            make.height.mas_equalTo(@45);
        }];
        
    }
    return self;
}

- (void)setCheckIteminsepecJsonDetail:(CheckIteminsepecJsonDetailModel *)model
{
    // 0-异常   其他-否
    if ([model.isAbnormal isEqualToString:@"0"]) {
        [_abnormalView.valueLabel setText:@"是"];
    }
    else{
        [_abnormalView.valueLabel setText:@"否"];
    }
    
    if (!kStringIsEmpty(model.illRemark)) {
        [_abstractView.valueLabel setText:[NSString stringWithFormat:@"%@",model.illRemark]];
        
        //更新布局
        CGFloat abstractViewHeight = [self textHeight:model.illRemark] + 7;
        if (abstractViewHeight > 45) {
            [_abstractView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(abstractViewHeight);
            }];
        }
    }
    
    if (!kStringIsEmpty(model.examine)) {
        [_examineView.valueLabel setText:[NSString stringWithFormat:@"%@",model.examine]];
        
        //更新布局
        CGFloat examineViewHeight = [self textHeight:model.examine] + 7;
        if (examineViewHeight > 45) {
            [_examineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(examineViewHeight);
            }];
        }
    }
    
    if (!kStringIsEmpty(model.results)) {
        [_resultView.valueLabel setText:[NSString stringWithFormat:@"%@",model.results]];
        
        //更新布局
        CGFloat resultViewHeight = [self textHeight:model.results] + 7;
        if (resultViewHeight > 45) {
            [_resultView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(resultViewHeight);
            }];
        }
    }
}

//计算高度
- (CGFloat)textHeight:(NSString *)text
{
    CGFloat textHeight = [text heightSystemFont:[UIFont font_30] width:kScreenWidth-25-100];
    return textHeight;
}

//cell高度
+ (CGFloat)cellHegith:(CheckIteminsepecJsonDetailModel *)model
{
    CGFloat result = 45 + 20;
    
    CGFloat abstractViewHeight = [HMAssistDetailItemTableViewCell textHeight:model.illRemark] + 7;
    if (abstractViewHeight > 45) {
        result += abstractViewHeight;
    }
    else{
        result += 45;
    }

    CGFloat examineViewHeight = [HMAssistDetailItemTableViewCell textHeight:model.examine] + 7;
    if (examineViewHeight > 45){
        result += examineViewHeight;
    }
    else{
        result += 45;
    }

    CGFloat resultViewHeight = [HMAssistDetailItemTableViewCell textHeight:model.results] + 7;
    if (resultViewHeight > 45) {
        result += resultViewHeight;
    }
    else{
        result += 45;
    }

    return result;
}

//计算高度
+ (CGFloat)textHeight:(NSString *)text
{
    CGFloat textHeight = [text heightSystemFont:[UIFont font_30] width:kScreenWidth-25-100];
    return textHeight;
}
@end
