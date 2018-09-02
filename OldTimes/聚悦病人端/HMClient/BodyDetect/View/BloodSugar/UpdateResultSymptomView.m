//
//  UpdateResultSymptomView.m
//  HMClient
//
//  Created by lkl on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UpdateResultSymptomView.h"

@interface UpdateResultSymptomView ()
{
    UIImageView *imgView;
    UILabel *lbLine;
}

@end

@implementation UpdateResultSymptomView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    
        imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];

        _lbSymptom = [[UILabel alloc] init];
        [self addSubview:_lbSymptom];
        [_lbSymptom setNumberOfLines:0];
        //[self setSymptom:@"吃水果太多了！"];
        [_lbSymptom setTextColor:[UIColor commonGrayTextColor]];
        [_lbSymptom setFont:[UIFont font_26]];
        
        _deleteButton = [[UIButton alloc] init];
        [self addSubview:_deleteButton];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont font_26]];
        [_deleteButton setTitleColor:[UIColor commonBlueColor] forState:UIControlStateNormal];
        
        lbLine = [[UILabel alloc] init];
        [self addSubview:lbLine];
        [lbLine setText:@"|"];
        [lbLine setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [lbLine setTextColor:[UIColor commonBlueColor]];
        
        _editButton = [[UIButton alloc] init];
        [self addSubview:_editButton];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont font_26]];
        [_editButton setTitleColor:[UIColor commonBlueColor] forState:UIControlStateNormal];
        
        [self subViewsLayout];
    }
    
    return self;
}

- (void)subViewsLayout
{
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [_lbSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(imgView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(60);
        make.right.equalTo(self).with.offset(-12.5);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbSymptom.mas_bottom).with.offset(5);
        make.right.equalTo(self).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    [lbLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbSymptom.mas_bottom).with.offset(5);
        make.right.equalTo(_deleteButton.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(3, 20));
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbSymptom.mas_bottom).with.offset(5);
        make.right.equalTo(lbLine.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];

}

- (void)setImage:(NSArray *)picUrls
{
    NSLog(@"%@",picUrls);
    for (int i = 0; i < picUrls.count; i++)
    {
        imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        
        [imgView sd_setImageWithURL:[picUrls objectAtIndex:i]];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.5+i*(47+5));
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
    }
}

- (void)setSymptom:(NSString *)symptom
{
    [_lbSymptom setText:symptom];
    [_lbSymptom mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo([_lbSymptom.text heightSystemFont:_lbSymptom.font width:300]+15);
    }];
}


@end

