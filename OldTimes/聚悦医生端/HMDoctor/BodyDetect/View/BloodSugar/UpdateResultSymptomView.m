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
        [_lbSymptom setTextColor:[UIColor commonTextColor]];
        [_lbSymptom setFont:[UIFont systemFontOfSize:13]];
        
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
}

- (void)setImage:(NSArray *)picUrls
{
    NSLog(@"%@",picUrls);
    for (int i = 0; i < picUrls.count; i++)
    {
        imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
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
