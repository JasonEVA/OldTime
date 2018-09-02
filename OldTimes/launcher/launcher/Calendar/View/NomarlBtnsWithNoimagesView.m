//
//  NomarlBtnsWithNoimagesView.m
//  launcher
//
//  Created by 马晓波 on 16/2/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NomarlBtnsWithNoimagesView.h"
#import <Masonry/Masonry.h>
#import "Triangle.h"
#import "MyDefine.h"
#define ButtonHeight 45

@interface NomarlBtnsWithNoimagesView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *contantView;
@property (nonatomic, strong) NSMutableArray *arrTitles;
@property (nonatomic, strong) NSMutableArray *arrLogos;
@property (nonatomic, strong) NSMutableArray *arrBtns;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *subview;
@property (nonatomic, strong) Triangle *triview;
@property (nonatomic) CGSize maxsize;
@property (nonatomic, strong) NSArray *arrEditLogos;
@property (nonatomic, strong) NSArray *arrEditTitles;
@property (nonatomic, strong) NSArray *arrDealLogos;
@property (nonatomic, strong) NSArray *arrDealTitles;

@end

@implementation NomarlBtnsWithNoimagesView

-(instancetype)initWithArrayLogos:(NSArray *)arraylogo arrayTitles:(NSArray *)arrayTitle
{
    if (self = [super init])
    {
        self.canappear = NO;
        self.maxsize = CGSizeZero;
        self.frame = self.contantView.frame;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contantView];
        UITapGestureRecognizer *point = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdismess)];
        [self.contantView addGestureRecognizer:point];
        self.triview = [[Triangle alloc]initWithFrame:CGRectZero];
        [self.subview addSubview:self.triview];
        [self.triview drawNow];
        [self addSubview:self.subview];
        [self.subview addSubview:self.tableview];
        [self bringSubviewToFront:self.tableview];
        [self.arrLogos addObjectsFromArray:arraylogo];
        [self.arrTitles addObjectsFromArray:arrayTitle];
        [self getmaxsize:arrayTitle];
        [self Setframes];
        
    }
    return self;
}

-(instancetype)initWithArrayTitles:(NSArray *)arrayTitle
{
    if (self = [super init])
    {
        self.canappear = NO;
        self.maxsize = CGSizeZero;
        self.frame = self.contantView.frame;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contantView];
        UITapGestureRecognizer *point = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdismess)];
        [self.contantView addGestureRecognizer:point];
        self.triview = [[Triangle alloc]initWithFrame:CGRectZero];
        [self.subview addSubview:self.triview];
        [self.triview drawNow];
        [self addSubview:self.subview];
        [self.subview addSubview:self.tableview];
        [self bringSubviewToFront:self.tableview];
        [self.arrTitles addObjectsFromArray:arrayTitle];
        [self getmaxsize:arrayTitle];
        [self Setframes];
        
    }
    return self;
}

#pragma Privite Methods
- (void)Setframes
{
    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.bottom.right.equalTo(self.tableview);
        make.left.equalTo(self.tableview).offset(-1);
        make.right.equalTo(self.tableview).offset(1);
        make.bottom.equalTo(self.tableview).offset(1);
        make.top.equalTo(self).offset(1);
    }];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subview).offset(5);
        make.right.equalTo(self).offset(-12);
        make.height.equalTo(@(ButtonHeight*self.arrTitles.count));
        if (self.maxsize.width > 130)
        {
            make.width.equalTo(@200);
        }else
        {
            make.width.equalTo(@(self.maxsize.width + 70));
        }
    }];
    
    
    [self.triview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subview).offset(0);
        make.right.equalTo(self.subview).offset(-20);
        make.height.equalTo(@5);
        make.width.equalTo(@9);
    }];
    
}

- (void)setpassbackBlock:(passbackblock)block
{
    self.backblock = block;
}

- (void)tapdismess
{
    [UIView animateWithDuration:0.4 animations:^{
        //        self.contantView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subview).offset(5);
            make.right.equalTo(self).offset(-12);
            make.height.equalTo(@0);
            if (self.maxsize.width > 130)
            {
                make.width.equalTo(@170);
            }else
            {
                make.width.equalTo(@(self.maxsize.width + 40));
            }
        }];
    } completion:^(BOOL finished) {
        self.canappear = YES;
        [self removeFromSuperview];
    }];
}

