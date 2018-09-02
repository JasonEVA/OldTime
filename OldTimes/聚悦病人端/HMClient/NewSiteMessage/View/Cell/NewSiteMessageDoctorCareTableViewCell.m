//
//  NewSiteMessageDoctorCareTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/2/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageDoctorCareTableViewCell.h"
#import "NewSiteMessageDoctorConcernModel.h"
#import "HMNewDoctorCareImageCollectionViewCell.h"
#import "HMConcernHealthEditionView.h"
#import "HealthEducationItem.h"

#define MAX_W    (200 *(ScreenWidth / 375))           // 最大宽度

@interface NewSiteMessageDoctorCareTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIButton *voiceBtn;                //语音view
@property (nonatomic, strong) UILabel *voiceLenthLb;

@property (nonatomic, copy) playVoice playVoiceBlock;
@property (nonatomic, strong) LeftTriangle *voiceLeftTri; // 语音尖角
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic) BOOL isHaveVoice;      //是否有语音
@property (nonatomic) BOOL isHaveText;      //是否有文字
@property (nonatomic) BOOL isHaveImage;      //是否有图片
@property (nonatomic) BOOL isHaveEdition;      //是否有宣教
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HMConcernHealthEditionView *editionView;
@property (nonatomic, strong) UILabel *doctorNameLb;
@property (nonatomic, strong) NewSiteMessageDoctorConcernModel *model;
@property (nonatomic, copy) ConcernImageClickBlock imageBlock;
@property (nonatomic, strong) MASConstraint *constraintBubbleWidth;

@end
@implementation NewSiteMessageDoctorCareTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nikeNameLb.mas_bottom).offset(2);
            make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(15);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-50);
        }];
        UILabel *titelLb = [UILabel new];
        [titelLb setText:@"来自医生的关怀"];
        [titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titelLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:16]];
        [self.cardView addSubview:self.nameLb];
        // 下划线
//        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"来自医生的关怀" attributes:attribtDic];
//        
//        //赋值
//        titelLb.attributedText = attribtStr;
        
        [self.cardView addSubview:titelLb];
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.cardView);
            make.top.equalTo(self.cardView).offset(15);
        }];
        
        self.nameLb = [UILabel new];
        UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
        
        [self.nameLb setText:[NSString stringWithFormat:@"亲爱的%@：",user.userName]];
        [self.nameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        [self.nameLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:15]];
        [self.cardView addSubview:self.nameLb];
        
        self.editionView = [HMConcernHealthEditionView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editionClick)];
        [self.editionView addGestureRecognizer:tap];
        
        [self.cardView addSubview:self.editionView];
        [self.cardView addSubview:self.collectionView];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.voiceBtn];
        [self.cardView addSubview:self.doctorNameLb];


    }
    return self;
}

- (void)editionClick {
    HealthEducationItem* educationModel = [HealthEducationItem new];
    educationModel.classId = self.model.classId.integerValue;
    //跳转到宣教详情
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
}

