//
//  HMDoctorConcernMainTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMDoctorConcernMainTableViewCell.h"
#import "UIColor+Hex.h"
#import "HMConcernModel.h"
#import "NSDate+MsgManager.h"
#import "HMNewDoctorCareImageCollectionViewCell.h"
#import "HMConcernHealthEditionView.h"
#import "HealthEducationItem.h"
#define MAX_W    (200 *(ScreenWidth / 375))           // 最大宽度

@interface HMDoctorConcernMainTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *receiveTimeLb;   //接收时间
@property (strong, nonatomic) UIView *cardView;      //整个卡片View
@property (nonatomic, strong) UIView *headView;     //头部标题View
@property (nonatomic, strong) UIView *line1;        //分割线

@property (nonatomic, strong) UILabel *memberLb;    //患者

@property (nonatomic, strong) UILabel *contentLb;   //内容

@property (nonatomic, strong) UIButton *resendBtn;  //再发一条（按人）
@property (nonatomic, strong) UIButton *resendToGroupBtn;  //再发一条（按群）
@property (nonatomic, strong) UILabel *resendLb;   //再发一条

@property (nonatomic, retain) UIButton* voiceControl;                //语音view

@property (nonatomic, retain) UILabel* lbDuration;
   //语音时间
@property (nonatomic) BOOL isHaveVoice;      //是否有语音
@property (nonatomic) BOOL isHaveText;      //是否有文字
@property (nonatomic) BOOL isHaveImage;      //是否有图片
@property (nonatomic) BOOL isHaveEdition;      //是否有宣教


@property (nonatomic, copy) ConcernClickBlock block;
@property (nonatomic, copy) NSString *memberString;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) HMConcernHealthEditionView *editionView;
@property (nonatomic, strong) HMConcernModel *model;
@property (nonatomic, copy) ConcernImageClickBlock imageBlock;
@property (nonatomic, copy) ConcernEditionClickBlock editionBlock;
@property (nonatomic, strong) MASConstraint *constraintBubbleWidth;

@end

@implementation HMDoctorConcernMainTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.cardView];
        [self.cardView addSubview:self.headView];
        [self.cardView addSubview:self.line1];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.resendBtn];
        [self.headView addSubview:self.memberLb];
        
        [self.cardView addSubview:self.voiceControl];
        [self.voiceControl addSubview:self.ivVoice];
        [self.voiceControl addSubview:self.lbDuration];
        
        [self.cardView addSubview:self.collectionView];
        [self.cardView addSubview:self.editionView];
        [self.cardView addSubview:self.resendLb];
        [self.cardView addSubview:self.resendToGroupBtn];
        
        
//        [self configElements];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -private method
- (void)configElements {
    [self.receiveTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
        make.height.equalTo(@20);
    }];
    
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.cardView);
    }];
    
    [self.memberLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView).offset(10);
        make.left.equalTo(self.headView).offset(15);
        make.right.lessThanOrEqualTo(self.headView).offset(-15);
        make.bottom.equalTo(self.headView).offset(-10);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cardView);
        make.top.equalTo(self.headView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    self.lastView = self.line1;
    
    if (self.isHaveText) {
        //有文字
        [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.mas_bottom).offset(15);
            make.left.equalTo(self.cardView).offset(15);
            make.right.equalTo(self.cardView).offset(-15);
        }];
        self.lastView = self.contentLb;
    }
    
    if (self.isHaveVoice) {
        [self.voiceControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView).offset(15);
            self.constraintBubbleWidth = make.width.equalTo(@50);
            make.height.equalTo(@44);
            make.top.equalTo(self.lastView.mas_bottom).offset(15);
        }];
        
        [_ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_voiceControl).with.offset(10);
            make.centerY.equalTo(_voiceControl);
        }];
        
        [_lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_voiceControl);
            make.right.equalTo(_voiceControl.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        self.lastView = self.voiceControl;
        
    }
    
    if (self.isHaveImage) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView).offset(15);
            make.right.equalTo(self.cardView).offset(-15);
            make.top.equalTo(self.lastView.mas_bottom).offset(10);
            make.height.equalTo(@70);
        }];
        
        self.lastView = self.collectionView;
    }
    
    if (self.isHaveEdition) {
        [self.editionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView).offset(15);
            make.right.equalTo(self.cardView).offset(-15);
            make.top.equalTo(self.lastView.mas_bottom).offset(10);
            make.height.equalTo(@50);
        }];
        
        self.lastView = self.editionView;
    }
    
    [self.resendLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.top.equalTo(self.lastView.mas_bottom).offset(15);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];
    
    [self.resendToGroupBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).offset(-15);
        make.centerY.equalTo(self.resendLb);
        make.height.equalTo(@23);
        make.width.equalTo(@66);
    }];
    
    [self.resendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resendToGroupBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.resendLb);
        make.height.equalTo(@23);
        make.width.equalTo(@66);
    }];
    
}
- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

