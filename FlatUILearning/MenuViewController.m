//
//  MenuViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-18.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "ZuanZuanZuanViewController.h"
#import "MenuViewController.h"
#import "DaZuanPanViewController.h"
#import "YaoQianZuanViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

#pragma mark system
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
    
    [self.slidingViewController setAnchorRightRevealAmount:220.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.tableView.frame=CGRectMake(0, 0, 320, mainScreenHeight-20);
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    //self.tableView.separatorColor=[UIColor midnightBlueColor];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    
    self.dataArray=[NSMutableArray arrayWithArray:@[APP_FIRST_TAB_NAME,@"免费赚金币",@"金币兑现金",@"金币记录",@"我的设置"]];
    
    _scoreView.backgroundColor=[UIColor turquoiseColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkFirstLogin:) name:USER_IS_FIRST_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewFromNotice:) name:CHANGE_VIEW_TO_IDENTIFIER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkFirstLogin:) name:USER_CREATED_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkFirstLogin:) name:APPINFO_DID_LOADED object:nil];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_IS_FIRST_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPINFO_DID_LOADED object:nil];
}

#pragma mark customer

-(void) checkFirstLogin:(NSNotification *) notify
{
    if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==1) {
        self.dataArray=[NSMutableArray arrayWithArray:@[APP_FIRST_TAB_NAME,@"推荐给朋友",@"换礼物",@"推荐记录",@"我的设置"]];
    }
    [self.tableView reloadData];
}

-(void) changeViewFromNotice:(NSNotification *) notify
{
    NSString *identifier=[notify.userInfo objectForKey:@"identifier"];
    
    if ([notify.userInfo objectForKey:@"ischangeColor"]) {
        [self.tableView reloadData];
    }
    
    [self changeViewToIdentifier:identifier isStoryBord:YES];
}

-(void) changeViewToIdentifier:(NSString *) identifier isStoryBord:(BOOL) isStoryBord
{
    UIViewController *newTopViewController=nil;
    
    if (isStoryBord) {
         newTopViewController= [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    }else{
        if ([identifier isEqualToString:@"DaZuanPanViewController"]) {
            newTopViewController = [[DaZuanPanViewController alloc] initWithNibName:@"DaZuanPanViewController" bundle:nil];
        }else if([identifier isEqualToString:@"ZuanZuanZuanViewController"]){
            newTopViewController = [[ZuanZuanZuanViewController alloc] initWithNibName:@"ZuanZuanZuanViewController" bundle:nil];
        }else if([identifier isEqualToString:@"YaoQianZuanViewController"]){
            newTopViewController = [[YaoQianZuanViewController alloc] initWithNibName:@"YaoQianZuanViewController" bundle:nil];
        }
    }
    
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

#pragma mark tableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([AppUtilities isIOS7]) {
        return 20;
    }else
        return 0;
}


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
    
    UITableViewCell *cell= [UITableViewCell configureFlatCellWithColor:[UIColor whiteColor] selectedColor:GREEN_COLOR style:UITableViewCellStyleDefault reuseIdentifier:identity];
    [cell setSeparatorHeight:1.0  ];
    if (APPDELEGATE.isFirstTime && indexPath.row==1) {
        if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==1) {
             cell.textLabel.text=@"推荐给朋友";
        }else{
            cell.textLabel.text=@"免费赚金币(神秘礼物)";
        }
        cell.textLabel.textColor=[UIColor redColor];
    }else{
        cell.textLabel.text=self.dataArray[indexPath.row];
        cell.textLabel.textColor=GREEN_COLOR;
         
    }
    cell.textLabel.font=[UIFont boldFlatFontOfSize:18];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    NSString *identifier = @"";
    BOOL isStoryBord=YES;
    switch (indexPath.row) {
        case 0:
        {
            identifier = @"firstViewController";
            if ([APP_NAME isEqualToString:APPNAME_GUAGUALE]) {
                identifier=@"guagualeViewController";
            }else if ([APP_NAME isEqualToString:APPNAME_ZuanZuanZuan]){
                identifier=@"ZuanZuanZuanViewController";
                isStoryBord=NO;
            }else if ([APP_NAME isEqualToString:APPNAME_DAZUANPAN]){
                identifier=@"DaZuanPanViewController";
                isStoryBord=NO;
            }else if ([APP_NAME isEqualToString:APPNAME_YAOQIANZUAN]){
                identifier=@"YaoQianZuanViewController";
                isStoryBord=NO;
            }
        }
            break;
        case 1:
        {
            identifier = @"GetGoldViewController";
        }
            break;
            case 2:
        {
            identifier=@"goldExchangeViewController";
        }
            break;
        case 3:
        {
            identifier=@"getGoldLogViewContrller";
        }
            break;
            case 4:
        {
            identifier=@"settingViewController";
        }break;
        default:
            break;
    }

    if (APPDELEGATE.isFirstTime) {
        [self changeViewToIdentifier:@"GetGoldViewController" isStoryBord:isStoryBord];
    }else
        [self changeViewToIdentifier:identifier isStoryBord:isStoryBord];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
