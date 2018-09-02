//
//  ChatSearchViewController.m
//  launcher
//
//  Created by Jason Wang on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatSearchViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "Images.h"
#import "MessageListCell.h"
#import "FileTableViewCell.h"
#import "AppMessageTableViewCell.h"
#import "ChatSearchResultViewController.h"
#import "MyDefine.h"
#import "ApplicationMessageSearchListViewController.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "ContactBookGetUserListRequest.h"
#import "NSDictionary+SafeManager.h"
#import "ContactBookNameTableViewCell.h"
#import "ChatSingleViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ChatSearchMoreViewController.h"
#import <MintcodeIM/MintcodeIM.h>


@interface ChatSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UILabel *myTitle;         // title
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *messageView; // 消息 icon
@property (nonatomic, strong) UIImageView *annexView;   // 附件 icon
@property (nonatomic, strong) UIImageView *appView;     // 应用 icon
@property (nonatomic, strong) UILabel *messageLabel;    // 消息 lab
@property (nonatomic, strong) UILabel *annexLabel;      // 附件 lab
@property (nonatomic, strong) UILabel *appLabel;        // 应用 lab
@property (nonatomic, strong) NSMutableDictionary  *dictResult; // <##>
@property (nonatomic, strong) MessageBaseModel *model;
@property (nonatomic, strong) UserProfileModel *userModel;


@end

static NSString *keyContact = @"contact";
static NSString *keyChatHistory = @"chatHistory";

@implementation ChatSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.myTableView];
    [self.navigationItem setTitleView:self.mySearchBar];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [cancel setTintColor:[UIColor themeBlue]];
    [self.navigationItem setRightBarButtonItem:cancel];
    
    [self.view addSubview:self.myView];
    [self.myView addSubview:self.myTitle];
    [self.myView addSubview:self.line];
    [self.myView addSubview:self.messageView];
    [self.myView addSubview:self.messageLabel];
    [self.myView addSubview:self.annexView];
    [self.myView addSubview:self.annexLabel];
    [self.myView addSubview:self.appView];
    [self.myView addSubview:self.appLabel];
    [self.mySearchBar becomeFirstResponder];
    
    [self initConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.mySearchBar becomeFirstResponder];
//    if (self.isquerySearch) {
//        //全局搜索数据源
//        self.arrayResult = [[[MessageManager share] querySearchMessageListWithKeyword:self.mySearchBar.text] mutableCopy];
//    }
//    else
//    {
//        //非全局搜索结果数据源
//        self.arrayResult = [[[MessageManager share] querySearchMessageListWithKeyword:self.mySearchBar.text uid:self.uidStr] mutableCopy];
//    }

    [self.myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mySearchBar endEditing:YES];
}

#pragma mark - Event Response
- (void)cancelClick
{
    [self.mySearchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.mySearchBar endEditing:YES];
}

- (void)initConstraints {
    [self.myTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
       
    }];
    
    [self.myView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    
    /*--- new ---*/
    
    [self.myTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(120);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTitle.mas_bottom).offset(20);
        make.left.equalTo(self.messageLabel.mas_left);
        make.right.equalTo(self.appLabel.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.annexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(23);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.equalTo(@23);
    }];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(23);
        make.right.equalTo(self.annexView.mas_left).offset(-55);
        make.width.height.equalTo(@23);
    }];
    [self.appView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(23);
        make.left.equalTo(self.annexView.mas_right).offset(55);
        make.width.height.equalTo(@23);
    }];
    
    [self.annexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.annexView.mas_bottom).offset(13);
        make.centerX.equalTo(self.annexView.mas_centerX);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView.mas_bottom).offset(13);
        make.centerX.equalTo(self.messageView.mas_centerX);
    }];
    [self.appLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appView.mas_bottom).offset(13);
        make.centerX.equalTo(self.appView.mas_centerX);
    }];
}

#pragma mark - Data Helper
- (NSArray *)getArrayWithSection:(NSInteger)section
{
    NSArray *arrData = [self.dictResult objectForKey:@(section)];
    return arrData;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dictResult.allKeys.count;
}

