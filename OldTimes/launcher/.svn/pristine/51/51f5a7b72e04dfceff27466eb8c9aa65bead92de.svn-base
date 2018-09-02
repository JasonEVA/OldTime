//
//  FileTableViewCell.m
//  launcher
//
//  Created by Jason Wang on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "FileTableViewCell.h"
#import <Masonry/Masonry.h>
#import "NSDate+MsgManager.h"
#import "UIImageView+WebCache.h"
#import "IMUtility.h"
#import "AvatarUtil.h"
#import <UIImageView+WebCache.h>
#import "MyDefine.h"
#import "UnifiedUserInfoManager.h"
#import "UIColor+Hex.h"
#import "ChatIMConfigure.h"
#import <MJExtension/MJExtension.h>
#define OFFSET 12.5
#define FONT [UIFont systemFontOfSize:12]
#define COLOR_GRAY   [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1]
#define COLOR_LIGHT  [UIColor colorWithRed:246/255.0 green:19/255.0 blue:84/255.0 alpha:1]
#define IMG_PLACEHOLDER_LOADING [UIImage imageNamed:@"image_placeholder_loading"]

@interface FileTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;             //名称
@property (nonatomic, strong) UILabel *sizeORmessageLabel;    //最后一条消息或文件大小
@property (nonatomic, strong) UILabel *fromLabel;             //发送人信息
@property (nonatomic, strong) UILabel *timeLable;             //时间
@property (nonatomic, strong) UIImageView *imgEmphasis;             // 重点


@end

@implementation FileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  Action:(SEL)Action
{
    self = [[FileTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILongPressGestureRecognizer *pressDr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:Action];
        [self.contentView addGestureRecognizer:pressDr];
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
        [self setNeedsUpdateConstraints];
        [self.redPoint setHidden:YES];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 富文本
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    int length = 0;
    while (YES) {
        NSRange range = [mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSRange newRange = NSMakeRange(range.location + length, range.length);
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:1 green:242/255.0 blue:70/255.0 alpha:1] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}

#pragma mark - method
//搜索设置数据方法
- (void)setCellData:(MessageBaseModel *)model searchText:(NSString *)text
{
    if (text.length != 0)
    {
        if(model._type == msg_personal_text)
        {
            //不区分大小写
            [self.sizeORmessageLabel setAttributedText:[self text:model._content searchText:text]];
            
            if (model._markImportant) {
                [self.imgEmphasis setHidden:NO];
                
            }
            else
            {
                [self.imgEmphasis setHidden:YES];
            }
            NSString *nickName = [model getNickName];
            // 发的人的uid
            NSString * userName = [model getUserName];
            if ([userName isEqualToString:@""] || userName == nil) {
                userName = [UnifiedUserInfoManager share].userShowID;
            }

            NSURL *urlHead = avatarURL(avatarType_40, userName);
            [_iconView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"] options:SDWebImageRefreshCached];
            
            [self.fromLabel setText:@""];
            [self.nameLabel setText:nickName];

        }
        else if(model._type == msg_personal_file)
        {
            [self.sizeORmessageLabel setText:model.attachModel.fileSizeString];
            NSString * st = [NSString stringWithFormat:@"%@",model.attachModel.fileName];
            [self.nameLabel setAttributedText:[self text:st searchText:text]];

            NSString *nickName = [model getNickName];
            NSString *string = [NSString stringWithFormat:@"%@ %@",LOCAL(FROM),nickName];

            [self.fromLabel setText:string];
            
            UIImage *image = [IMUtility fileIconFromFileName:model.attachModel.fileName];
            // 附件显示
            self.iconView.image = nil;
            [self.iconView setImage:image];
            
            [self.imgEmphasis setHidden:!model._markImportant];
        }
        
        // 时间格式化 - 毫秒
        [self.timeLable setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO]];
    }

}

//消息记录设置数据方法
- (void)setMessageData:(MessageBaseModel *)model
{
    if (model._type == msg_personal_text || model._type == msg_personal_voice) {
        [self setMessageAndFileData:model uid:self.uid];
    }else if (model._type == msg_personal_image) {
        [self setImageWith:model];
    }else if (model._type == msg_personal_file) {
        [self setFileWithData:model];
    }else if (model._type == msg_personal_mergeMessage)
    {
        [self setMessageAndFileData:model uid:self.uid];
    }
}


- (void)setMessageAndFileData:(MessageBaseModel *)model uid:(NSString *)uid
{
    [self setHeadImageWithUidStr:uid model:model];
    
    //[self.nameLabel setText:nickName];
    [self.timeLable setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO]];
    [self.sizeORmessageLabel setText:model._content];
    if (model._type == msg_personal_voice) {
        [self.sizeORmessageLabel setText:[NSString stringWithFormat:@"[%@]",LOCAL(MESSAGE_VOICE)]];
    }else if(model._type == msg_personal_mergeMessage )
    {
        NSDictionary *dict = [model._content mj_JSONObject];
        if (dict.count) {
            NSString *title =[dict objectForKey:@"title"];
            [self.sizeORmessageLabel setText:title];
        }
    }
}

- (void)setFileWithData:(MessageBaseModel *)model
{
    //清理数据显示问题
    self.sizeORmessageLabel.text = @"";
    UIImage *image = [IMUtility fileIconFromFileName:model.attachModel.fileName];
    // 附件显示
    self.iconView.image = nil;
    [self.iconView setImage:image];

    // 附件大小
//    NSString * st = [NSString stringWithFormat:@"%@   %@ %@",model.attachModel.fileSizeString,LOCAL(FROM),model.sendManName];
//    [self.sizeORmessageLabel setText:st];
    
    // 附件title显示
    [self.nameLabel setText:model.attachModel.fileName];
    [self.timeLable setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO]];

}

