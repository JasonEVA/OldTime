//
//  ATStaticInfoView.m
//  Clock
//
//  Created by Dariel on 16/7/21.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATStaticInfoView.h"
#import "UIColor+ATHex.h"

@implementation ATStaticInfoView

-(instancetype)initWithImage:(UIImage *)image andMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        self.infoLabel = [[UILabel alloc]init];
        self.imageView.image = image;
        self.infoLabel.text = message;
        self.infoLabel.font = [UIFont systemFontOfSize:15.0];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor at_colorWithHex:0x999999];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
        [self addSubview:self.infoLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize label_size = [self.infoLabel.text sizeWithAttributes:@{NSFontAttributeName:self.infoLabel.font}];
    
    self.imageView.frame = CGRectMake(self.frame.size.width/2.0-50, self.frame.size.height/2.0-50 - label_size.height, 100, 100);
    
    self.infoLabel.frame = CGRectMake(self.frame.size.width/2.0-label_size.width/2, CGRectGetMaxY(self.imageView.frame), label_size.width, label_size.height);


}

@end
