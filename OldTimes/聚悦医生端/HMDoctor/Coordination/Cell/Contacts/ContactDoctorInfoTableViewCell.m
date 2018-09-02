//
//  ContactDoctorInfoTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorCompletionInfoModel.h"
#import "AvatarUtil.h"
#import "UserProfileModel+ProfileExtension.h"

@interface ContactDoctorInfoTableViewCell ()

@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *name; // <##>
@property (nonatomic, strong)  UILabel  *position; // <##>
@property (nonatomic, strong)  UILabel  *hospital; // <##>
@property (nonatomic, copy) ContactDoctorInfoTableViewCellBlock clickBlock;
@end

@implementation ContactDoctorInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)setAcceptState:(BOOL)acceptState {
    _acceptState = acceptState;
    if (!acceptState) {
        return;
    }
    [self.contentView addSubview:self.btnAccept];
    [self.btnAccept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-12.5);
    }];
}

- (void)configDoctorCompletionInfoModel:(DoctorCompletionInfoModel *)model {
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.text = model.staffName;
    self.position.text = model.staffTypeName;
    self.hospital.text = model.orgName;
}

//全局搜索聊天记录用
- (void)fillDataWithMessageBaseModel:(MessageBaseModel *)model searchText:(NSString *)searchText {
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80, [model getUserName]) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.text = [model getNickName];
    self.position.text = @"";
    self.hospital.attributedText = [self text:model._content searchText:searchText];
}

//联系人模糊搜索用
- (void)fillDataWithMessageRelationInfoModel:(MessageRelationInfoModel *)model searchText:(NSString *)searchText{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80, model.relationName) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.attributedText = [self text:model.nickName searchText:searchText];
    NSDictionary *extensionDic = [model.extension mj_JSONObject];
    self.position.text = extensionDic[@"position"];
    self.hospital.text = extensionDic[@"hospital"];
    
}
#pragma mark - Event Response

- (void)acceptButtonClicked {
    if (self.clickBlock) {
        self.clickBlock();
    }
}


- (void)setDataWithModel:(MessageRelationValidateModel *)model
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80, model.from) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    [self.name setText:model.fromNickName];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
#warning 只能是自己医院的医生加好友
    self.hospital.text = staff.orgName;
}
- (void)sendDateWithModel:(ContactInfoModel *)model
{
    [self.name setText:model.relationInfoModel.nickName];
}

#pragma mark - interface

- (void)clickBlock:(ContactDoctorInfoTableViewCellBlock)block
{
    self.clickBlock = block;
}
#pragma mark - Private Method

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
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor mainThemeColor] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}

// 设置元素控件
- (void)configElements {
    [self.contentView addSubview:self.avatar]; // <##>
    [self.contentView addSubview:self.name]; // <##>
    [self.contentView addSubview:self.position]; // <##>
    [self.contentView addSubview:self.hospital]; // <##>
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(12.5);
        make.top.equalTo(self.avatar);
    }];
    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(15);
        make.centerY.equalTo(self.name);
    }];
    
    [self.hospital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.bottom.equalTo(self.avatar);
    }];
    
}

#pragma mark - Init
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 20.0;
        _avatar.clipsToBounds = YES;
        [_avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        [_name setText:@"谢天笑"];
        [_name setFont:[UIFont font_30]];
        [_name setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _name;
}

- (UILabel *)position {
    if (!_position) {
        _position = [UILabel new];
        [_position setText:@""];
        [_position setFont:[UIFont font_26]];
        [_position setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _position;
}

- (UILabel *)hospital {
    if (!_hospital) {
        _hospital = [UILabel new];
        [_hospital setText:@""];
        [_hospital setFont:[UIFont font_26]];
        [_hospital setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _hospital;
}

- (UIButton *)btnAccept {
    if (!_btnAccept) {
        _btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAccept.layer.cornerRadius = 2.5;
        _btnAccept.clipsToBounds = YES;
        [_btnAccept setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnAccept setTitle:@"同意" forState:UIControlStateNormal];
        [_btnAccept setBackgroundImage:[UIImage at_imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
        [_btnAccept setTitle:@"已同意" forState:UIControlStateDisabled];
        [_btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnAccept.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnAccept addTarget:self action:@selector(acceptButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnAccept;
}

@end
