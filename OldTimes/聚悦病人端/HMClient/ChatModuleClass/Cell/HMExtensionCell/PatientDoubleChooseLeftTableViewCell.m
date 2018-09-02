//
//  PatientDoubleChooseLeftTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientDoubleChooseLeftTableViewCell.h"
#import "MessageBaseModel+CellSize.h"
#import "UIButton+EX.h"

@interface PatientDoubleChooseLeftTableViewCell ()

@property (nonatomic, strong) UILabel *textContentLb;
@property (nonatomic, strong) UIButton *yesBtn;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, copy) ButtonClick buttonClick;

@end

@implementation PatientDoubleChooseLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.wz_contentView addSubview:self.textContentLb];
        [self.wz_contentView addSubview:self.yesBtn];
        [self.wz_contentView addSubview:self.noBtn];
        
        [self.textContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewBubble).offset(20);
            make.top.equalTo(self.imgViewBubble).offset(12);
            make.right.equalTo(self.imgViewBubble).offset(-12);
            make.width.mas_equalTo(ScreenWidth - 155);
            
        }];
        
        [self.yesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textContentLb.mas_bottom).offset(5);
            make.left.equalTo(self.textContentLb).offset(10);
            make.height.equalTo(@25);
            make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityMedium();
        }];
        
        [self.noBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.yesBtn);
            make.left.equalTo(self.yesBtn).offset(60);
            make.height.equalTo(@25);
        }];

    }
    return self;
}
- (void)buttonClick:(UIButton *)btn {
    if (self.buttonClick) {
        self.buttonClick(btn.tag);
    }
}

- (void)btnClick:(ButtonClick)block {
    self.buttonClick = block;
}
- (void)fillInDataWith:(MessageBaseModel *)baseModel {
    NSString* content = baseModel._content;
    NSLog(@"自定义消息 %@", content);
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    
    MessageBaseModelRoundsPush *serviceCommentsModelContent = [MessageBaseModelRoundsPush mj_objectWithKeyValues:dicContent];
    [self.textContentLb setText:serviceCommentsModelContent.msg];
    [self.yesBtn setSelected:NO];
    [self.noBtn setSelected:NO];
    [self.yesBtn setUserInteractionEnabled:YES];
    [self.noBtn setUserInteractionEnabled:YES];
    if (serviceCommentsModelContent.status.integerValue) {
        [self.yesBtn setUserInteractionEnabled:NO];
        [self.noBtn setUserInteractionEnabled:NO];
    }
    if (serviceCommentsModelContent.status.integerValue == 1) {
        [self.noBtn setSelected:YES];
    }
    if (serviceCommentsModelContent.status.integerValue == 2) {
        [self.yesBtn setSelected:YES];
    }
}
- (UILabel *)textContentLb {
    if (!_textContentLb) {
        _textContentLb = [[UILabel alloc]init];
        [_textContentLb setTextColor:[UIColor commonTextColor]];
        [_textContentLb setFont:[UIFont font_30]];
        [_textContentLb setNumberOfLines:0];
    }
    return _textContentLb;
}

- (UIButton *)yesBtn {
    if (!_yesBtn) {
        _yesBtn = [UIButton new];
        [_yesBtn setImage:[UIImage imageNamed:@"im_choose"] forState:UIControlStateNormal];
        [_yesBtn setImage:[UIImage imageNamed:@"im_choosed"] forState:UIControlStateSelected];
        [_yesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_yesBtn setTag:1];
        [_yesBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lb = [UILabel new];
        [lb setText:@"有"];
        [lb setTextColor:[UIColor commonTextColor]];
        [_yesBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yesBtn.imageView.mas_right).offset(5);
            make.centerY.equalTo(_yesBtn.imageView);
        }];
    }
    return _yesBtn;
}

- (UIButton *)noBtn {
    if (!_noBtn) {
        _noBtn = [UIButton new];
        [_noBtn setImage:[UIImage imageNamed:@"im_choose"] forState:UIControlStateNormal];
        [_noBtn setImage:[UIImage imageNamed:@"im_choosed"] forState:UIControlStateSelected];
        [_noBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_noBtn setTag:0];
        [_noBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lb = [UILabel new];
        [lb setText:@"没有"];
        [lb setTextColor:[UIColor commonTextColor]];
        [_noBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_noBtn.imageView.mas_right).offset(5);
            make.centerY.equalTo(_noBtn.imageView);
        }];
    }
    return _noBtn;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
