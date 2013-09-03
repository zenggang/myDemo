//
//  GetGoldLogViewContrller.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GetGoldLogViewContrller.h"
#import "UserGetGoldDetail.h"
#import "TTDate.h"
#import "goldIntroductionViewController.h"
#import "SVPullToRefresh.h"

@interface GetGoldLogViewContrller()
{
    
}

@property (nonatomic,assign) int pageNo;
@end

@implementation GetGoldLogViewContrller
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.title=@"任务记录";
    [self createNavigationLeftButtonWithTitle:@"菜单"  action:@selector(showMenuLeft)];
    //self.tableView.separatorColor=[UIColor midnightBlueColor];
    _pageNo=1;
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    __weak GetGoldLogViewContrller *weakSelf=self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        _pageNo++;
        [weakSelf reloadGetGoldData];
    }];
    [self.tableView addPullToRefreshWithActionHandler:^{
        _pageNo=1;
        [weakSelf reloadGetGoldData];
    }];
    [self reloadGetGoldData];
    //下拉刷新
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新金币记录" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"释放开始刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setArrowColor:GREEN_COLOR];
    [self.tableView.pullToRefreshView setTextColor:GREEN_COLOR];
    self.tableView.contentInset=UIEdgeInsetsMake(60, 0, 0, 0);
}


-(void) reloadGetGoldData
{
    __weak GetGoldLogViewContrller *weakSelf=self;
    [UserGetGoldDetail getUserGetGoldLogOnSuccess:^(NSMutableArray *array) {
        [SVProgressHUD dismiss];
        if (_pageNo==1) {
            weakSelf.dataArray=array;
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }else{
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id error) {
        [AppUtilities handleErrorMessage:error];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    } pageNo:_pageNo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[goldIntroductionViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"goldIntroductionViewController"];
    }
    
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark tableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identity =@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    UserGetGoldDetail *goldDetail=[self.dataArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [UITableViewCell configureFlatCellWithColor:[UIColor whiteColor] selectedColor:GREEN_COLOR style:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setSeparatorHeight:1  ];
        UILabel *amountLable=[TTLabel createLabeWithTxt:[AppUtilities DateStringFromDateTime:[TTDate dateWithString:goldDetail.postDate dateFormatter:dateFormatterUntilSSS]] Frame:CGRectMake(220, 14, 85, 24) Font:[UIFont flatFontOfSize:13] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        amountLable.tag=520;
        amountLable.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:amountLable];
    }else{
        UILabel *amountLable = (UILabel *)[cell.contentView viewWithTag:520];
        amountLable.text=[AppUtilities DateStringFromDateTime:[TTDate dateWithString:goldDetail.postDate dateFormatter:dateFormatterUntilSSS]];
    }
    if (goldDetail.meno && goldDetail.meno.length>0) {
        cell.textLabel.text=[NSString stringWithFormat:@"%@获得%d金币",goldDetail.meno,goldDetail.goldAmount];
    } else {
        cell.textLabel.text=[NSString stringWithFormat:@"%@获得%d金币",goldDetail.pCnName,goldDetail.goldAmount];
    }
    
    cell.textLabel.textColor=GREEN_COLOR;
    cell.textLabel.font=[UIFont boldFlatFontOfSize:17];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
