//
//  NewEditingProjectViewController.m
//  launcher
//
//  Created by TabLiu on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewEditingProjectViewController.h"
#import "MyDefine.h"
#import "ChatGroutAvatarsTableViewCell.h"
#import "UIColor+Hex.h"
#import "NewProjectDetailRequest.h"
#import "NewProjectEditRequest.h"
#import <MintcodeIM/MintcodeIM.h>
#import "ContactPersonDetailInformationModel.h"
#import "SelectContactBookViewController.h"
#import "NewProjectDeleteRequest.h"


@interface NewEditingProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ChatGroutAvatarsTableViewCellDelegate,UITextFieldDelegate,BaseRequestDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITextField * textField ;

@property (nonatomic,strong) ProjectDetailModel * model ;

@property (nonatomic,strong) NSMutableArray * membersArray;

@property (nonatomic,copy) delectBlock  deleBlock;
@property (nonatomic,copy) changeProjectName changeBlock ;

@end

@implementation NewEditingProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LOCAL(MISSION_EDITPROJECT);
    
    
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:LOCAL(SAVE) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem setLeftBarButtonItem:btnLeft];
    [self.navigationItem setRightBarButtonItem:btnRight];
    
    
    [self initView];
    
    [self getProjectDetailRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.textField endEditing:YES];
}
- (void)resignKeyBoard
{
    [self.textField endEditing:YES];
}

- (void)setDeleProjectBlock:(delectBlock)block
{
    self.deleBlock = block;
}
- (void)setChangeProjectName:(changeProjectName)changeBlock
{
    self.changeBlock = changeBlock;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save
{
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * addArray = [NSMutableArray array];
    for (UserProfileModel * model in self.model.members) {
        if ([self.membersArray containsObject:model.userName]) {
            // 不变
            [array addObject:model.userName];
            continue;
        }else {
            // 增加
            [addArray addObject:model];
            continue;
        }
    }
    for (NSString * model in array) {
        [self.membersArray removeObject:model]; // 如果还有剩下的,就是delete
    }
    NSLog(@"----> %@",_textField.text);
    
    NewProjectEditRequest * request = [[NewProjectEditRequest alloc] initWithDelegate:self];
    request.showId = self.model.showId;
    request.name = _textField.text;
    request.addArray = addArray;
    request.deleArray = self.membersArray;
    
    [request requestData];
    [self postLoading];
}

- (void)addMembers:(NSArray *)array
{
    for (ContactPersonDetailInformationModel *person in array) {
        UserProfileModel * model = [UserProfileModel new];
        model.nickName = person.u_true_name;
        model.userName = person.show_id;
        [self.model.members addObject:model];
    }
    [self.tableView reloadData];
}
- (void)delectMembers:(UserProfileModel *)model
{
    for (UserProfileModel *model1 in self.model.members) {
        if ([model.userName isEqualToString:model1.userName]) {
            // 删除
            [self.model.members removeObject:model1];
            [self.tableView reloadData];
            return;
        }
    }
}

#pragma mark - ProjectDetailRequest
- (void)getProjectDetailRequest
{
    NewProjectDetailRequest * Request= [[NewProjectDetailRequest alloc] initWithDelegate:self];
    [Request detailShowId:_showId];
    [self postLoading];
}

- (void)projectDeleteRequest
{
    NewProjectDeleteRequest * request = [[NewProjectDeleteRequest alloc] initWithDelegate:self];
    request.showId = _showId;
    [request requestData];
    [self postLoading];
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewProjectDetailRequest class]]) {
        
        self.model = [(NewProjectDetailResponse *)response model];
        self.membersArray = [self.model.UID_Array mutableCopy];
        [self.tableView reloadData];
    }else if ([request isKindOfClass:[NewProjectEditRequest class]]) {
        
        NewProjectEditRequest * requ = (NewProjectEditRequest *)request;
        if (![requ.name isEqualToString:self.model.name]) { // 工程名改变
            if (self.changeBlock) {
                self.changeBlock(requ.name);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([request isKindOfClass:[NewProjectDeleteRequest class]]) {
        if (self.deleBlock) {
            self.deleBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self hideLoading];
}
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - delect
- (void)cellButtonClick
{
    [self projectDeleteRequest];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSString * str = @"";
//    str = textField.text;
//    if ([self.model.name isEqualToString:str]) {
//        return;
//    }
//    self.model.name = str;
}

#pragma mark - ChatGroutAvatarsTableViewCellDelegate
// 增加
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_addPeople
{
    NSMutableArray *arrNickName = [NSMutableArray array];
    for (UserProfileModel *profileModel in self.model.members)
    {
        ContactPersonDetailInformationModel *person = [ContactPersonDetailInformationModel new];
        person.show_id = profileModel.userName;
        person.u_true_name = profileModel.nickName;
        [arrNickName addObject:person];
    }
    NewEditingProjectViewController * weakSelf = self;
    SelectContactBookViewController *createGroupVC = [[SelectContactBookViewController alloc] initWithSelectedPeople:nil unableSelectPeople:arrNickName];
    createGroupVC.selectType = selectContact_none;
    [createGroupVC selectedPeople:^(NSArray *array) {
        [weakSelf addMembers:array];
    }];
    [self presentViewController:createGroupVC animated:YES completion:nil];
}

// 删除
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_deletePeopleWithProfile:(UserProfileModel *)model
{
    [self delectMembers:model];
}

// 点击查看那个人信息
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_personDetailClicked:(UserProfileModel *)model
{
    
}
#pragma mark - UITableViewDataSource,UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Identifier = @"avatars";
    static NSString * name = @"name";
    static NSString * delect = @"delect";
    
    if (indexPath.section == 1) {
        ChatGroutAvatarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell = [[ChatGroutAvatarsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            [cell setDelegate:self];
        }
        [cell setPersonData:self.model.members isHost:YES];
        return cell;
    }else if (indexPath.section == 0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
            _textField = [[UITextField alloc] init];
            _textField.delegate = self;
            [cell.contentView addSubview:_textField];
            _textField.frame = CGRectMake(10, 0, IOS_SCREEN_WIDTH - 10, 44);
        }
        NSString * str = @"";
        str = self.model.name;
        _textField.text = str;
        return cell;
    }else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:delect];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:delect];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[self imageColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
            [button setTitle:LOCAL(NEWMISSION_DELETE_PROJECT) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cellButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            
            [button setFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, 44)];
        }
        return cell;
    }
}

- (UIImage *)imageColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ColorImg;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 15;
            break;
            
        case 1:
            return 45;
            break;
            
        case 2:
            return 28;
            break;
            
        default:
            break;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger count = (IOS_SCREEN_WIDTH - 26 + interitemSpacing) / (collectionCellWidth + interitemSpacing);
        CGFloat height = ((self.model.members.count + 1) / count) * (collectionCellheight + lineSpacing) + collectionCellheight + 36;
        return height;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    if (section == 1) {
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = LOCAL(NEWMISSION_MEMBER);
        [view addSubview:label];
        label.frame = CGRectMake(10, 0, IOS_SCREEN_WIDTH-10, 45);
        label.userInteractionEnabled = YES;
    }
    return view;
}


- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
