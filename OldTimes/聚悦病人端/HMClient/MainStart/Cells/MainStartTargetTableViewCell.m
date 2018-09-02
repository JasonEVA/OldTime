//
//  MainStartTargetTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartTargetTableViewCell.h"

@interface MainStartTargetCell : UIControl
{
    UILabel* lbName;
    UILabel* lbTarget;
    UILabel* lbActual;
    UIView* vCircle;
    
    UIImageView* ivCircleBoarder;
    UIView* vTargetLine;
}

- (void) setTarget:(MainStartHealthTarget*) target;
@end

@implementation MainStartTargetCell

- (id) init
{
    self = [super init];
    if (self)
    {
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setTextColor:[UIColor colorWithHexString:@"444444"]];
        [lbName setFont:[UIFont font_30]];
        
        [lbName setHidden:YES];
        
        vCircle = [[UIView alloc]init];
        [self addSubview:vCircle];
        [vCircle setHidden:YES];
        [vCircle setUserInteractionEnabled:NO];
        ivCircleBoarder = [[UIImageView alloc]init];
        [vCircle addSubview:ivCircleBoarder];
        
        
        lbActual = [[UILabel alloc]init];
        [vCircle addSubview:lbActual];
        [lbActual setTextColor:[UIColor colorWithHexString:@"444444"]];
        [lbActual setFont:[UIFont systemFontOfSize:36]];
        [self subviewLayout];
        
        lbTarget = [[UILabel alloc]init];
        [vCircle addSubview:lbTarget];
        [lbTarget setTextColor:[UIColor colorWithHexString:@"1A8A49"]];
        [lbTarget setFont:[UIFont font_26]];
        
        vTargetLine = [[UIView alloc]init];
        [vCircle addSubview:vTargetLine];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(15);
    }];
    
    [vCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(102, 102));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-16.5);
    }];
    
    [ivCircleBoarder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(vCircle);
        make.center.equalTo(vCircle);
    }];
    
    [lbActual mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vCircle);
        make.top.equalTo(vCircle).with.offset(35);
    }];
    
    [lbTarget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vCircle);
        make.top.equalTo(vCircle).with.offset(11);
    }];
    
    [vTargetLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vCircle);
        make.top.equalTo(vCircle);
        make.height.mas_equalTo(@8);
        make.width.mas_equalTo(@1);
    }];
}

- (void) setTarget:(MainStartHealthTarget*) target
{
    [lbName setHidden:!target];
    [vCircle setHidden:!target];
    [lbName setText:target.subKpiName];
    [lbActual setTextColor:[target targetColor]];
    if ([CommonFuncs isInteger:target.testValue])
    {
        [lbActual setText:[NSString stringWithFormat:@"%ld", (NSInteger)target.testValue]];
    }
    else
    {
        [lbActual setText:[NSString stringWithFormat:@"%.1f", target.testValue]];
    }
    
    if ([CommonFuncs isInteger:target.targetValue])
    {
        [lbTarget setText:[NSString stringWithFormat:@"目标 %ld", (NSInteger)target.targetValue]];
    }
    else
    {
        [lbTarget setText:[NSString stringWithFormat:@"目标 %.1f", target.targetValue]];
    }
    
    float rate = 0;
    if (0 < target.targetValue) {
        rate = target.testValue/target.targetValue;
    }
    [ivCircleBoarder setImage:[self circleBoarderTargetImage:CGSizeMake(102, 102) Color:[target targetColor] BoarderWidth:3 Rate:rate]];
    [vTargetLine setBackgroundColor:[target targetColor]];
}

