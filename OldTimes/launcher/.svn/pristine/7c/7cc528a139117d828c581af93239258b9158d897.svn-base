//
//  NewApplyAddApplyTitleTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyAddApplyTitleTableViewCell.h"
#import "UIFont+Util.h"
#import "UIColor+Hex.h"
#import "NSString+HandleEmoji.h"
#import <Masonry/Masonry.h>
#import "NewApplyFormBaseModel.h"
static CGFloat kNewApplyAddApplyTitleCellTitleViewTopMargin = 5;
static CGFloat kNewApplyAddApplyTitleCellTitleViewLeftMargin = 12;
static CGFloat kNewApplyAddApplyTitleCellTitleViewBottomMargin = -5;
static CGFloat kNewApplyAddApplyTitleCellTitleViewRightMargin = -13;
static CGFloat kNewApplyAddApplyTitleCellTitleViewEstimatedHeight = 34;

@interface NewApplyAddApplyTitleTableViewCell()<UITextViewDelegate>
@property (nonatomic, strong) MASConstraint *textViewHeightConstraint;
@property(nonatomic, strong) NewApplyFormBaseModel  *model;
@end

@implementation NewApplyAddApplyTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];

        [self.contentView addSubview:self.tvwTitle];
        [self.contentView addSubview:self.placeholderLabel];
        [self setframes];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];

        [self.contentView addSubview:self.tvwTitle];
        [self.contentView addSubview:self.placeholderLabel];
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [self.tvwTitle removeObserver:self forKeyPath:@"contentSize" context:NULL];
}
#pragma mark - interfaceMethod
- (void)setDataWithModel:(NewApplyFormBaseModel *)model
{
    NSLog(@"-----> %@",model.key);
    self.model = model;
}

#pragma mark - Privite Methods
- (void)setframes
{
    [self.tvwTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(kNewApplyAddApplyTitleCellTitleViewTopMargin);
        make.left.equalTo(self.contentView).offset(kNewApplyAddApplyTitleCellTitleViewLeftMargin);
        make.right.equalTo(self.contentView).offset(kNewApplyAddApplyTitleCellTitleViewRightMargin);
        make.bottom.greaterThanOrEqualTo(self.contentView).offset(kNewApplyAddApplyTitleCellTitleViewBottomMargin);
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 12, 5, 13));
        self.textViewHeightConstraint = make.height.equalTo(@(kNewApplyAddApplyTitleCellTitleViewEstimatedHeight)).priorityHigh();
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tvwTitle).offset(7);
        make.left.equalTo(self.tvwTitle).offset(3);
    }];
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat height = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue].height;

    if (height > 110) {
        self.cellheight = 124;
    }
    else
    {
        self.cellheight = height + 10;
    }
    if (height> 110)
    {
        if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:needreload:)])
        {
            [self.delegate textViewCell:self didChangeText:self.tvwTitle.text needreload:NO];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:needreload:)])
        {
            if (self.tvwTitle.text.length)
            {
                [self.delegate textViewCell:self didChangeText:self.tvwTitle.text needreload:YES];
            }
            else
            {
                [self.delegate textViewCell:self didChangeText:self.tvwTitle.text needreload:NO];
            }
            
            
        }
        //        CGRect bounds = self.tvwTitle.bounds;
        //        bounds.size.height = height;
        //        self.tvwTitle.bounds = bounds;
        // 让 table view 重新计算高度
        UITableView *tableView = [self tableView];
        [tableView beginUpdates];
        [tableView endUpdates];
    }
	
	if (height > 124) {
		return;
	}
	
	self.textViewHeightConstraint.offset = height;	
    [UIView animateWithDuration:0.2 animations:^{
		
        [self layoutIfNeeded];
    }];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    // 禁止系统表情的输入
    if (textView.text.length > 0) {
		NSString *text = [textView.text stringByRemovingEmoji];
        if (![text isEqualToString:textView.text]) {

            textView.text = text;
        }
    }
    
    if (textView.contentSize.height < 105)
    {
        CGRect rect = textView.frame;
        if (textView.contentSize.height < 105)
            rect.size.height = textView.contentSize.height;
        textView.frame = rect;
        [textView scrollRangeToVisible:NSMakeRange(0,0)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 200)
    {
        textView.text = [str substringToIndex:200];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.model.labelText isEqualToString:@"备注"]) {
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, -250);
            self.tableView.transform = transform;
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.model.labelText isEqualToString:@"备注"])
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
        }];
    }
}
#pragma mark - Getter And Setter
- (NSString *)cellText
{
    return self.tvwTitle.text;
}

- (void)setContent:(NSString *)content {
    self.tvwTitle.text = content;
    [self.placeholderLabel setHidden:[content length]];
}

- (void)textViewDidChange
{
    self.placeholderLabel.hidden = [self.tvwTitle text].length;
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:needreload:)])
    {
        [self.delegate textViewCell:self didChangeText:self.tvwTitle.text needreload:NO];
    }
}


- (CGFloat)getHeight
{
    CGSize size = [self.tvwTitle.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 13 - kNewApplyAddApplyTitleCellTitleViewLeftMargin,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.tvwTitle.font} context:NULL].size;
    if (size.height + 30 > 44)
    {
        return size.height + 30;
    }
    else
    {
        return 44;
    }
}

- (UITableView *)tableView
{
    
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}




#pragma mark - init
- (UITextView *)tvwTitle
{
    if (!_tvwTitle) {
        NSTextStorage* textStorage = [[NSTextStorage alloc] init];
        NSLayoutManager* layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        textContainer.widthTracksTextView = YES;
        [layoutManager addTextContainer:textContainer];
        _tvwTitle.textColor = [UIColor blackColor];
        _tvwTitle = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
        _tvwTitle.font = [UIFont systemFontOfSize:15];
        _tvwTitle.tag = 222;
        _tvwTitle.delegate = self;
        [_tvwTitle addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _tvwTitle;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
        _placeholderLabel.userInteractionEnabled = NO;
    }
    return _placeholderLabel;
}@end
