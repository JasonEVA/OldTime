//
//  PersonServiceComplainHistoryTableViewCell.m
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServiceComplainHistoryTableViewCell.h"
#import "PersonServiceComplainListModel.h"

@interface PersonServiceComplainHistoryTableViewCell ()

@property(nonatomic, strong) UILabel  *objectTitle;     // 投诉对象
@property(nonatomic, strong) UILabel  *objectContent;     // 投诉对象

@property(nonatomic, strong) UILabel  *timeTitle;       //投诉时间
@property(nonatomic, strong) UILabel  *timeContent;       //投诉时间

@property(nonatomic, strong) UILabel  *contentTitle;    //投诉内容
@property(nonatomic, strong) UILabel  *content;    //投诉内容

@property(nonatomic, strong) UILabel  *replyTitle;              //回复
@property(nonatomic, strong) UILabel  *replyContent;          // 回复内容

@property(nonatomic, strong) UIView  *lineView;

@property (nonatomic, strong)  UIImageView  *bgView; // <##>

@end


@implementation PersonServiceComplainHistoryTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        [self createFrame];
    }
    return self;
}

#pragma mark - interFaceMthod
- (void)setDataWithModel:(PersonServiceComplainListModel *)model
{
    self.objectContent.text = model.complaintObjectName;
    self.timeContent.text = model.createTime;
    self.content.text = model.complaintContent;
    if (model.status.integerValue == 0) {
        // 未回复
        self.replyTitle.backgroundColor = [UIColor commonOrangeColor];
        self.replyTitle.text = @"回复中";
        self.replyContent.text = @"您好，我们已收到您的投诉，客服会在7日内回复您。";
    }
    else {
        // 已回复
        self.replyTitle.backgroundColor = [UIColor commonBlueColor];
        self.replyTitle.text = @"已回复";
        self.replyContent.text = model.replyContent;

    }
}

#pragma mark - createFrame

- (void)createFrame
{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.objectTitle];
    [self.bgView addSubview:self.objectContent];
    
    [self.bgView addSubview:self.timeTitle];
    [self.bgView addSubview:self.timeContent];
    
    [self.bgView addSubview:self.contentTitle];
    [self.bgView addSubview:self.content];
    
    [self.bgView addSubview:self.lineView];

    [self.bgView addSubview:self.replyTitle];
    [self.bgView addSubview:self.replyContent];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    [self.objectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.top.equalTo(self.bgView).offset(12);
        make.width.mas_equalTo(50.5 * ([UIScreen mainScreen].scale == 3 ? 1.11 : 1));
    }];
    [self.objectContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.objectTitle.mas_right);
        make.right.equalTo(self.bgView).offset(-12);
        make.top.equalTo(self.objectTitle);
    }];
    
    [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.objectTitle);
        make.top.equalTo(self.objectContent.mas_bottom).offset(5);
    }];
    [self.timeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeTitle.mas_right);
        make.right.equalTo(self.bgView).offset(-12);
        make.top.equalTo(self.timeTitle);
    }];
    
    [self.contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.objectTitle);
        make.top.equalTo(self.timeContent.mas_bottom).offset(5);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTitle.mas_right);
        make.right.equalTo(self.bgView).offset(-12);
        make.top.equalTo(self.contentTitle);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.top.equalTo(self.content.mas_bottom).offset(12);
        make.left.equalTo(self.bgView).offset(20);
        make.right.equalTo(self.bgView).offset(-20);
    }];
    
    [self.replyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.left.equalTo(self.objectTitle);
        make.size.mas_equalTo(CGSizeMake(47.0 * ([UIScreen mainScreen].scale == 3 ? 1.11 : 1), 21));
    }];
    
    [self.replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.replyTitle);
        make.left.equalTo(self.objectContent);
        make.right.equalTo(self.bgView).offset(-12);
        make.bottom.equalTo(self.bgView).offset(-12);
    }];
}

- (UILabel *)p_createTitleLabelWithTitle:(NSString *)title {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont font_28];
    lb.text = title;
    lb.textColor = [UIColor commonDarkGrayTextColor];
    lb.textAlignment = NSTextAlignmentLeft;
    [lb setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    return lb;
}

- (UILabel *)p_createContentLable {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont font_28];
    lb.textColor = [UIColor commonTextColor];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.numberOfLines = 0;
    return lb;
}

#pragma mark -  setterAndGetter

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cellBG"]];
    }
    return _bgView;
}
- (UILabel *)objectTitle
{
    if (!_objectTitle)
    {
        _objectTitle = [self p_createTitleLabelWithTitle:@"对象："];
    }
    return _objectTitle;
}
- (UILabel *)objectContent
{
    if (!_objectContent)
    {
        _objectContent = [self p_createContentLable];
    }
    return _objectContent;
}

- (UILabel *)timeTitle
{
    if (!_timeTitle)
    {
        _timeTitle = [self p_createTitleLabelWithTitle:@"时间："];
    }
    return _timeTitle;
}
- (UILabel *)timeContent
{
    if (!_timeContent)
    {
        _timeContent = [self p_createContentLable];
    }
    return _timeContent;
}

- (UILabel *)contentTitle
{
    if (!_contentTitle)
    {
        _contentTitle = [self p_createTitleLabelWithTitle:@"内容："];
    }
    return _contentTitle;
}
- (UILabel *)content
{
    if (!_content)
    {
        _content = [self p_createContentLable];
    }
    return _content;
}

- (UILabel *)replyTitle
{
    if (!_replyTitle)
    {
        _replyTitle = [UILabel new];
        _replyTitle.textAlignment = NSTextAlignmentCenter;
        _replyTitle.textColor = [UIColor whiteColor];
        _replyTitle.font = [UIFont font_24];
        _replyTitle.layer.cornerRadius = 2;
        _replyTitle.clipsToBounds = YES;
    }
    return _replyTitle;
}
- (UILabel *)replyContent
{
    if (!_replyContent)
    {
        _replyContent = [self p_createContentLable];
    }
    return _replyContent;
}


- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor commonCuttingLineColor];
    }
    return _lineView;
}

@end
