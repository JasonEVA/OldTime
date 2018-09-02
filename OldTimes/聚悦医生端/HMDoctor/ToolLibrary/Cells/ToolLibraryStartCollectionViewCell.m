//
//  ToolLibraryStartCollectionViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ToolLibraryStartCollectionViewCell.h"

@implementation ToolLibraryStartGirdInfo

@end

@interface ToolLibraryStartCollectionViewCell ()
{
    UIImageView* ivGird;
    UILabel* lbName;
    
    UIView* bottomLine;
    UIView* rightLine;
    
    UIImageView* ivNoOpen;
}
@end

@implementation ToolLibraryStartCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        ivGird = [[UIImageView alloc]init];
        [self addSubview:ivGird];
        [ivGird setImage:[UIImage imageNamed:@"jibingzhinan"]];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        ivNoOpen = [[UIImageView alloc] init];
        [self addSubview:ivNoOpen];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivGird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(10);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(@16);
        make.top.equalTo(ivGird.mas_bottom).with.offset(10);
    }];
    
    [ivNoOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
}

- (void) setGirdImage:(NSString*) icon
             GirdName:(NSString*) name
{
    [ivGird setImage:[UIImage imageNamed:icon]];
    [lbName setText:name];
}

- (void) setNoOpenImage
{
    [ivNoOpen setImage:[UIImage imageNamed:@"icon_no_open_2"]];
}


@end
