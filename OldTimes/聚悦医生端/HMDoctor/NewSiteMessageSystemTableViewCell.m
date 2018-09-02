//
//  NewSiteMessageSystemTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageSystemTableViewCell.h"
#import "AvatarUtil.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "HMPhoneNumberUtil.h"

#define PHONEREGULAR @"\\d{3,4}[- ]?\\d{7,8}"

@interface NewSiteMessageSystemTableViewCell ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) TTTAttributedLabel *contentLb;

@end

@implementation NewSiteMessageSystemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self.cardView addSubview:self.titelLb];
        [self.cardView addSubview:self.contentLb];
        
        [self configElements];
        
    }
    return self;
}


#pragma mark -private method
- (void)configElements {
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nikeNameLb.mas_bottom).offset(2);
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(15);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-50);;
    }];

    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.cardView).offset(15);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
//        make.bottom.greaterThanOrEqualTo(self.cardView).offset(-15).priorityLow();
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(10);
        make.left.equalTo(self.titelLb);
        make.right.equalTo(self.cardView).offset(-15);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];

    
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

// 富文本
- (void)fillRichTextWithString:(NSString *)content {
    if (!content.length) {
        return;
    }
    //添加链接样式
    self.contentLb.linkAttributes = @{NSForegroundColorAttributeName:[UIColor mainThemeColor]};
    
    //设置段落，文字样式
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 6.0;
    NSDictionary *paragraphDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphstyle};
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:content attributes:paragraphDic];
    
    [tempStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, content.length)];
    
    self.contentLb.text = tempStr;
    
    NSRange stringRange = NSMakeRange(0, tempStr.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:PHONEREGULAR options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:[tempStr string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //添加链接
            NSString *actionString = [NSString stringWithFormat:@"%@",[self.contentLb.text substringWithRange:result.range]];
            
            if ([HMPhoneNumberUtil isMobilePhoneOrtelePhone:actionString] || [[actionString substringToIndex:3] isEqualToString:@"400"]) {
                [self.contentLb addLinkToPhoneNumber:actionString withRange:result.range];
            }
        }];
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark - event Response

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    //点击手机号
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
}

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model{
//    NewSiteMessageSystemModel *tempModel  = [NewSiteMessageSystemModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
//    [self fillRichTextWithString:tempModel.msg];
//    [self.titelLb setText:tempModel.msgTitle];
//    
//    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
//    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
//    NSURL *urlHead = avatarURL(avatarType_80, tempModel.userId);
//    [self.imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"im_xitong"]];
////    [self configElements];
}

#pragma mark - init UI


- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"申请通过" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titelLb;
}
- (TTTAttributedLabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [TTTAttributedLabel new];
        [_contentLb setDelegate:self];
        [_contentLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLb setFont:[UIFont systemFontOfSize:14]];
        [_contentLb setNumberOfLines:0];
//        [_contentLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        [_contentLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        _contentLb.lineBreakMode = NSLineBreakByWordWrapping;
//        _contentLb.preferredMaxLayoutWidth = W_MAX;
    }
    return _contentLb;
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