- (NSString *)configPatientInfoWithModel:(HMConcernModel *)model {
    self.memberString = @"";
    __weak typeof(self) weakSelf = self;
    [model.userRemarks enumerateObjectsUsingBlock:^(HMConcernPatientModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!idx) {
            strongSelf.memberString = [strongSelf.memberString stringByAppendingString:obj.userName];
        }
        else {
            strongSelf.memberString = [strongSelf.memberString stringByAppendingString:[NSString stringWithFormat:@",%@",obj.userName]];
        }

    }];
    return self.memberString;
}


- (NSString *)configTeamInfoWithModel:(HMConcernModel *)model {
    __block NSString *tempString = @"";
    [model.teamRemarks enumerateObjectsUsingBlock:^(HMConcernTeamModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!idx) {
            tempString = [tempString stringByAppendingString:obj.teamName];
        }
        else {
            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@",%@",obj.teamName]];
        }
        
    }];
    return tempString;
}

- (long long)acquireTimeWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return [date timeIntervalSince1970];
}
#pragma mark - event Response
- (void)resendClick:(UIButton *)sender {
    self.block(sender.tag,NO);
}

- (void)palyVoice {
    self.block(-1,YES);
}

- (void)editToClick {
    if (self.editionBlock) {
        self.editionBlock(self.model.classId);
    }
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.careImg.count;
}

//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMNewDoctorCareImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMNewDoctorCareImageCollectionViewCell at_identifier] forIndexPath:indexPath];
    NSString *imageUrlString = self.model.careImgDesc[indexPath.row];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"im_back"]];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(55, 55);
}

//定义每个UICollectionView 的 margin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageBlock) {
        self.imageBlock(indexPath);
    }
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(HMConcernModel *)model {
    self.model = model;
    
    self.isHaveImage = model.careImg.count;
    self.isHaveEdition = model.classId.length && model.classId.integerValue;
    [self.collectionView setHidden:!self.isHaveImage];
    [self.editionView setHidden:!self.isHaveEdition];
    
    if (model.voice && model.voice.length) {
        self.isHaveVoice = YES;
        [self.voiceControl setHidden:NO];
    }
    else {
        self.isHaveVoice = NO;
        [self.voiceControl setHidden:YES];
    }
    if (model.careCon && model.careCon.length) {
        self.isHaveText = YES;
        [self.contentLb setHidden:NO];
    }
    else {
        self.isHaveText = NO;
        [self.contentLb setHidden:YES];
    }
    if (model.userRemarks.count) {
        [self.memberLb setText:[NSString stringWithFormat:@"%ld位用户\n%@",model.userRemarks.count,[self configPatientInfoWithModel:model]]];
    }
    if (model.teamRemarks.count) {
        [self.memberLb setText:[NSString stringWithFormat:@"%ld个群组\n%@",model.teamRemarks.count,[self configTeamInfoWithModel:model]]];

    }
    [self.contentLb setText:model.careCon];
    // 处理后的时间
    if ([self acquireTimeWithString:model.careTime] != 0)
    {
        NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:[self acquireTimeWithString:model.careTime]*1000 appendMinute:NO];
        [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    }
    
    if (model.classId.length && model.classId.integerValue) {
        HealthEducationItem *temp = [HealthEducationItem new];
        temp.classId = model.classId.integerValue;
        temp.title = model.classTitle;
        temp.paper = model.classPaper;
        
        [self.editionView fillDataWithModel:temp];
    }
    [self.collectionView reloadData];
    NSString *lenth = model.voiceLength;
    if (lenth.floatValue > 0) {
        NSInteger intger = MAX(lenth.integerValue, 1) ;
        [self.lbDuration setText:[NSString stringWithFormat:@"%ld'",(long)intger]];
    }
    else {
        [self.lbDuration setText:@""];
    }

    [self configElements];
    
    NSInteger bubbleWidth = lenth.integerValue * 5 + 80;
    CGFloat maxWidth = MAX_W;
    self.constraintBubbleWidth.offset = MIN(bubbleWidth, maxWidth);
    [self.voiceControl layoutIfNeeded];
}

- (void)concernBlock:(ConcernClickBlock)block {
    self.block = block;
}

- (void)imageClick:(ConcernImageClickBlock)block {
    self.imageBlock = block;
}

- (void)editionClick:(ConcernEditionClickBlock)block {
    self.editionBlock = block;
}
#pragma mark - init UI