- (void)setImageWith:(MessageBaseModel *)model
{
    self.iconView.image = nil;
    
    if (model._nativeThumbnailUrl.length != 0) {
        NSString * str= @"";
        if ([model._nativeThumbnailUrl isEqualToString:@""]) {
            str = model._nativeOriginalUrl;
        }else {
            str = model._nativeThumbnailUrl;
        }
        
        [self.nameLabel setText:model.attachModel.fileName];
        NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:str];
        UIImage * image = [UIImage imageWithContentsOfFile:fullPath];
        self.iconView.image = image;
//        [self.sizeORmessageLabel setText:[NSString stringWithFormat:@"%@   %@ %@",model.attachModel.fileSizeString,LOCAL(FROM),model.sendManName]];

    }else {
        NSString * str= @"";
        if ([model.attachModel.thumbnail isEqualToString:@""] || model.attachModel.thumbnail == nil) {
            str = model.attachModel.fileUrl;
        }else {
            str = model.attachModel.thumbnail;
        }
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        NSString * string = [NSString stringWithFormat:@"AppName=launchr;UserName=%@",[UnifiedUserInfoManager share].userShowID];
        [manager setValue:string forHTTPHeaderField:@"Cookie"];

        [self.nameLabel setText:model.attachModel.fileName];
        NSString *fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,str];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:IMG_PLACEHOLDER_LOADING];
//        [self.sizeORmessageLabel setText:[NSString stringWithFormat:@"%@   %@ %@",model.attachModel.fileSizeString,LOCAL(FROM),model.sendManName]];

    }


}

#pragma mark - set head image

