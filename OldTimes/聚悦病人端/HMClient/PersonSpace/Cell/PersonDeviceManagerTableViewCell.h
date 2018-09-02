//
//  PersonDeviceManagerTableViewCell.h
//  HMClient
//
//  Created by lkl on 16/4/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDeviceManagerTableViewCell : UITableViewCell

- (void)setDeviceImage:(NSString *)aImage deviceName:(NSString *)aName;
- (void)setdeviceSelectStatus:(BOOL)status;
- (void)setBraceletDeviceImage:(NSString *)aImage deviceName:(NSString *)aName selectStatusStr:(NSString *)str;

@end


@interface PersonSelectDefaultDeviceTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *deviceImage;;
@property(nonatomic, strong) UILabel *deviceName;
@property(nonatomic, strong) UILabel *defaultDeviceStatus;

- (void)setDeviceImage:(NSString *)aImage
            deviceName:(NSString *)aName;
- (void)setSelectDeviceStatus;
- (void)setDidDeselectDeviceStatus;
@end