- (UIImage*) circleBoarderTargetImage:(CGSize) size
                                Color:(UIColor*) color
                         BoarderWidth:(CGFloat) boarderWidth
                                 Rate:(CGFloat)rate
{
    size.width *= 2;
    size.height *= 2;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width , size.height );
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    
    //绘制大圆
    
    float radius = size.width;
    if (radius < size.height)
    {
        radius = size.height;
    }
    
    float radiusin = size.width;
    if (radiusin > size.height)
    {
        radiusin = size.height;
    }
    
    radius = radius/2 - boarderWidth;
    
    CGFloat red, green, blue, alpha;
    
    [[UIColor colorWithHexString:@"DDDDDD"] getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, boarderWidth * 2);
    
    CGContextAddArc(context, size.width/2, size.height/2, radius, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, boarderWidth * 2);
    
    CGContextAddArc(context, size.width/2, size.height/2, radius, M_PI/2, M_PI * rate + M_PI/2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //CGContextClosePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

}
@end


@interface MainStartTargetTableViewCell ()
{
    NSArray* targets;
    NSMutableArray* targetcells;
}
@end

@implementation MainStartTargetTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //[self.contentView setBackgroundColor:[UIColor lightGrayColor]];
    
        targetcells = [NSMutableArray array];
        for(NSInteger index = 0; index < 3; ++index)
        {
            MainStartTargetCell* cell = [[MainStartTargetCell alloc]init];
            [self.contentView addSubview:cell];
            [targetcells addObject:cell];
            //[cell setBackgroundColor:[UIColor blueColor]];
            MainStartTargetCell* perCell = nil;
            if (0 < index)
            {
                perCell = targetcells[index - 1];
            }
            
            
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self.contentView);
                if (!perCell)
                {
                    make.left.equalTo(self.contentView);
                }
                else
                {
                    make.left.equalTo(perCell.mas_right);
                    make.width.equalTo(perCell);
                }
                
                if (2 == index)
                {
                    make.right.equalTo(self.contentView);
                }
                
            }];
         
        }
    }
    
    
    return self;
}

- (void) setTargetItems:(NSArray*) targetItems
{
    
    targets = [NSArray arrayWithArray:targetItems];
    NSInteger maxCount = targetcells.count;
    if (targets.count < maxCount)
    {
        maxCount = targets.count;
    }
    
    for (NSInteger index = 0; index < maxCount; ++index)
    {
        MainStartTargetCell* cell = targetcells[index];
        MainStartHealthTarget* target = targets[index];
        [cell addTarget:self action:@selector(targetItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell setTarget:target];
    }
}

- (void) targetItemClicked:(id) sender
{
    
    
    if (![sender isKindOfClass:[MainStartTargetCell class]])
    {
        return;
    }
    MainStartTargetCell* clickedCell = (MainStartTargetCell*) sender;
    NSInteger clickedIndex = [targetcells indexOfObject:clickedCell];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    MainStartHealthTarget* target = targets[clickedIndex];
    NSString* kpiCode = target.kpiCode;
    NSString* controllerName = nil;
    if (!kpiCode || 0 == kpiCode.length)
    {
        return;
    }
    if ([kpiCode isEqualToString:@"XY"])
    {
        //血压
        controllerName = @"BodyPressureDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血压"];
    }
    else if ([kpiCode isEqualToString:@"TZ"])
    {
        //体重
        controllerName = @"BodyWeightDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－体重"];
    }
    else if ([kpiCode isEqualToString:@"XT"])
    {
        //血糖
        controllerName = @"BloodSugarDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血糖"];
    }
    else if ([kpiCode isEqualToString:@"XL"])
    {
        //心率
        controllerName = @"ECGDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－心率"];
    }
    else if ([kpiCode isEqualToString:@"XZ"])
    {
        //血脂
        controllerName = @"BloodFatDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血脂"];
    }
    else if ([kpiCode isEqualToString:@"OXY"])
    {
        //血氧
        controllerName = @"BloodOxygenDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血氧"];
    }
    else if ([kpiCode isEqualToString:@"NL"])
    {
        //尿量
        controllerName = @"UrineVolumeDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－尿量"];
    }
    else if ([kpiCode isEqualToString:@"HX"])
    {
        //呼吸
        controllerName = @"BreathingDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－呼吸"];
    }
    
    if (!controllerName || 0 == controllerName.length)
    {
        return;
    }
    
//    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:nil];
}


@end