- (UILabel *)receiveTimeLb
{
    if (!_receiveTimeLb) {
        _receiveTimeLb = [self getLebalWithTitel:@" 12-12 18:13 " font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
        [_receiveTimeLb.layer setCornerRadius:3];
        [_receiveTimeLb setBackgroundColor:[UIColor colorWithHexString:@"cecece"]];
        [_receiveTimeLb setClipsToBounds:YES];
        
    }
    return _receiveTimeLb;
}

- (UIView *)line1
{
    if (!_line1) {
        _line1 = [UIView new];
        [_line1 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line1;
}

- (UIButton *)resendBtn
{
    if (!_resendBtn) {
        _resendBtn = [UIButton new];
        [_resendBtn setTitle:@"按人发送" forState:UIControlStateNormal];
        [_resendBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_resendBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_resendBtn setTag:0];
        [_resendBtn setBackgroundColor:[UIColor colorWithHexString:@"f6f6f6"]];
        [_resendBtn.layer setBorderColor:[UIColor colorWithHex:0xdfdfdf].CGColor];
        [_resendBtn.layer setBorderWidth:0.5];
        [_resendBtn.layer setCornerRadius:12];
        [_resendBtn addTarget:self action:@selector(resendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendBtn;
}
- (UIButton *)resendToGroupBtn
{
    if (!_resendToGroupBtn) {
        _resendToGroupBtn = [UIButton new];
        [_resendToGroupBtn setTitle:@"按组发送" forState:UIControlStateNormal];
        [_resendToGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_resendToGroupBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_resendToGroupBtn setTag:1];
        [_resendToGroupBtn setBackgroundColor:[UIColor colorWithHexString:@"f6f6f6"]];
        [_resendToGroupBtn.layer setBorderColor:[UIColor colorWithHex:0xdfdfdf].CGColor];
        [_resendToGroupBtn.layer setBorderWidth:0.5];
        [_resendToGroupBtn.layer setCornerRadius:12];
        [_resendToGroupBtn addTarget:self action:@selector(resendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendToGroupBtn;
}

- (UILabel *)memberLb
{
    if (!_memberLb) {
        _memberLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"999999"]];
        [_memberLb setNumberOfLines:0];
    }
    return _memberLb;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"参与者：李明" font:[UIFont systemFontOfSize:15] textColor:[UIColor commonBlackTextColor_333333]];
        [_contentLb setNumberOfLines:0];
    }
    return _contentLb;
}

- (UILabel *)resendLb
{
    if (!_resendLb) {
        _resendLb = [self getLebalWithTitel:@"再发一条：" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _resendLb;
}

- (UIView *)cardView
{
    if (!_cardView) {
        _cardView = [UIView new];
        [_cardView setBackgroundColor:[UIColor whiteColor]];
        [_cardView.layer setCornerRadius:5];
        [_cardView.layer setBorderWidth:0.5];
        [_cardView.layer setBorderColor:[UIColor colorWithHex:0xdfdfdf].CGColor];
        [_cardView setClipsToBounds:YES];
    }
    return _cardView;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [UIView new];
        [_headView setBackgroundColor:[UIColor colorWithHex:0xf6f6f6]];
    }
    return _headView;
}

- (UIButton *)voiceControl {
    if (!_voiceControl) {
        _voiceControl = [UIButton new];
        [_voiceControl.layer setCornerRadius:10];
        [_voiceControl setClipsToBounds:YES];
        [_voiceControl setBackgroundColor:[UIColor mainThemeColor]];
        [_voiceControl addTarget:self action:@selector(palyVoice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceControl;
}

- (UIImageView *)ivVoice {
    if (!_ivVoice) {
        _ivVoice = [UIImageView new];
        [_ivVoice setImage:[UIImage imageNamed:@"icon_voice_1"]];
        
        [_ivVoice setAnimationImages:@[[UIImage imageNamed:@"icon_voice_3"],
                                       [UIImage imageNamed:@"icon_voice_2"],
                                       [UIImage imageNamed:@"icon_voice_1"],
                                       ]];
        
        _ivVoice.animationDuration = 1.5;
        _ivVoice.animationRepeatCount = 0;
    }
    return _ivVoice;
}

- (UILabel *)lbDuration {
    if (!_lbDuration) {
        _lbDuration = [UILabel new];
        [_lbDuration setFont:[UIFont systemFontOfSize:14]];
        [_lbDuration setTextColor:[UIColor whiteColor]];
        [_lbDuration setTextAlignment:NSTextAlignmentCenter];
    }
    return _lbDuration;
}

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
        [_collectionView registerClass:[HMNewDoctorCareImageCollectionViewCell class] forCellWithReuseIdentifier:[HMNewDoctorCareImageCollectionViewCell at_identifier]];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _collectionView;
}

- (HMConcernHealthEditionView *)editionView {
    if (!_editionView) {
        _editionView = [HMConcernHealthEditionView new
                        ];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editToClick)];
        [_editionView addGestureRecognizer:tap];
    }
    return _editionView;
}
@end
