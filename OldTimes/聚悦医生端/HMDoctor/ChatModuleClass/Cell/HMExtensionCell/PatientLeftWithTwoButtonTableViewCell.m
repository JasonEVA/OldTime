//
//  PatientLeftWithTwoButtonTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientLeftWithTwoButtonTableViewCell.h"
#import "MessageBaseModel+CellSize.h"
#define ScreenWidth [ UIScreen mainScreen ].applicationFrame.size.width

@interface PatientLeftWithTwoButtonTableViewCell()
{
    UIImageView *leftImageView;
    UILabel *contentLb;
    UIButton *dealWithBtn;
    UIButton *detailBtn;
    MessageBaseModel *myModel;

}
@property (nonatomic, copy) ButtonClick buttonClick;

@end
@implementation PatientLeftWithTwoButtonTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftImageView = [[UIImageView alloc]init];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_warning"]];
        
        contentLb = [[UILabel alloc]init];
        [contentLb setTextColor:[UIColor commonTextColor]];
        [contentLb setFont:[UIFont systemFontOfSize:15]];
        [contentLb setNumberOfLines:0];
        [contentLb setText:@"hahahahahahaha"];
        
        dealWithBtn = [[UIButton alloc]init];
        [dealWithBtn setTitle:@"处理预警" forState:UIControlStateNormal];
        [dealWithBtn setTitle:@"已处理" forState:UIControlStateDisabled];
        [dealWithBtn setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [dealWithBtn setBackgroundImage:[UIImage imageColor:[UIColor commonLightGrayColor_999999] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateDisabled];
        [dealWithBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dealWithBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [dealWithBtn.layer setCornerRadius:2];
        [dealWithBtn setClipsToBounds:YES];
        [dealWithBtn setTag:0];
        [dealWithBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        
        detailBtn = [[UIButton alloc]init];
        [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [detailBtn setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detailBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [detailBtn.layer setCornerRadius:2];
        [detailBtn setClipsToBounds:YES];
        [detailBtn setTag:1];
        [detailBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.wz_contentView addSubview:leftImageView];
        [self.wz_contentView addSubview:contentLb];
        [self.wz_contentView addSubview:dealWithBtn];
        [self.wz_contentView addSubview:detailBtn];

        
        [self configElements];
    }
    return self;
}

- (void)configElements {
    
    
    [leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewBubble).offset(12);
        make.left.equalTo(self.imgViewBubble).offset(20);
        make.height.width.mas_equalTo(55);
        
        if ([myModel eventContentHeight] < LEFTIMAGEHEIGHT) {
            make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityHigh();
        } else {
            make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityLow();
            
        }
        
    }];
    
    [contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageView);
        make.left.equalTo(leftImageView.mas_right).offset(8);
        make.right.equalTo(self.imgViewBubble).offset(-12);
        make.width.mas_equalTo(ScreenWidth - 210);
    }];
    
    [dealWithBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLb.mas_bottom).offset(5);
        make.left.equalTo(contentLb);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityMedium();
    }];
    
    [detailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(dealWithBtn);
        make.width.equalTo(dealWithBtn);
        make.left.equalTo(dealWithBtn.mas_right).offset(5);
        make.right.equalTo(contentLb);
        make.height.equalTo(@25);
    }];
}

- (void)fillInDataWith:(MessageBaseModel *)baseModel
{
    myModel = baseModel;
    NSString* content = baseModel._content;
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    //监测预警消息
    MessageBaseModelTestResultPage* serviceCommentsModelContent = [MessageBaseModelTestResultPage mj_objectWithKeyValues:dicContent];
    [contentLb setText:serviceCommentsModelContent.msg];
    if ([serviceCommentsModelContent.isDone isEqualToString:@"Y"]) {
        [dealWithBtn setEnabled:NO];
    }
    else {
        [dealWithBtn setEnabled:YES];
    }
    [self configElements];
    
}

- (void)Click:(UIButton *)btn {
    if (self.buttonClick) {
        self.buttonClick(btn.tag);
    }
}
- (void)btnClick:(ButtonClick)block {
    self.buttonClick = block;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
