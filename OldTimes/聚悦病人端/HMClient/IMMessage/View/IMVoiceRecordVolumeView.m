//
//  IMVoiceRecordVolumeView.m
//  HMClient
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMVoiceRecordVolumeView.h"

@interface IMVoiceRecordVolumeView ()
{
    UIImageView *ivVoice;
    NSMutableArray *soundBrickArray;
    UILabel *lbContent;
}

@end

@implementation IMVoiceRecordVolumeView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]];
        [self.layer setCornerRadius:8];
        [self.layer setMasksToBounds:YES];
        
        ivVoice = [[UIImageView alloc] init];
        [self addSubview:ivVoice];
        
        [ivVoice setAnimationImages:@[[UIImage imageNamed:@"voice_volume0"],
                                      [UIImage imageNamed:@"voice_volume1"],
                                      [UIImage imageNamed:@"voice_volume2"],
                                      [UIImage imageNamed:@"voice_volume3"],
                                      [UIImage imageNamed:@"voice_volume4"]]];
        
        ivVoice.animationDuration = 2.0;
        ivVoice.animationRepeatCount = 0;
        [ivVoice  startAnimating];
        
        
        soundBrickArray = [NSMutableArray array];
        for (int index = 0; index < 10; ++index)
        {
            UIView *ivSound = [[UIView alloc] init];
            [self addSubview:ivSound];
            [soundBrickArray addObject:ivSound];
            //[ivSound setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]];
            [ivSound mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(ivVoice.mas_right).with.offset(5);
                make.bottom.mas_equalTo(ivVoice.mas_bottom).with.offset(-(index*(4+3)));
                make.size.mas_equalTo(CGSizeMake(10+index*2, 4));
            }];
        }
        
        lbContent = [[UILabel alloc] init];
        [self addSubview:lbContent];
        [lbContent setText:@"正在录音……"];
        [lbContent setFont:[UIFont font_24]];
        [lbContent setTextColor:[UIColor whiteColor]];
        [lbContent setTextAlignment:NSTextAlignmentCenter];
        
        [self subViewsLayout];
    }
    return self;
}


- (void) subViewsLayout
{
    [ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.equalTo(self).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(58, 68));
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivVoice.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(20);
    }];
}

- (void) setSoundBrick:(int) soundBrick
{
    int topIndex = soundBrick/10;
    for (int index = 0; index < topIndex; ++index)
    {
        UIView *sound = [soundBrickArray objectAtIndex:index];
        [sound setBackgroundColor:[UIColor whiteColor]];
    }
    
    /*for (int index = topIndex; index < soundBrickArray.count; ++index)
    {
        UIView *sound = [soundBrickArray objectAtIndex:index];
        [sound setBackgroundColor:[UIColor lightGrayColor]];
    }*/
}

@end