- (void)setHeadImageWithUidStr:(NSString *)uid model:(MessageBaseModel *)model
{
    NSURL * urlHead;
    //［_toLoginName］
    if ([model._fromLoginName isEqualToString:uid]) {
        //好友
        if (_isGroup) {
            //群聊
            NSString *nickName = [model getNickName];
            
            UserProfileModel *groupModel = [[MessageManager share] queryContactProfileWithUid:uid];
            // 发的人的uid
            NSString *userName = [groupModel getGroupMemberUserNameWithNickName:nickName];
            urlHead = avatarURL(avatarType_default, userName);
            
            [self.nameLabel setText:nickName];
        } else {
            //单聊
            urlHead = avatarURL(avatarType_default, [model getUserName]);
            NSString *nickName = [model getNickName];
            [self.nameLabel setText:nickName];
        }
    }else {
        //自己
        
        urlHead = avatarURL(avatarType_default, nil);
        [self.nameLabel setText:[UnifiedUserInfoManager share].userName];
    }
    [_iconView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"] options:SDWebImageRefreshCached];
}

- (NSString *)changeFileUnitFrom:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    double value =  [[manager attributesOfItemAtPath:filePath error:nil] fileSize];

    NSString *unit = @"B";
    if (value > 1024)
    {
        value /= 1024;
        unit = @"K";
    }
    if (value > 1024)
    {
        value /= 1024;
        unit = @"M";
    }
    if (value > 1024)
    {
        value /= 1024;
        unit = @"G";
    }
    return [NSString stringWithFormat:@"%.1f%@",value,unit];
}


#pragma mark - initComponent

- (void)initComponent
{
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.sizeORmessageLabel];
    [self addSubview:self.fromLabel];
    [self addSubview:self.timeLable];
    [self addSubview:self.redPoint];
    [self addSubview:self.imgEmphasis];

}

#pragma mark - updateConstraints
- (void)updateConstraints
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(OFFSET);
        make.bottom.equalTo(self).offset(-OFFSET);
        make.height.equalTo(self.iconView.mas_width);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(9);
        make.top.equalTo(self.iconView);
       // make.right.equalTo(self.timeLable.mas_left);
    }];
    
    [self.imgEmphasis mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.left.equalTo(self.nameLabel.mas_right).offset(25);
        make.centerY.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(self.timeLable.mas_left).offset(-10);
    }];
    
    [self.sizeORmessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconView);
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.right.lessThanOrEqualTo(self.timeLable);
    }];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sizeORmessageLabel.mas_right).offset(10);
        make.bottom.equalTo(self.sizeORmessageLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        
    }];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.mas_right).offset(-OFFSET);
        make.width.mas_equalTo(40);
		
    }];
	
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(5);
        make.top.equalTo(self.iconView);
        make.right.equalTo(self.iconView.mas_left).offset(-2);
    }];
    
    [super updateConstraints];
}

#pragma mark - InIt UI

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        //[_iconView setImage:[UIImage imageNamed:@"image_placeholder_loading"]];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _nameLabel;
}

- (UILabel *)sizeORmessageLabel
{
    if (!_sizeORmessageLabel) {
        _sizeORmessageLabel = [[UILabel alloc] init];
        [_sizeORmessageLabel setTextColor:COLOR_GRAY];
        //[_sizeORmessageLabel setText:@"1.2M"];
        [_sizeORmessageLabel setFont:FONT];
        //[_sizeORmessageLabel setBackgroundColor:[UIColor redColor]];
    }
    return _sizeORmessageLabel;
}

- (UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        [_timeLable setTextColor:[UIColor mtc_colorWithHex:0x999999]];
        _timeLable.textAlignment = NSTextAlignmentRight;
        //[_timeLable setText:@"12:45"];
        [_timeLable setFont:FONT];
    }
    return _timeLable;
}

- (UILabel *)fromLabel
{
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        [_fromLabel setTextColor:COLOR_GRAY];
        //[_fromLabel setText:@"来自：Jason"];
        [_fromLabel setFont:FONT];
        //[_fromLabel setBackgroundColor:[UIColor blueColor]];
    }
    return _fromLabel;
}

- (RedPoint *)redPoint
{
    if (!_redPoint) {
        _redPoint = [[RedPoint alloc] init];
    }
    return _redPoint;
}

- (UIImageView *)imgEmphasis
{
    if (!_imgEmphasis)
    {
        _imgEmphasis = [[UIImageView alloc] init];
        _imgEmphasis.userInteractionEnabled = YES;
        _imgEmphasis.image = [UIImage imageNamed:@"emphasis"];
        _imgEmphasis.hidden = YES;
    }
    
    return _imgEmphasis;
}



@end