//设置头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *arrData = [self getArrayWithSection:section];
    if (section == searchResultType_contact)
    {
        // 非全局不搜用户
        if (!self.isquerySearch)
        {
            return 0;
        }
    }
    
    if (arrData.count > 0)
    {
        return 30;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *arrData = [self getArrayWithSection:section];
    if (section == searchResultType_contact)
    {
        // 非全局不搜用户
        if (!self.isquerySearch)
        {
            return 0;
        }
    }
    
    if (arrData.count > 0 && section == searchResultType_contact)
    {
        return 10;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arrData = [self getArrayWithSection:section];
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor whiteColor]];
    NSArray *arrTitle = @[LOCAL(SEARCH_CONTACT),LOCAL(SEARCH_HISTORY)];
    if (arrData.count > 0)
    {
        UILabel *lbHead = [UILabel new];
        [lbHead setBackgroundColor:[UIColor whiteColor]];
        [lbHead setTextColor:[UIColor themeGray]];
        [lbHead setFont:[UIFont mtc_font_26]];
        [lbHead setText:arrTitle[section]];
        [view addSubview:lbHead];
        [lbHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0,14,0,0));
        }];
    }
    
    return view;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrData = [self getArrayWithSection:section];
    if (section == searchResultType_contact)
    {
        // 非全局不搜用户
        if (!self.isquerySearch)
        {
            return 0;
        }
    }
    
    if (arrData.count >= 5 && section == searchResultType_contact)
    {
        return arrData.count + 1;
    }
    else
    {
        return arrData.count;
    }
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrData = [self getArrayWithSection:indexPath.section];
    if (indexPath.row == arrData.count)
    {
        return 30;
    }
    else
    {
        return 60;
    }
}
//设置单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrData = [self getArrayWithSection:indexPath.section];
    
    UILongPressGestureRecognizer *pressDr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGRRespond:)];
    [pressDr setDelegate:self];
    
    UITableViewCell *myCell = nil;
    // 查看更多
    if (indexPath.row == arrData.count)
    {
        static NSString *ID = @"lookMoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont mtc_font_26]];
        }
        
        NSString *title;
        if (indexPath.section == 0)
        {
            title = LOCAL(SEARCH_MORECONTACT);
        }
//        else
//        {
//            title = @"查看更多聊天记录";
//        }
        [cell.textLabel setText:title];
        return cell;
    }
    else if (indexPath.section == searchResultType_chatHistory)
    {
        if (arrData) {
            self.model = arrData[indexPath.row];
            if (self.model._type == msg_personal_text || self.model._type == msg_personal_file) {
                
                static NSString *ID = @"myCell";
                FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                    [cell addGestureRecognizer:pressDr];
                }
                [cell setSeparatorInset:UIEdgeInsetsZero];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                [cell setCellData:self.model searchText:self.mySearchBar.text];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if([self.model isEventType])
            {
                static NSString *ID = @"Cell";
                AppMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[AppMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                    //[cell addGestureRecognizer:pressDr];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                        [cell setLayoutMargins:UIEdgeInsetsZero];
                    }
                }

                //[cell setCellData:self.model];
                [cell setSearchCellData:self.model searchText:self.mySearchBar.text];
                
                return cell;
                
            }
        }
    }
    else
    {
        myCell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
        [(ContactBookNameTableViewCell *)myCell setDataWithModel:arrData[indexPath.row]];
        [((ContactBookNameTableViewCell *)myCell) setSearchText:self.mySearchBar.text];
    }
    
    return myCell;
}

