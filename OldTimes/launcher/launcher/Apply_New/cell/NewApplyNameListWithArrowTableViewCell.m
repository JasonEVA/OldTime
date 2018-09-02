//
//  NewApplyNameListWithArrowTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyNameListWithArrowTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"
#import "UIColor+Hex.h"

#define imgWidth 25
#define imgHeigh 20
#define labelHeight 20
#define betspace 10
#define upspace 15
#define SizeFont [UIFont systemFontOfSize:15]


@interface NewApplyNameListWithArrowTableViewCell()
@property (nonatomic, strong) UIView *backview;
@property (nonatomic) CGFloat cellheight;
@end

@implementation NewApplyNameListWithArrowTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.backview];
        [self.contentView addSubview:self.lblTitle];
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
        [self.backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(15);
            make.height.equalTo(@20);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)getdataWithArray:(NSMutableArray *)array With:(NSString *)string
{
    NSDictionary *dict = @{@"USER_NAME": string};
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    [arr addObject:dict];
    [self getdataWithArray:arr];
}

- (void)getdataWithArray:(NSMutableArray *)array
{
//    NSArray *arr = @[@"颠三倒四",@"颠三倒四",@"打断",@"阿单位纷纷",@"颠三倒四的",@"速度速度",@"但是成分",@"车电掣"];

    CGFloat totalwidth = self.frame.size.width - 100 - 10;
    CGFloat hadwidth = 0;
    NSInteger line = 0;
    for (id object in self.backview.subviews)
    {
        [object removeFromSuperview];
    }
    for (NSInteger i = 0; i<array.count; i++)
    {
        //加名字
        NSString *string = [array[i] objectForKey:@"USER_NAME"];
        if ([self calculrateWidthWith:string] + 10 + hadwidth <= totalwidth)
        {
            UILabel *lblName;
            if (i == 0)
            {
                lblName = [[UILabel alloc] initWithFrame:CGRectMake(hadwidth, (upspace +labelHeight) *line, [self calculrateWidthWith:string], labelHeight)];
                hadwidth = hadwidth + [self calculrateWidthWith:string];
            }
            else
            {
                lblName = [[UILabel alloc] initWithFrame:CGRectMake(hadwidth + betspace, (upspace +labelHeight) *line, [self calculrateWidthWith:string], labelHeight)];
                hadwidth = hadwidth + betspace + [self calculrateWidthWith:string];
            }
            
            lblName.font = SizeFont;
            lblName.textAlignment = NSTextAlignmentCenter;
            [lblName setText:string];
            [self.backview addSubview:lblName];
        }
        else
        {
            line = line + 1;
			
            UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, (upspace + labelHeight) *line, [self calculrateWidthWith:string], labelHeight)];
            lblName.font = SizeFont;
            lblName.textAlignment = NSTextAlignmentCenter;
            [lblName setText:string];
            [self.backview addSubview:lblName];
            hadwidth = [self calculrateWidthWith:string];
            
        }
        
        //加箭头
        if (array.count != i + 1)
        {
            if (hadwidth + 10 + 25 <= totalwidth)
            {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(hadwidth + betspace, (upspace + imgHeigh) *line, imgWidth, imgHeigh)];
                [imgview setImage:[UIImage imageNamed:@"apply_pass"]];
                [self.backview addSubview:imgview];
                hadwidth = hadwidth + betspace + imgWidth;
            }
            else
            {
                line = line + 1;
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, (upspace + imgHeigh) *line, imgWidth, imgHeigh)];
                [imgview setImage:[UIImage imageNamed:@"apply_pass"]];
                [self.backview addSubview:imgview];
                hadwidth = imgWidth;
            }
        }
    }
    
    self.cellheight = (upspace + labelHeight) * (line + 1);
    
    [self.backview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(100);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@(self.cellheight));
    }];
}


- (CGFloat)calculrateWidthWith:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SizeFont} context:NULL].size;
    return size.width;
}

- (CGFloat)getHeight
{
    return self.cellheight + 15;
}

#pragma mark - init
- (UIView *)backview
{
    if (!_backview)
    {
        _backview = [[UIView alloc] init];
    }
    return _backview;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont mtc_font_30];
        _lblTitle.textColor = [UIColor minorFontColor];
    }
    return _lblTitle;
}
@end
