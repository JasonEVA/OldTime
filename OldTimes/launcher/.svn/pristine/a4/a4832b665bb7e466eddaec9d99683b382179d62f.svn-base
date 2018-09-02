//
//  NewApplyCommentTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyCommentTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "AvatarUtil.h"
#import "NSDate+DateTools.h"
#import "MyDefine.h"
#import "AppApprovalModel.h"
#import "AppTaskModel.h"
#import "Category.h"
#import <MJExtension/MJExtension.h>
#import "NSBundle+Language.h"

@interface NewApplyCommentTableViewCell()
@property (nonatomic) CellKind cellkind;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIImageView *imgViewHead;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIImageView *imgViewAttachment;
//@property (nonatomic, strong) ApplicationCommentModel *model;
@end

@implementation NewApplyCommentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellKind:(CellKind)kind
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.cellkind = kind;
        [self.contentView addSubview:self.imgViewHead];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblContent];
        [self.contentView addSubview:self.lblTime];
        if (self.cellkind == CellKind_Attachement)
        {
            [self.contentView addSubview:self.imgViewAttachment];
        }
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)setframes
{
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@40);
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(5);
        make.top.equalTo(self.imgViewHead);
        make.height.equalTo(@20);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.top.bottom.equalTo(self.lblName);
    }];
    
    if (self.cellkind == CellKind_Comment || self.cellkind == CellKind_System)
    {
        [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.lblName);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    else if (self.cellkind == CellKind_Attachement)
    {
        [self.imgViewAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.lblName);
            make.height.width.equalTo(@20);
        }];
    
        [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.imgViewAttachment.mas_right).offset(2);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
}

- (void)handleAtUserText:(NSString *)text withAtWho:(NSArray *)atWho{
	if (!atWho || atWho.count == 0) {
		return;
	}
	
	__block NSString *finalText = [text copy];
	NSMutableArray *names = [NSMutableArray arrayWithCapacity:atWho.count];
	[atWho enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull atWhoDic, NSUInteger idx, BOOL * _Nonnull stop) {
		[names addObject:atWhoDic[@"name"]];

		NSRange range = [finalText rangeOfString:atWhoDic[@"id"] options:NSLiteralSearch];
		if (range.location != NSNotFound) {
			finalText = [finalText stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:@""];
		}
		
	}];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalText];
	[names enumerateObjectsUsingBlock:^(NSString *  _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {

		finalText  = [finalText stringByRemovingPercentEncoding];
		NSError *error;
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:name
																			   options:0
																				 error:&error];
		NSArray *matches = [regex matchesInString:finalText options:0 range:NSMakeRange(0, [finalText length])];
		if (error) {
			NSLog(@"===%@===", error.localizedDescription);
			
		} else {
			for (NSTextCheckingResult *textResult in matches) {
				if (textResult.range.location != NSNotFound) {
					[attributedString setAttributes:@{NSFontAttributeName: [UIFont mtc_font_30], NSForegroundColorAttributeName: [UIColor themeBlue]} range:NSMakeRange(textResult.range.location,textResult.range.length)];
				}
			}			
		}

	}];

	self.lblContent.attributedText = attributedString;
	
}

