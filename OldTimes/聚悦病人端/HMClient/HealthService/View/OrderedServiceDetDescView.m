//
//  OrderedServiceDetDescView.m
//  HMClient
//
//  Created by yinquan on 16/11/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderedServiceDetDescView.h"

@interface OrderedServiceDetDescView ()
{
    
}

@property (nonatomic, readonly) UITextView* descTextView;
@end

@implementation OrderedServiceDetDescView


- (id) init
{
    self = [super init];
    if (self) {
        UILabel* descTitleLabel = [[UILabel alloc] init];
        [self addSubview:descTitleLabel];
        [descTitleLabel setFont:[UIFont font_30]];
        [descTitleLabel setTextColor:[UIColor commonTextColor]];
        [descTitleLabel setText:@"产品介绍"];
        
        [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.top.equalTo(self).with.offset(15);
        }];
        
        _descTextView = [[UITextView alloc] init];
        [self addSubview:self.descTextView];
        [self.descTextView setFont:[UIFont font_26]];
        [self.descTextView setTextColor:[UIColor commonDarkGrayTextColor]];
        [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.right.equalTo(self).with.offset(-12.5);
            make.top.equalTo(descTitleLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(self).with.offset(-5);
        }];
        
    }
    return self;
}

- (void) setServiceDetDesc:(NSString*) detDesc
{
    [self.descTextView setText:detDesc];
}
@end