- (void)configElements {
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(10);
        make.top.equalTo(self.cardView).offset(50);
    }];
    self.lastView = self.nameLb;
    if (self.isHaveText) {
        [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView).offset(10);
            make.top.equalTo(self.lastView.mas_bottom).offset(3);
            make.right.lessThanOrEqualTo(self.cardView).offset(-15);
        }];
        self.lastView = self.contentLb;

    }
    
    if (self.isHaveVoice) {
        [self.voiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            self.constraintBubbleWidth = make.width.equalTo(@50);
            make.height.equalTo(@42);
            make.top.equalTo(self.lastView.mas_bottom).offset(5);
            make.left.equalTo(self.cardView).offset(10);
        }];
        
        [self.voiceBtn addSubview:self.voiceLenthLb];
        [self.voiceLenthLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.voiceBtn);
            make.right.equalTo(self.voiceBtn).offset(-10);
        }];
        
        self.lastView = self.voiceBtn;

    }
    
    if (self.isHaveImage) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView).offset(10);
            make.top.equalTo(self.lastView.mas_bottom).offset(5);
            make.right.equalTo(self.cardView).offset(-10);
            make.height.equalTo(@70);
        }];
        self.lastView = self.collectionView;

    }
    
    if (self.isHaveEdition) {
        
        [self.editionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.mas_bottom).offset(5);
            make.left.equalTo(self.cardView).offset(10);
            make.height.equalTo(@50);
            make.right.equalTo(self.cardView).offset(-10);
        }];
        self.lastView = self.editionView;

    }
    
    [self.doctorNameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).offset(-10);
        make.top.equalTo(self.lastView.mas_bottom).offset(10);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.cardView);
    }];
    
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageDoctorConcernModel *tempModel  = [NewSiteMessageDoctorConcernModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    self.model = tempModel;
    if (tempModel.msg && tempModel.msg.length) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tempModel.msg];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3.0];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tempModel.msg length])];
        [self.contentLb setAttributedText:attributedString1];
        [self.contentLb sizeToFit];
    }
    
    //设置行间距后适配高度显示
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    NSURL *urlHead = avatarURL(avatarType_80,tempModel.staffUserId);
    [self.imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    NSDictionary *dict = model.doThing.mj_JSONObject;
    [self.nikeNameLb setText:dict[@"nickName"]];
    
    [self.cardView setBackgroundColor:[UIColor whiteColor]];
    [self.voiceLeftTri removeFromSuperview];
    self.isHaveText = tempModel.msg && tempModel.msg.length;
    self.isHaveVoice = tempModel.voice.length;
    self.isHaveEdition = tempModel.classId.length && tempModel.classId.integerValue;
    self.isHaveImage = tempModel.careImg.count;
    [self.editionView setHidden:!self.isHaveEdition];
    [self.collectionView setHidden:!self.isHaveImage];
    [self.contentLb setHidden:!self.isHaveText];
    [self.voiceBtn setHidden:!self.isHaveVoice];
    [self.collectionView reloadData];
    
    if (tempModel.classId.length && tempModel.classId.integerValue) {
        HealthEducationItem *temp = [HealthEducationItem new];
        temp.classId = tempModel.classId.integerValue;
        temp.title = tempModel.classTitle;
        temp.paper = tempModel.classPaper;
        
        [self.editionView fillDataWithModel:temp];
    }
    NSString *lenth = tempModel.voiceLength;
    if (lenth.floatValue > 0) {
        NSInteger intger = MAX(lenth.integerValue, 1) ;
        [self.voiceLenthLb setText:[NSString stringWithFormat:@"%ld'",(long)intger]];
    }
    else {
        [self.voiceLenthLb setText:@""];
    }


    [self configElements];
    
    NSInteger bubbleWidth = lenth.integerValue * 5 + 80;
    CGFloat maxWidth = MAX_W;
    self.constraintBubbleWidth.offset = MIN(bubbleWidth, maxWidth);
    [self.voiceBtn layoutIfNeeded];
}
- (void)playVoiceClick {
    if (self.playVoiceBlock) {
        self.playVoiceBlock();
    }
}

- (void)playVoiceClickBlock:(playVoice)block {
    self.playVoiceBlock = block;
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
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.careImgDesc[indexPath.row]] placeholderImage:[UIImage imageNamed:@"im_back"]];
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
    return 5;
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
        self.imageBlock(self.model.careImg,indexPath);
    }
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)imageClick:(ConcernImageClickBlock)block {
    self.imageBlock = block;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:0];
        _contentLb.preferredMaxLayoutWidth = W_MAX;
        [_contentLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:15]];

    }
    return _contentLb;
}
- (UILabel *)doctorNameLb
{
    if (!_doctorNameLb) {
        _doctorNameLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];

    }
    return _doctorNameLb;
}
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 42)];
        [_voiceBtn.layer setCornerRadius:10];
        [_voiceBtn setClipsToBounds:YES];
        [_voiceBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_voiceBtn addSubview:self.voiceImages];
        [_voiceBtn addTarget:self action:@selector(playVoiceClick) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceImages mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_voiceBtn).with.offset(10);
            make.centerY.equalTo(_voiceBtn);
        }];
    }
    return _voiceBtn;
}

- (UIImageView *)voiceImages {
    if (!_voiceImages) {
        _voiceImages = [UIImageView new];
        [_voiceImages setImage:[UIImage imageNamed:@"icon_voice_1"]];
        
        [_voiceImages setAnimationImages:@[[UIImage imageNamed:@"icon_voice_3"],
                                       [UIImage imageNamed:@"icon_voice_2"],
                                       [UIImage imageNamed:@"icon_voice_1"],
                                       ]];
        
        _voiceImages.animationDuration = 1.5;
        _voiceImages.animationRepeatCount = 0;
    }
    return _voiceImages;
}

- (LeftTriangle *)voiceLeftTri
{
    if (!_voiceLeftTri)
    {
        _voiceLeftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor mainThemeColor] colorBorderColor:[UIColor mainThemeColor]];
    }
    return _voiceLeftTri;
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
- (UILabel *)voiceLenthLb {
    if (!_voiceLenthLb) {
        _voiceLenthLb = [UILabel new];
        [_voiceLenthLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_voiceLenthLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _voiceLenthLb;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