- (void)appear
{
    //    self.contantView.frame = CGRectZero;
    [UIView animateWithDuration:0.4 animations:^{
        //        self.contantView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subview).offset(5);
            make.right.equalTo(self).offset(-12);
            make.height.equalTo(@(ButtonHeight*self.arrTitles.count));
            if (self.maxsize.width > 130)
            {
                make.width.equalTo(@200);
            }else
            {
                make.width.equalTo(@(self.maxsize.width + 70));
            }
        }];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        float width = self.tableview.bounds.size.width;
        float height = self.tableview.bounds.size.height;
        float x = self.tableview.bounds.origin.x;
        float y = self.tableview.bounds.origin.y;
        
        CGPoint leftUp = self.tableview.bounds.origin;
        CGPoint rightUp = CGPointMake(x + width, y);
        CGPoint leftDown = CGPointMake(x, y + height);
        CGPoint rightDown = CGPointMake(x + width, y + height);
        
        [path moveToPoint:leftUp];
        [path addLineToPoint:leftDown];
        [path addLineToPoint:rightDown];
        [path addLineToPoint:rightUp];
        [path addLineToPoint:leftUp];
        path.lineWidth = 1.5;
        
        self.tableview.layer.shadowPath = path.CGPath;
        
    } completion:^(BOOL finished) {
        self.canappear = NO;
    }];
}

- (CGSize)calcucateheightandwidthWithString:(NSString *)string
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell---test"];
    [cell.imageView setImage:[self.arrLogos objectAtIndex:0]];
    cell.textLabel.text = string;
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(cell.textLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.textLabel.font} context:NULL].size;
    return size;
}


- (void)getmaxsize:(NSArray *)array
{
    if (array.count>1)
    {
        self.maxsize = [self calcucateheightandwidthWithString:[array objectAtIndex:0]];
        for (NSInteger i = 1; i<array.count; i++)
        {
            CGSize nextsize = [self calcucateheightandwidthWithString:[array objectAtIndex:i]];
            if (self.maxsize.width > nextsize.width)
            {
                
            }
            else
            {
                self.maxsize = nextsize;
            }
        }
    }
    else
    {
        self.maxsize = [self calcucateheightandwidthWithString:[array objectAtIndex:0]];
    }
}


#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ButtonHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellID"];
    }
    [cell.imageView setImage:[self.arrLogos objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.arrTitles objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.backblock)
    {
        self.canappear = YES;
        [self removeFromSuperview];
        self.backblock(indexPath.row);
    }
    else
    {
        self.canappear = YES;
        [self removeFromSuperview];
    }
}
#pragma mark - init
- (UIView *)contantView
{
    if (!_contantView)
    {
        _contantView = [[UIView alloc] init];
        _contantView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_contantView setBackgroundColor:[UIColor clearColor]];
    }
    return _contantView;
}

- (UIView *)subview
{
    if (!_subview)
    {
        _subview = [[UIView alloc] init];
        [_subview setBackgroundColor:[UIColor clearColor]];
        _subview.layer.shadowColor = [UIColor blackColor].CGColor;
        _subview.layer.shadowOffset = CGSizeMake(0, 0);
        _subview.layer.shadowOpacity = 0.6;
        _subview.layer.cornerRadius = 2.5f;
        _subview.clipsToBounds = YES;
        //阴影圆角度数
        _subview.layer.shadowRadius = 1.0;
    }
    return _subview;
}

- (NSMutableArray *)arrTitles
{
    if (!_arrTitles)
    {
        _arrTitles = [[NSMutableArray alloc] init];
    }
    return _arrTitles;
}

//- (NSMutableArray *)arrBtns
//{
//    if (!_arrBtns)
//    {
//        _arrBtns = [[NSMutableArray alloc] init];
//    }
//    return _arrBtns;
//}

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.userInteractionEnabled = YES;
        _tableview.scrollEnabled = NO;
        _tableview.layer.masksToBounds = NO;
        _tableview.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
        _tableview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        _tableview.layer.shadowOpacity = 0.5f;
        _tableview.layer.cornerRadius = 4.0f;
        _tableview.clipsToBounds = YES;
        //阴影圆角度数
        _tableview.layer.shadowRadius = 10.0;
        //        _tableview.layer.borderWidth = 1.0f;
        //        _tableview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorInset = UIEdgeInsetsZero;
        
    }
    return _tableview;
}

- (NSArray *)arrDealLogos
{
    if (!_arrDealLogos)
    {
        _arrDealLogos = @[[UIImage imageNamed:@"backward-gray"],[UIImage imageNamed:@"X_gray"],[UIImage imageNamed:@"Accept"]];
    }
    return _arrDealLogos;
}

- (NSArray *)arrDealTitles
{
    if (!_arrDealTitles)
    {
        _arrDealTitles = @[LOCAL(APPLY_SENDER_BACKWARD_TITLE),LOCAL(APPLY_SENDER_UNACCEPT_TITLE),LOCAL(APPLY_SENDER_ACCEPT_TITLE)];
    }
    return _arrDealTitles;
}

- (NSArray *)arrEditLogos
{
    if (!_arrEditLogos)
    {
        _arrEditLogos = @[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]];
    }
    return _arrEditLogos;
}

- (NSArray *)arrEditTitles
{
    if (!_arrEditTitles)
    {
        _arrEditTitles = @[LOCAL(EDIT),LOCAL(MEETING_DELETE)];
    }
    return _arrEditTitles;
}

- (NSMutableArray *)arrLogos
{
    if (!_arrLogos)
    {
        _arrLogos = [[NSMutableArray alloc] init];
    }
    return _arrLogos;
}

@end