- (void)dataWithModel:(ApplicationCommentModel *)model
{
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_80, model.createUser) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    self.lblName.text = model.createUserName;
    self.lblTime.text = [model.createTime timeAgoSinceNow];
    LanguageEnum currentLanguage = [[UnifiedUserInfoManager share] getLanguageUserSetting];
    
    switch (currentLanguage) {
        case language_japanese: [NSBundle setLanguage:@"ja"];break;
        case language_chinese:  [NSBundle setLanguage:@"zh-Hans"];break;
        case language_english:  [NSBundle setLanguage:@"en"];break;
        default:break;
    }
    self.lblContent.text = model.content;
    
    if (model.isComment) {
        self.lblContent.textColor = [UIColor blackColor];
		
		if ([model.content rangeOfString:@"@"].location != NSNotFound) {
			[self handleAtUserText:model.content withAtWho: model.atWho];
		}
		
    }
    
    if (model.isDelete) {
        self.lblContent.text = LOCAL(COMMENTDELETED);
        self.imgViewAttachment.hidden = YES;
        [self.lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.lblName);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    
    if (![model.transType length]) {
        return;
    }
    
    if (model.isComment)
    {
        [self.lblContent setTextColor:[UIColor blackColor]];
        self.lblContent.text = [self stringTransType:model.transType rmData:model.rmData];
    }
    else
    {
        [self.lblContent setTextColor:[UIColor themeBlue]];
        if ([model.transType isEqualToString:@"taskEditStatus"] ||
            [model.transType isEqualToString:@"taskEditStatusDefinite"] ||
            [model.transType isEqualToString:@"approvePut"] ||
            [model.transType isEqualToString:@"approvePass"] ||
            [model.transType isEqualToString:@"taskV2ChangeStatus"] ||
            [model.transType isEqualToString:@"taskV2Update"] ||
            [model.transType isEqualToString:@"createTaskV2"] ||
			[model.transType isEqualToString:@"meetingAttend"] ||
			[model.transType isEqualToString:@"meetingRefuseAttend"]
			)
        {
            self.lblContent.text = [self stringTransType:model.transType rmData:model.rmData];
        }
        else if ([model.transType isEqualToString:@"approveTranspondDefinite"])
        {
            NSString *string = [self stringTransType:model.transType rmData:model.rmData];
            AppApprovalModel *modelrmData = [AppApprovalModel mj_objectWithKeyValues:model.rmData];
            NSRange range1 = [string rangeOfString:modelrmData.content];
            NSRange range2 = [string rangeOfString:modelrmData.reason];
            NSMutableAttributedString *strneed = [[NSMutableAttributedString alloc] initWithString:string];
            [strneed addAttribute:NSForegroundColorAttributeName value:[UIColor themeBlue] range:NSMakeRange(0, strneed.length)];
            [strneed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
            [strneed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2];
            [self.lblContent setAttributedText:strneed];
        }
        else if ([model.transType isEqualToString:@"approveBackDefinite"] || [model.transType isEqualToString:@"approveRefuseDefinite"] || [model.transType isEqualToString:@"meetingCancel"])
        {
            NSString *string = [self stringTransType:model.transType rmData:model.rmData];
            AppApprovalModel *modelrmData = [AppApprovalModel mj_objectWithKeyValues:model.rmData];;
            NSRange range2 = [string rangeOfString:modelrmData.reason];
            NSMutableAttributedString *strneed = [[NSMutableAttributedString alloc] initWithString:string];
            [strneed addAttribute:NSForegroundColorAttributeName value:[UIColor themeBlue] range:NSMakeRange(0, strneed.length)];
            [strneed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2];
            [self.lblContent setAttributedText:strneed];
        }
        else
        {
            [self.lblContent setTextColor:[UIColor blackColor]];
            self.lblContent.text = [self stringTransType:model.transType rmData:model.rmData];
        }
    }
}

- (CGFloat)CalculcateWithHeight:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.frame.size.width - 13 - 15 - 5 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
    return size.height;
}

