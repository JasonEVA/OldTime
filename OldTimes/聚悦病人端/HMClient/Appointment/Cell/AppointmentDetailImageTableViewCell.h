//
//  AppointmentDetailImageTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppointmentDetailImageTableViewCellDelegate <NSObject>

- (void) appointmentDetailImageCell:(UITableViewCell*) cell ImageHeihgt:(CGFloat) imageHeihgt;

@end

@interface AppointmentDetailImageTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, weak) id<AppointmentDetailImageTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSInteger row;
- (void) setImageUrl:(NSString*) imageUrl;


@end

