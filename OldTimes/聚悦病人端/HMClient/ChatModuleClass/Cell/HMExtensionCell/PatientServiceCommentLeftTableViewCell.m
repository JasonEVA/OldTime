//
//  PatientServiceCommentLeftTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/6/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientServiceCommentLeftTableViewCell.h"
#import "MessageBaseModel+CellSize.h"
#define ScreenWidth [ UIScreen mainScreen ].applicationFrame.size.width
#define LEFTIMAGEHEIGHT   55

@interface PatientServiceCommentLeftTableViewCell ()
{
    UIImageView *leftImageView;
    UILabel *contentLb;
    UIButton *toEvaluateBtn;
    MessageBaseModel *myModel;
}
@end

@implementation PatientServiceCommentLeftTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftImageView = [[UIImageView alloc]init];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_evaluate"]];
        
        contentLb = [[UILabel alloc]init];
        [contentLb setTextColor:[UIColor commonTextColor]];
        [contentLb setFont:[UIFont font_30]];
        [contentLb setNumberOfLines:0];
        
        toEvaluateBtn = [[UIButton alloc]init];
        [toEvaluateBtn setTitle:@"前往评价>>" forState:UIControlStateNormal];
        [toEvaluateBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [toEvaluateBtn.titleLabel setFont:[UIFont font_30]];
        
        [self.wz_contentView addSubview:leftImageView];
        [self.wz_contentView addSubview:contentLb];
        [self.wz_contentView addSubview:toEvaluateBtn];
        
        [self configElements];
    }
    return self;
}

- (void)configElements {
    
    
    [leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewBubble).offset(12);
        make.left.equalTo(self.imgViewBubble).offset(20);
        make.height.width.mas_equalTo(55);

        if ([myModel eventContentHeight] < LEFTIMAGEHEIGHT ) {

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
    
    [toEvaluateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLb.mas_bottom).offset(5);
        make.right.equalTo(contentLb);
        make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityMedium();
    }];
    
}

- (void)fillInDadaWith:(MessageBaseModel *)baseModel
{
    myModel = baseModel;
    NSString* content = baseModel._content;
    NSLog(@"自定义消息 %@", content);
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    //服务评价消息
    MessageBaseModelServiceCommentsContent* serviceCommentsModelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
    [contentLb setText:serviceCommentsModelContent.msg];
    [leftImageView setImage:[UIImage imageNamed:@"icon_card_evaluate"]];
    [self configElements];

}
@end