- (CGFloat)getHeight
{
    if (![self.lblContent.text isEqualToString:@""])
    {
        CGSize size = [self.lblContent.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 13 - 15 - 5 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
        if (size.height + 20 + 15 > 64)
        {
            return size.height + 20 + 20;
        }
        else
        {
            return 64;
        }
    }
    else
    {
        return 64;
    }
}

+ (CGFloat)cellHeightWithCommentModel:(ApplicationCommentModel *)model {
	if (![model.content isEqualToString:@""])
	{
		CGSize size = [model.content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 13 - 15 - 5 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
		if (size.height + 20 + 15 > 64)
		{
			return size.height + 20 + 15;
		}
		else
		{
			return 64;
		}
	}
	else
	{
		return 64;
	}
}

- (NSString *)stringTransType:(NSString *)transType rmData:(NSString *)rmData {
    if ([transType isEqualToString:@"meetingAttend"]) {
        return LOCAL(APPCOMMENT_MEETING_ATTEND);
    }
    else if ([transType isEqualToString:@"meetingRefuseAttend"]) {
        return LOCAL(APPCOMMENT_REFUSE_ATTEND);
	} else if ([transType isEqualToString:@"meetingCancel"]) {
		AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
		return [NSString stringWithFormat:LOCAL(APPCOMMENT_MEETING_CANCEL),model.reason];
	}
    else if ([transType isEqualToString:@"approvePut"])
    {
        //创建审批
        return LOCAL(APPCOMMENT_NEWAPPROVE_CREATE);
    }
    else if ([transType isEqualToString:@"taskEditStatus"] || [transType isEqualToString:@"taskEditStatusDefinite"] || [transType isEqualToString:@"approvePost"])
    {
        //编辑审批
        return LOCAL(APPCOMMENT_NEWAPPROVE_EDIT);
    }
    else if ([transType isEqualToString:@"approveTranspondDefinite"] || [transType isEqualToString:@"approveTranspond"])
    {
        //转交给%@  审批意见：%@
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_NEWAPPROVE_TRANSPONDTO),model.content,model.reason];
    }
    else if ([transType isEqualToString:@"approvePass"])
    {
        //通过审批
        return LOCAL(APPCOMMENT_NEWAPPROVE_PASS);
    }
    else if ([transType isEqualToString:@"approveRefuse"] || [transType isEqualToString:@"approveRefuseDefinite"])
    {
        //拒绝审批
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_NEWAPPROVE_REFUSE),model.reason];
    }
    else if ([transType isEqualToString:@"approveBack"] || [transType isEqualToString:@"approveBackDefinite"])
    {
        //打回审批
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_NEWAPPROVE_BACK),model.reason];
    }
    
    //原来的
    else if ([transType isEqualToString:@"approvePass"]) {
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_APPROVE_PASS), model.title];
    }
    else if ([transType isEqualToString:@"approveBackDefinite"]) {
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_APPROVE_BACK_DEFINITE),model.title ,model.reason];
    }
    else if ([transType isEqualToString:@"approveRefuseDefinite"]) {
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_APPROVE_REFUSE_DEFINITE),model.title, model.reason];
    }
    else if ([transType isEqualToString:@"approveTranspondDefinite"]) {
        AppApprovalModel *model = [AppApprovalModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_APPROVE_TRANSPOND_DEFINITE), model.title, model.reason];
    }
    else if ([transType isEqualToString:@"taskEditStatusDefinite"]) {
        AppTaskModel *model = [AppTaskModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_TASK_EDIT_STATUS_DEFINITE) ,model.stateName];
    }
    //新任务修改状态
    else if ([transType isEqualToString:@"taskV2ChangeStatus"]) {
        AppTaskModel *model = [AppTaskModel mj_objectWithKeyValues:rmData];
        return [NSString stringWithFormat:LOCAL(APPCOMMENT_TASKCHANGESTATUS) ,model.title];
    }
    //新任务修改内容
    else if ([transType isEqualToString:@"taskV2Update"]) {
//        AppTaskModel *model = [AppTaskModel mj_objectWithKeyValues:rmData];
        return LOCAL(APPCOMMENT_TASKUPDATE);
    }
    else if ([transType isEqualToString:@"createTaskV2"]) {
        return LOCAL(APPCOMMENT_CREATETASK);
    }
    return LOCAL(APPCOMMENT_UNKONW_INFO);
}

#pragma mark - init
- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        [_lblName setTextColor:[UIColor themeGray]];
        [_lblName setFont:[UIFont mtc_font_30]];
        [_lblName setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblName;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        [_lblContent setFont:[UIFont mtc_font_30]];
        _lblContent.numberOfLines = 0;
        [_lblContent setTextColor:[UIColor themeBlue]];
        [_lblContent setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblContent;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        [_lblTime setFont:[UIFont mtc_font_24]];
        [_lblTime setTextColor:[UIColor themeGray]];
        [_lblTime setTextAlignment:NSTextAlignmentRight];
    }
    return _lblTime;
}

- (UIImageView *)imgViewHead
{
    if (!_imgViewHead)
    {
        _imgViewHead = [[UIImageView alloc] init];
        _imgViewHead.layer.cornerRadius = 2.0f;
        _imgViewHead.clipsToBounds = YES;
    }
    return _imgViewHead;
}

- (UIImageView *)imgViewAttachment
{
    if (!_imgViewAttachment)
    {
        _imgViewAttachment = [[UIImageView alloc] init];
    }
    return _imgViewAttachment;
}
@end
