//
//  HMSecondEditionSelectPayCardView.m
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionSelectPayCardView.h"
#import "UIImage+EX.h"
#import "HMPingAnPayCardModel.h"

@interface HMSecondEditionSelectPayCardView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *selectPayWayLb;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, copy) shotBlock block;
@property (nonatomic, copy) NSArray <HMPingAnPayCardModel* >*dataList;

@end
@implementation HMSecondEditionSelectPayCardView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.tableView];
        [self addSubview:self.selectPayWayLb];
        [self addSubview:self.editBtn];
        [self addSubview:self.backBtn];
        [self addSubview:self.confirmPayBtn];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(10);
        }];
        
        [self.selectPayWayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.backBtn);
        }];
        
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self.backBtn);
        }];
        
        [self.confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.height.equalTo(@45);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backBtn.mas_bottom).offset(10);
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.confirmPayBtn.mas_top);
        }];
        
        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
        [self.backBtn setTransform:transform];
        
    }
    return self;
}

- (void)fillDataWithArray:(NSArray<HMPingAnPayCardModel *> *)array {
    self.dataList = array;
    [self updateUI];
}

- (void)updateUI {
    if (self.dataList.count) {
        self.selectedCard = self.dataList[0];
    }
    [self.editBtn setSelected:NO];
    [self.editBtn setHidden:!self.dataList.count];
    [self.confirmPayBtn setEnabled:self.dataList.count != 0];
    [self.tableView reloadData];
}
- (void)btnClick:(shotBlock)block {
    self.block = block;
}

- (void)clickbutton:(UIButton *)button {
    if (button.tag == 1) {
        //编辑
        self.editBtn.selected ^= 1;
        [self.confirmPayBtn setEnabled:!self.editBtn.selected];
        [self.tableView reloadData];
    }
    else {
        if (self.block) {
            self.block(button.tag);
        }
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count + !self.editBtn.selected;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
       if (self.dataList.count == indexPath.row) {
           static NSString *ID = @"Cell";
           cell = [tableView dequeueReusableCellWithIdentifier:ID];
           if (!cell) {
               cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
               [cell setSeparatorInset:UIEdgeInsetsZero];
               if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                   [cell setLayoutMargins:UIEdgeInsetsZero];
               }
               [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
           }

        [cell.imageView setImage:[UIImage imageNamed:@"pay_addCardIcon"]];
        [cell.textLabel setText:@"使用新卡付款"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        static NSString *myID = @"myCell";
        cell = [tableView dequeueReusableCellWithIdentifier:myID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myID];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        HMPingAnPayCardModel *model = self.dataList[indexPath.row];
        UIImageView *accessView;
        if (!self.editBtn.selected) {
             accessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_unselect"] highlightedImage:[UIImage imageNamed:@"pay_selected"]];
        }
        else {
             accessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_deleteCardIcon"]];
        }
        
        [accessView setHighlighted:[self.selectedCard.openId isEqualToString:model.openId]];
        NSString *cardType;
        if ([model.bankType isEqualToString:@"01"]) {
            cardType = @"借记卡";
        }
        else {
            cardType = @"信用卡";
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"%@(%@)-%@",model.plantBankName,model.accNo,cardType]];
        [cell setAccessoryView:accessView];
        
        NSRange range = NSMakeRange(0, model.plantBankId.length - 2);
        NSString *bankID = [model.plantBankId substringWithRange:range];
        UIImage *iconImage = [UIImage imageNamed:bankID];
        if (!iconImage) {
            iconImage = [UIImage imageNamed:@"defoultCard"];
        }
        [cell.imageView setImage:iconImage];

    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataList.count == indexPath.row) {
        if ([self.delegate respondsToSelector:@selector(HMSecondEditionSelectPayCardViewDelegateCallBack_addCard)]) {
            [self.delegate HMSecondEditionSelectPayCardViewDelegateCallBack_addCard];
        }
    }
    else {
        HMPingAnPayCardModel *card = self.dataList[indexPath.row];
        if (self.editBtn.selected) {
            if ([self.delegate respondsToSelector:@selector(HMSecondEditionSelectPayCardViewDelegateCallBack_deleteCard:)]) {
                [self.delegate HMSecondEditionSelectPayCardViewDelegateCallBack_deleteCard:card];
            }
        }
        else {
            if ([self.selectedCard.openId isEqualToString:card.openId]) {
                return;
            }
            self.selectedCard = card;
            [self.tableView reloadData];
        }
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setRowHeight:60];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
    }
    return _tableView;
}

- (UILabel *)selectPayWayLb {
    if (!_selectPayWayLb) {
        _selectPayWayLb = [UILabel new];
        [_selectPayWayLb setFont:[UIFont font_30]];
        [_selectPayWayLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_selectPayWayLb setText:@"选择支付方式"];
    }
    return _selectPayWayLb;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton new];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitle:@"取消编辑" forState:UIControlStateSelected];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"31c9ba"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setTag:1];
    }
    return _editBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"payicon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTag:0];
    }
    return _backBtn;
}
- (UIButton *)confirmPayBtn {
    if (!_confirmPayBtn) {
        _confirmPayBtn = [UIButton new];
        [_confirmPayBtn setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"45cec1"] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [_confirmPayBtn setTitle:@"确定支付" forState:UIControlStateNormal];
        [_confirmPayBtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmPayBtn setTag:2];
    }
    return _confirmPayBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
