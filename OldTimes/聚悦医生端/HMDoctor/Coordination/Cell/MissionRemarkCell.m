//
//  MissionRemarkCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionRemarkCell.h"

@interface MissionRemarkCell ()
@property (nonatomic, strong)  UILabel  *placeholder; // <##>
@end

@implementation MissionRemarkCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textView];
        [self.textView addSubview:self.placeholder];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.textView).insets(UIEdgeInsetsMake(7, 7, 0, 0));
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)hidePlaceholder:(BOOL)hide {
    self.placeholder.hidden = hide;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        [_textView setFont:[UIFont systemFontOfSize:15]];
    }
    return _textView;

}

- (UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [UILabel new];
        [_placeholder setFont:[UIFont systemFontOfSize:15]];
        _placeholder.textColor = [UIColor commonGrayTextColor];
        _placeholder.text = @"点击添加备注";
    }
    return _placeholder;
}

- (void)textDidChange {
    self.placeholder.hidden = self.textView.text.length > 0;
}
@end
