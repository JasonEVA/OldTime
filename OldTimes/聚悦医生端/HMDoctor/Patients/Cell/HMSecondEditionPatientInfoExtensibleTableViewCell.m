//
//  HMSecondEditionPatientInfoExtensibleTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPatientInfoExtensibleTableViewCell.h"
#import <CoreText/CoreText.h>
#define scale  (ScreenWidth / (750.0 / 2))
@interface HMSecondEditionPatientInfoExtensibleTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, copy) extensibleCellClickBlock block;

@end

@implementation HMSecondEditionPatientInfoExtensibleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.contentLb];
        [self.contentView addSubview:self.extentBtn];

    }
    return self;
}

- (void)configElements {
    BOOL isShowBottom;
    if (self.contentLb.text.length) {
        NSArray *arr = [self getLinesArrayOfStringInLabel:self.contentLb];
        isShowBottom = arr.count > 2;
    }
    
    
    [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15 * scale);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        make.height.equalTo(@20);
    }];
    
    if (isShowBottom&&!self.extentBtn.hidden) {
        [self.extentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.contentView);
        }];
    }

    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom);
        make.right.equalTo(self.contentView).offset(-15);
        if (!isShowBottom || self.extentBtn.hidden) {
            make.bottom.equalTo(self.contentView).offset(-10);
        }
        else {
            make.bottom.equalTo(self.extentBtn.mas_top);
        }
    }];
    
}

- (void)fillDataWithTitel:(NSString *)titel content:(NSString *)content showMutiLines:(BOOL)show{
    if (show) {
        [self.contentLb setNumberOfLines:0];
    } else {
        [self.contentLb setNumberOfLines:2];
    }
    [self.titelLb setText:titel];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    self.contentLb.attributedText = attributedString;
    [self configElements];

}

//这部分代码不但能够求出一个label中文字行数，更厉害的是能够求出每一行的内容是什么
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,ScreenWidth - 30,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)extentClick:(extensibleCellClickBlock)block {
    self.block = block;
}
- (void)btnClick {
    self.extentBtn.selected ^= 1;
    
    if (self.block) {
        self.block();
    }
}
- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont font_32]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setText:@""];
    }
    return _titelLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UILabel new];
        [_contentLb setFont:[UIFont systemFontOfSize:15]];
        [_contentLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLb setNumberOfLines:0];
        [_contentLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_contentLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLb.preferredMaxLayoutWidth = ScreenWidth - 15 - 15 * scale;
        [_contentLb setText:@""];
    }
    return _contentLb;
}

- (UIButton *)extentBtn {
    if (!_extentBtn) {
        _extentBtn = [UIButton new];
        [_extentBtn setImage:[UIImage imageNamed:@"im_jt_down"] forState:UIControlStateNormal];
        [_extentBtn setImage:[UIImage imageNamed:@"im_jt_up"] forState:UIControlStateSelected];
        [_extentBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extentBtn;
}
@end
