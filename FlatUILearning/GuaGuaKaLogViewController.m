//
//  GuaGuaKaLogViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-9-26.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GuaGuaKaLogViewController.h"
#import "SVPullToRefresh.h"
#import "GuaGuaKaLog.h"
#import "TTDate.h"

@interface GuaGuaKaLogViewController ()
@property (nonatomic,assign) int pageNo;
@end

@implementation GuaGuaKaLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _pageNo=1;
    [self.slidingViewController setAnchorLeftPeekAmount:20];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    //下拉刷新
    __weak GuaGuaKaLogViewController *weakSelf=self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        _pageNo=1;
        [weakSelf reloadGuaGuaKaList];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        _pageNo++;
        [weakSelf reloadGuaGuaKaList];
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新兑换记录" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"释放开始刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setArrowColor:GREEN_COLOR];
    [self.tableView.pullToRefreshView setTextColor:GREEN_COLOR];
    //[weakSelf reloadGuaGuaKaList];
	
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pageNo=1;
    [self reloadGuaGuaKaList];
}

-(void) reloadGuaGuaKaList 
{
    __weak GuaGuaKaLogViewController *weakSelf=self;
    [GuaGuaKaLog getGuaGuaKaLogWithPageNo:_pageNo OnSuccess:^(id array) {

        
        
        if (_pageNo==1) {
            self.dataArray=array;
            [self.tableView.pullToRefreshView stopAnimating];
        }else{
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];

        }
        if ([array count]<40) {
            weakSelf.tableView.showsInfiniteScrolling=NO;
        }else
            weakSelf.tableView.showsInfiniteScrolling=YES;
        [weakSelf.tableView reloadData];
    } failure:^(id error) {
        [AppUtilities handleErrorMessage:error];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];

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
    GuaGuaKaLog *guaguakaLog=[self.dataArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [UITableViewCell configureFlatCellWithColor:[UIColor whiteColor] selectedColor:GREEN_COLOR style:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setSeparatorHeight:1  ];
        
        
        UILabel *mainLable = [TTLabel createLabeWithTxt:[NSString stringWithFormat:@"%d金币刮刮卡",guaguakaLog.benjin] Frame:CGRectMake(20, 0, 300, 35) Font:[UIFont boldFlatFontOfSize:17] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        
        
        mainLable.tag=520;
        mainLable.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:mainLable];
        
        UILabel *amountLable=[TTLabel createLabeWithTxt:[AppUtilities DateStringFromDateTime:[TTDate dateWithString:guaguakaLog.postDate dateFormatter:dateFormatterUntilSSS]] Frame:CGRectMake(20, 28, 85, 24) Font:[UIFont flatFontOfSize:13] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        amountLable.tag=521;
        amountLable.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:amountLable];
        
        UILabel *stateLable=[TTLabel createLabeWithTxt:[NSString stringWithFormat:@"奖金:%d金币",guaguakaLog.resultValue] Frame:CGRectMake(200, 14, 85, 24) Font:[UIFont boldFlatFontOfSize:15] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        stateLable.tag=522;
        stateLable.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:stateLable];
    }else{
        UILabel *mainLable=(UILabel *)[cell.contentView viewWithTag:520];
        mainLable.text=[NSString stringWithFormat:@"%d金币刮刮卡",guaguakaLog.benjin];
        
        UILabel *amountLable = (UILabel *)[cell.contentView viewWithTag:521];
        amountLable.text=[AppUtilities DateStringFromDateTime:[TTDate dateWithString:guaguakaLog.postDate dateFormatter:dateFormatterUntilSSS]];
        
        UILabel *stateLable = (UILabel *)[cell.contentView viewWithTag:522];
        stateLable.text=[NSString stringWithFormat:@"奖金:%d金币",guaguakaLog.resultValue];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