//点击搜索结果弹出所有聊天记录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrData = [self getArrayWithSection:indexPath.section];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == arrData.count)
    {
        ChatSearchMoreViewController *searchMoreVC = [[ChatSearchMoreViewController alloc] initWithSearchType:indexPath.section SearchText:self.mySearchBar.text];
        [self.navigationController pushViewController:searchMoreVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        MessageBaseModel *model = arrData[indexPath.row];
        NSString * target = model._target;
        if ([target isEqualToString:@"PWP16jQLLjFEZXLe@APP"]) {
            [self pushEventListViewcontrollTitle:LOCAL(Application_Mission) target:target sqlid:model._msgId creatDate:model._createDate type:IM_Applicaion_task];
            return;
        }else if ([target isEqualToString:@"ADWpPoQw85ULjnQk@APP"]){
            [self pushEventListViewcontrollTitle:LOCAL(APPLY_ACCEPT_ACCEPTBTN_TITLE) target:target sqlid:model._msgId creatDate:model._createDate type:IM_Applicaion_approval];
            return;
        }else if ([target isEqualToString:@"l6b3YdE9LzTnmrl7@APP"]) {
            [self pushEventListViewcontrollTitle:LOCAL(Application_Calendar) target:target sqlid:model._msgId creatDate:model._createDate type:IM_Applicaion_schedule];
            return;
        }
        else {
            [self pushChatListViewControllWith:indexPath];
        }
    }
    else
    {
        ContactPersonDetailInformationModel *infoModel = arrData[indexPath.row];
        
        if ([[[UnifiedUserInfoManager share] userShowID] isEqualToString:infoModel.show_id]) {
            return;
        }
        
        ContactDetailModel *model = [[ContactDetailModel alloc] init];
        model._target   = infoModel.show_id;
        model._nickName = infoModel.u_true_name;
        
        ChatSingleViewController *singleVC = [[ChatSingleViewController alloc] initWithDetailModel:model];
        [self.navigationController pushViewController:singleVC animated:YES];
    }
}

- (void)pushEventListViewcontrollTitle:(NSString *)string target:(NSString *)target sqlid:(NSInteger)sqlid creatDate:(long long)creatDate type:(IM_Applicaion_Type)type
{
    ApplicationMessageSearchListViewController * applicationVC = [[ApplicationMessageSearchListViewController alloc] initWithAppType:type];
    applicationVC.uidStr = target;
    applicationVC.msgid = sqlid;
    applicationVC.creatDate = creatDate;
    applicationVC.titleString = string;
    [self.navigationController pushViewController:applicationVC animated:YES];
}

- (void)pushChatListViewControllWith:(NSIndexPath *)indexPath
{
    ChatSearchResultViewController *searchResultVC = [[ChatSearchResultViewController alloc] init];
    NSArray *arrData = [self getArrayWithSection:indexPath.section];
    self.model = arrData[indexPath.row];
    searchResultVC.IsGroup = [ContactDetailModel isGroupWithTarget:self.model._target];
    if (self.isquerySearch) {
        [searchResultVC setStrUid:self.model._target];
        self.userModel = [[MessageManager share] queryContactProfileWithUid:self.model._target];
    }
    else
    {
        [searchResultVC setStrUid:self.uidStr];
        self.userModel = [[MessageManager share] queryContactProfileWithUid:self.uidStr];
        
        
    }
    [searchResultVC setStrName:self.userModel.nickName];
    searchResultVC.sqlId = self.model._sqlId;
    searchResultVC.msgid = self.model._msgId;
    [self.navigationController pushViewController:searchResultVC animated:YES];

}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length != 0) {
        [self.myTableView setHidden:NO];
        [self.myView setHidden:YES];
        
        ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        request.pageIndex = 1;
        request.pageSize = 5;
        [request getUserWithSearchKey:searchBar.text];
        
        NSArray *arrayResult;
        if (self.isquerySearch) {
            //全局搜索数据源
            arrayResult = [[MessageManager share] querySearchMessageListWithKeyword:searchBar.text];
        }
        else
        {
            //非全局搜索结果数据源
            arrayResult = [[MessageManager share] querySearchMessageListWithKeyword:searchBar.text uid:self.uidStr];
        }
        [self.dictResult setObject:arrayResult forKey:@(searchResultType_chatHistory)];
        
        [self postLoading];
    }
    else
    {
        [self.myTableView setHidden:YES];
        [self.myView setHidden:NO];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length != 0) {
        [self.myTableView setHidden:NO];
        [self.myView setHidden:YES];

        ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        request.pageIndex = 1;
        request.pageSize = 5;
        [request getUserWithSearchKey:searchBar.text];
        
        NSArray *arrayResult;
        if (self.isquerySearch) {
            //全局搜索数据源
            arrayResult = [[MessageManager share] querySearchMessageListWithKeyword:searchBar.text];
        }
        else
        {
            //非全局搜索结果数据源
            arrayResult = [[MessageManager share] querySearchMessageListWithKeyword:searchBar.text uid:self.uidStr];
        }
        [self.dictResult setObject:arrayResult forKey:@(searchResultType_chatHistory)];
        
        [self postLoading];
    }
    else
    {
        [self.myTableView setHidden:YES];
        [self.myView setHidden:NO];
    }
}

