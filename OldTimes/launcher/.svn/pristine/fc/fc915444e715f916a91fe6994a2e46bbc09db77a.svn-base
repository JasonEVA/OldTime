//
//  MeetingTextFieldTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTextFieldTableViewCell.h"
#import "Masonry.h"
#import "MyDefine.h"

@implementation MeetingTextFieldTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tfdTitle];
        
        [self.tfdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

#pragma mark - init
- (UITextField *)tfdTitle
{
    if (!_tfdTitle)
    {
        _tfdTitle = [[UITextField alloc] initWithFrame:CGRectZero];
        [_tfdTitle setTextColor:[UIColor blackColor]];
        _tfdTitle.font = [UIFont systemFontOfSize:15];
        _tfdTitle.textAlignment = NSTextAlignmentLeft;
        _tfdTitle.placeholder = LOCAL(MEETING_TITLE);
        _tfdTitle.returnKeyType = UIReturnKeyDone;
        _tfdTitle.clearButtonMode = YES;
    }
    return _tfdTitle;
}
@end
