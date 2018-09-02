//
//  TrainingSelectBtn.h
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingSelectBtn : UIButton
@property (nonatomic, strong) UIImageView *myImageView;
- (instancetype)initWithTitel:(NSString *)titel tag:(NSInteger)tag;
- (void)setState:(BOOL)isSelect;
- (void)setMyTitel:(NSString *)titel;
@end
