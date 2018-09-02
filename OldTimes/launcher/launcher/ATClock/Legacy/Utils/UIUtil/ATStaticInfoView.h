//
//  ATStaticInfoView.h
//  Clock
//
//  Created by Dariel on 16/7/21.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATStaticInfoView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *infoLabel;

-(instancetype)initWithImage:(UIImage *)image andMessage:(NSString *)message;

@end