#pragma mark - 手势

- (void)pressGRRespond:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UITableViewCell * cell = (UITableViewCell *)longPress.view;
        NSIndexPath * path = [self.myTableView indexPathForCell:cell];
        
        NSArray *arrData = [self.dictResult objectForKey:@(searchResultType_chatHistory)];
        // 得到消息体
        MessageBaseModel *baseModel = arrData[path.row];

        
        if (baseModel._type > msg_usefulMsgMin && baseModel._type < msg_personal_alert ) {
            [self showActionSheetWithTag:path.row isMark:baseModel._markImportant];
        }
        
    }
}


- (void)showActionSheetWithTag:(NSInteger)tag isMark:(BOOL)mark
{
    [self.mySearchBar endEditing:YES];
    NSString * str;
    if (mark) {
        str = LOCAL(CANCLE_MARK_EMPHASIS);
    }else {
        str = LOCAL(MAKE_MARK);
    }
    
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(MESSAGE_COPY),str,nil];//,LOCAL(TO_SCHEDULE),LOCAL(TO_TASK),LOCAL(FROWARDING)
    [actSheet setActionSheetStyle:UIActionSheetStyleDefault];
    actSheet.tag = tag + 1000;
    [actSheet showInView:self.view];
}
#pragma mark - delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //复制
            [self copyMessage:actionSheet.tag - 1000];
        }
            break;
          
        case 1:
        {
            //标记,取消标记
            [self markMessage:actionSheet.tag - 1000];
        }
            break;
            
        case 2:
        {
            //转为日程
        }
            break;
            
        case 3:
        {
            //转为任务
        }
            break;
            
        case 4:
        {
            //转发
        }
            break;
            
        case 5:
        {
           //取消
        }
            break;
            
        default:
            break;
    }
}
/* 复制消息*/
- (void)copyMessage:(NSInteger)sender
{
    
    NSArray *arrData = [self.dictResult objectForKey:@(searchResultType_chatHistory)];
    // 得到消息体
    MessageBaseModel *baseModel = arrData[sender];

    // 复制消息
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // 判断是文字还是图片
    if (baseModel._type == msg_personal_text)
    {
        [pasteboard setString:baseModel._content];
    }
    else if (baseModel._type == msg_personal_image)
    {
        // 判断是接收的消息还是发送的消息
        NSString *strImg;
        if (baseModel._markFromReceive)
        {
            strImg = baseModel._nativeOriginalUrl;
            // FK，太BT了 http起头的URL进去后，pasteborad.string也会被设置，而pasteborad.string一旦有值就不会触发外层的paste:方法，只能伪装下URL；By Remon，以后有更好的方法可以自行修改；
            strImg = [NSString stringWithFormat:@"//%@",strImg];
        }
        else
        {
            strImg = baseModel._content;
        }
        [pasteboard setURL:[NSURL URLWithString:strImg]];
    }
}


/* 标记为重点 */
- (void)markMessage:(NSInteger)sender
{
    NSArray *arrData = [self.dictResult objectForKey:@(searchResultType_chatHistory)];
    // 得到消息体
    MessageBaseModel *baseModel = arrData[sender];
    /* 在这里进行标记操作 */
    MessageBaseModel * model = [[MessageBaseModel alloc] init];
    model._msgId = baseModel._msgId;
    [[MessageManager share] markMessage:baseModel];
    [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
    baseModel._markImportant ^= 1;
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:sender inSection:searchResultType_chatHistory];
    [self.myTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[ContactBookGetUserListRequest class]]) {
        NSMutableArray *arrContacts = ((ContactBookGetUserListResponce *)response).modelArr;

        for (ContactPersonDetailInformationModel *person in arrContacts) {
            if ([person.show_id isEqualToString:[[UnifiedUserInfoManager share] userShowID]]) {
                [arrContacts removeObject:person];
                break;
            }
        }
        
        [self.dictResult setObject:arrContacts forKey:@(searchResultType_contact)];
        [self hideLoading];
        [self.myTableView reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    [self.myTableView reloadData];
}


#pragma mark - UIScrollViewDelegate
//当有搜索内容的时候滚动视图隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.dictResult.allKeys.count > 0) {
        [self.mySearchBar resignFirstResponder];
    }
}

