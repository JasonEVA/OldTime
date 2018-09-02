//
//  CoordinationContactTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationContactTableViewCell.h"
#import "ContactInfoModel.h"
#import "ServiceGroupMemberModel.h"
#import "PatientInfo.h"
#import "PatientInfo+SelectEX.h"
#import "AvatarUtil.h"

typedef NS_ENUM(NSUInteger, ContactSelectState) {
    ContactSelectStateUnselected, // 未选中
    ContactSelectStateSelected,   // 选中
    ContactSelectStateNonSelected, // 不可选
};

@interface CoordinationContactTableViewCell()

@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UIImageView  *selectImageView; // <##>
@property (nonatomic, strong)  ContactInfoModel  *model; // <##>
@end
@implementation CoordinationContactTableViewCell

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

- (void)selectCellWithModel:(ContactInfoModel *)model {
    if (!model.nonSelectable) {
        [self selectCellWithSelectState:model.selected ? ContactSelectStateSelected : ContactSelectStateUnselected];
    }
    else {
        [self selectCellWithSelectState:ContactSelectStateNonSelected];
    }
}


- (void)selectCellWithSelectState:(ContactSelectState)selectState {
    switch (selectState) {
        case ContactSelectStateUnselected:
            [self.selectImageView setImage:[UIImage imageNamed:@"c_contact_unselected"]];

            break;
            
            
        case ContactSelectStateSelected:
            [self.selectImageView setImage:[UIImage imageNamed:@"c_contact_selected"]];
            break;

            
        case ContactSelectStateNonSelected:
            [self.selectImageView setImage:[UIImage imageNamed:@"c_contact_nonSelect"]];

            break;

        default:
            break;
    }

}

- (void)configCellData:(id)model selectable:(BOOL)selectable {
    
    if ([model isKindOfClass:[ContactInfoModel class]]) {
        ContactInfoModel *newModel = (ContactInfoModel *)model;
        
        [self.title setText:newModel.relationInfoModel.nickName];
        
//        NSString *avatarPath = newModel.relationInfoModel.relationAvatar;
//        if (newModel.relationInfoModel.relationAvatar.length == 0) {
//            UserProfileModel *fullModel = [[MessageManager share] queryContactProfileWithUid:newModel.relationInfoModel.relationName];
//            avatarPath = fullModel.avatar;
//        }
        // 设置头像
//        NSString *baseURL = [CommonFuncs picUrlPerfix];
//        NSString *fullPath = [baseURL stringByAppendingString:avatarPath ?: @""];
        [self.avatar sd_setImageWithURL:avatarURL(avatarType_80, newModel.relationInfoModel.relationName) placeholderImage:newModel.group ? [UIImage imageNamed:@"group_defalut_avatar"] : [UIImage imageNamed:@"img_default_staff"]];

        if (selectable) {
            if (!newModel.nonSelectable) {
                [self selectCellWithSelectState:newModel.selected ? ContactSelectStateSelected : ContactSelectStateUnselected];
            }
            else {
                [self selectCellWithSelectState:ContactSelectStateNonSelected];
            }
        }
        

    }
    else if ([model isKindOfClass:[ServiceGroupMemberModel class]]) {
        ServiceGroupMemberModel *newModel = (ServiceGroupMemberModel *)model;
        [self.title setText:newModel.staffName];
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:newModel.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
        if (selectable) {
//            if (!newModel.nonSelectable) {
                [self selectCellWithSelectState:newModel.selected ? ContactSelectStateSelected : ContactSelectStateUnselected];
//            }
//            else {
//                [self selectCellWithSelectState:ContactSelectStateNonSelected];
//            }
        }

    }
    else if ([model isKindOfClass:[PatientInfo class]]) {
        PatientInfo *newModel = (PatientInfo *)model;
        [self.title setText:newModel.userName];
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:newModel.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
        if (selectable) {
            //            if (!newModel.nonSelectable) {
            [self selectCellWithSelectState:newModel.at_selected ? ContactSelectStateSelected : ContactSelectStateUnselected];
            //            }
            //            else {
            //                [self selectCellWithSelectState:ContactSelectStateNonSelected];
            //            }
        }

    }
    
    if (self.selectable != selectable) {
        self.selectable = selectable;
        [self configElements];
    }

}

// 设置元素控件
- (void)configElements {
    
    self.clipsToBounds = YES;
    // 设置约束
    [self configConstraints];  
}

// 设置约束
- (void)configConstraints {
    
    if (self.selectable) {
        [self.contentView addSubview:self.selectImageView];
    }
    [self.contentView addSubview:self.avatar]; // <##>
    [self.contentView addSubview:self.title]; // <##>

    if (self.selectable) {
        [self.selectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(12.5);
        }];

    }
    
    [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.selectable ? self.selectImageView.mas_right : self.contentView).offset(12.5);
    }];
    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(7.5);
        make.centerY.equalTo(self.avatar);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.selectable) {
        self.selectImageView.layer.cornerRadius = CGRectGetHeight(self.selectImageView.frame) * 0.5;
    }
}


#pragma mark - Init
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 2.5;
        _avatar.clipsToBounds = YES;
        [_avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _avatar;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        [_title setText:@"糖尿病专家协作组"];
        [_title setFont:[UIFont font_30]];
        [_title setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _title;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.clipsToBounds = YES;
        [_selectImageView setImage:[UIImage imageNamed:@"c_contact_unselected"]];
    }
    return _selectImageView;
}

@end
