//
//  GoldExchangeLogViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-5.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GoldExchangeLogViewController.h"
#import "GoldExchangeLog.h"
#import "TTDate.h"
#import "SVPullToRefresh.h"

@interface GoldExchangeLogViewController()
{
    
}
@property (nonatomic,assign) int pageNo;
@end

@implementation GoldExchangeLogViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
   
    _pageNo=1;
    [self.slidingViewController setAnchorLeftPeekAmount:20];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    //下拉刷新
    __weak GoldExchangeLogViewController *weakelf=self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakelf reloadExchangeList];
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新兑换记录" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"释放开始刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setArrowColor:GREEN_COLOR];
    [self.tableView.pullToRefreshView setTextColor:GREEN_COLOR];
    
    [self reloadExchangeList];
}

-(void) reloadExchangeList
{
    [GoldExchangeLog getUserExchangeLogOnSuccess:^(NSMutableArray *array) {
        self.dataArray=array;
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(id error) {
        [AppUtilities handleErrorMessage:error]; 
        [self.tableView.pullToRefreshView stopAnimating];
    } pageNo:_pageNo];
}


#pragma mark tableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([AppUtilities isIOS7]) {
        return 20;
    }else
        return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identity =@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    GoldExchangeLog *goldExchangeLog=[self.dataArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [UITableViewCell configureFlatCellWithColor:[UIColor whiteColor] selectedColor:GREEN_COLOR style:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setSeparatorHeight:1  ];
        
        
        UILabel *mainLable = [TTLabel createLabeWithTxt:[NSString stringWithFormat:@"%@",goldExchangeLog.typeContent] Frame:CGRectMake(20, 0, 300, 35) Font:[UIFont boldFlatFontOfSize:17] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        
        
        mainLable.tag=520;
        mainLable.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:mainLable];
        
        UILabel *amountLable=[TTLabel createLabeWithTxt:[AppUtilities DateStringFromDateTime:[TTDate dateWithString:goldExchangeLog.postDate dateFormatter:dateFormatterUntilSSS]] Frame:CGRectMake(20, 28, 85, 24) Font:[UIFont flatFontOfSize:13] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        amountLable.tag=521;
        amountLable.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:amountLable];
        
        UILabel *stateLable=[TTLabel createLabeWithTxt:goldExchangeLog.state ==1 ? @"已兑现":@"待兑现" Frame:CGRectMake(200, 14, 85, 24) Font:[UIFont boldFlatFontOfSize:15] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        stateLable.tag=522;
        stateLable.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:stateLable];
    }else{
        UILabel *mainLable=(UILabel *)[cell.contentView viewWithTag:520];
        mainLable.text=[NSString stringWithFormat:@"%@",goldExchangeLog.typeContent];
        
        UILabel *amountLable = (UILabel *)[cell.contentView viewWithTag:521];
        amountLable.text=[AppUtilities DateStringFromDateTime:[TTDate dateWithString:goldExchangeLog.postDate dateFormatter:dateFormatterUntilSSS]];
        
        UILabel *stateLable = (UILabel *)[cell.contentView viewWithTag:522];
        stateLable.text=goldExchangeLog.state ==1 ? @"已兑现":@"待兑现";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
@end