#pragma mark - InIt UI

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_myTableView setDataSource:self];
        [_myTableView setDelegate:self];
        [_myTableView setSeparatorInset:UIEdgeInsetsZero];
        [_myTableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
        if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_myTableView setTableFooterView: [[UIView alloc]init]];
        [_myTableView setBackgroundColor:[UIColor grayBackground]];
    }
    return _myTableView;
}

- (UISearchBar *)mySearchBar
{
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        [_mySearchBar setPlaceholder:@"                                                                          "];
        [_mySearchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [_mySearchBar setDelegate:self];
        [_mySearchBar setBarTintColor:[UIColor blackColor]];
    
        
    }
    return _mySearchBar;
}

- (UIView *)myView
{
    if (!_myView) {
        _myView = [[UIView alloc] init];
        [_myView setBackgroundColor:[UIColor grayBackground]];
    }
    return _myView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _line;
}

- (UILabel *)myTitle
{
    if (!_myTitle) {
        _myTitle = [[UILabel alloc] init];
        [_myTitle setFont:[UIFont systemFontOfSize:20]];
        [_myTitle setText:LOCAL(SEARCH_MESSAGECONTENT)];
        [_myTitle setTextColor:[UIColor lightGrayColor]];
        [_myTitle setTextAlignment:NSTextAlignmentCenter];
    }
    return _myTitle;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setFont:[UIFont systemFontOfSize:16]];
        [_messageLabel setTextColor:[UIColor lightGrayColor]];
        [_messageLabel setText:LOCAL(HOMETABBAR_MESSAGE)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;;
    }
    return _messageLabel;
}

- (UILabel *)annexLabel
{
    if (!_annexLabel) {
        _annexLabel = [[UILabel alloc] init];
        [_annexLabel setFont:[UIFont systemFontOfSize:16]];
        [_annexLabel setTextColor:[UIColor lightGrayColor]];
        [_annexLabel setText:LOCAL(APPLY_ADD_ATTACHMENT_TITLE)];
        _annexLabel.textAlignment = NSTextAlignmentCenter;;
    }
    return _annexLabel;
}

- (UILabel *)appLabel
{
    if (!_appLabel) {
        _appLabel = [[UILabel alloc] init];
        [_appLabel setFont:[UIFont systemFontOfSize:16]];
        [_appLabel setTextColor:[UIColor lightGrayColor]];
        [_appLabel setText:LOCAL(HOMETABBAR_APPLICATION)];
        _appLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _appLabel;
}

- (UIImageView *)messageView
{
    if (!_messageView) {
        _messageView = [[UIImageView alloc] init];
        //[_messageView setBackgroundColor:[UIColor redColor]];
        [_messageView setImage:[UIImage imageNamed:IMG_CHAT_SEARCH_MESSAGE]];
    }
    return _messageView;
}

- (UIImageView *)annexView
{
    if (!_annexView) {
        _annexView = [[UIImageView alloc] init];
       // [_annexView setBackgroundColor:[UIColor redColor]];
        [_annexView setImage:[UIImage imageNamed:IMG_CHAT_SEARCH_ANNEX]];

    }
    return _annexView;
}


- (UIImageView *)appView
{
    if (!_appView) {
        _appView = [[UIImageView alloc] init];
       // [_appView setBackgroundColor:[UIColor redColor]];
        [_appView setImage:[UIImage imageNamed:IMG_CHAT_SEARCH_APP]];

    }
    return _appView;
}

- (NSMutableDictionary *)dictResult
{
    if (!_dictResult)
    {
        _dictResult = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    
    return _dictResult;
}


- (MessageBaseModel *)model
{
    if (!_model) {
        _model = [[MessageBaseModel alloc] init];
    }
    return _model;
}

- (UserProfileModel *)userModel
{
    if (!_userModel) {
        
        _userModel = [[UserProfileModel alloc] init];
    }
    return _userModel;
}
@end
