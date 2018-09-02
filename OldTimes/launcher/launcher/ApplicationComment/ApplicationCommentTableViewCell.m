//
//  ApplicationCommentTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentTableViewCell.h"
#import "ApplicationCommentModel.h"
#import "UnifiedUserInfoManager.h"
#import <DateTools/DateTools.h>
#import "NSBundle+Language.h"
#import <Masonry/Masonry.h>
#import "Category.h"

#import <MJExtension/MJExtension.h>
#import "AppApprovalModel.h"
#import "AppTaskModel.h"


@interface ApplicationCommentTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ApplicationCommentTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self).offset(10);
            make.width.equalTo(@60);
        }];
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.timeLabel.mas_left).offset(-10);
            make.top.equalTo(self.timeLabel);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(13);
            make.right.equalTo(self.commentLabel.mas_left).offset(-10);
        }];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.textColor = [UIColor minorFontColor];
    self.commentLabel.textColor = [UIColor blackColor];
}

#pragma mark - Interface Method
- (CGFloat)getHeight {
    CGSize nameSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.nameLabel.frame), CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    CGSize commentSize = [self.commentLabel.text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 100 - 85, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    CGSize timeSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.timeLabel.frame), CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    
    NSArray *array = @[@(nameSize.height), @(commentSize.height), @(timeSize.height)];
    NSNumber *maxHeight = [array valueForKeyPath:@"@max.floatValue"];
    
    CGFloat height = [maxHeight floatValue] + 20;
    return height > 44 ? height : 44;
}

- (void)dataWithModel:(ApplicationCommentModel *)model {
    LanguageEnum currentLanguage = [[UnifiedUserInfoManager share] getLanguageUserSetting];
    
    switch (currentLanguage) {
        case language_japanese: [NSBundle setLanguage:@"ja"];break;
        case language_chinese:  [NSBundle setLanguage:@"zh-Hans"];break;
        case language_english:  [NSBundle setLanguage:@"en"];break;
        default:break;
    }
    
    self.timeLabel.text = [model.createTime timeAgoSinceNow];
    self.nameLabel.text = [model.createUserName stringByAppendingString:@":"];
    self.commentLabel.text = model.content;
    
    if (!model.isComment || model.isDelete) {
        self.nameLabel.textColor    = [UIColor themeBlue];
        self.commentLabel.textColor = [UIColor themeBlue];
        
        if (model.isDelete) {
            self.commentLabel.text = LOCAL(COMMENTDELETED);
        }
    }
    
    if (![model.transType length]) {
        return;
    }
    
    self.commentLabel.text = [self stringTransType:model.transType rmData:model.rmData];
}

- (NSString *)stringTransType:(NSString *)transType rmData:(NSString *)rmData {
    if ([transType isEqualToString:@"meetingAttend"]) {
        return LOCAL(APPCOMMENT_MEETING_ATTEND);
    }
    else if ([transType isEqualToString:@"meetingRefuseAttend"]) {
        return LOCAL(APPCOMMENT_REFUSE_ATTEND);
    }
    else if ([transType isEqualToString:@"approvePut"])
    {
        //创建审批
        return LOCAL(APPCOMMENT_NEWAPPROVE_CREATE);
    }
    else if ([transType isEqualToString:@"taskEditStatus"] || [transType isEqualToString:@"taskEditStatusDefinite"])
    {
        //编辑审批
        return LOCAL(APPCOMMENT_NEWAPPROVE_EDIT);
    }
    else if ([transType isEqualToString:@"approveTranspondDefinite"] || [transType isEqualToString:@"approveTranspond"])
    {
        //转交给％@  审批意见：％@
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
    
    return @"";
}

#pragma mark - Initializer
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor minorFontColor];
        _nameLabel.font = [UIFont mtc_font_30];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
        _commentLabel.font = [UIFont mtc_font_30];
        _commentLabel.numberOfLines = 0;
        _commentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont mtc_font_24];
        _timeLabel.textColor = [UIColor mediumFontColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

@end
