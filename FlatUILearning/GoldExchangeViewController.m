//
//  GoldExchangeViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GoldExchangeViewController.h"
#import "GoldExchangeType.h"
#import "GoldExchangeLogViewController.h"

@interface GoldExchangeViewController()

@property (nonatomic,weak) IBOutlet UILabel *goldLable;
@property (nonatomic,strong) DMScrollingTicker *scrollTextView;
-(void) buildScrollTextView;
@end



@implementation GoldExchangeViewController


-(void)viewDidLoad
{
    [_goldLable setText:[NSString stringWithFormat:@"%d",APPDELEGATE.userGoldAmont ]];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.title=@"金币兑换";
    [self createNavigationLeftButtonWithTitle:@"菜单"  action:@selector(showMenuLeft)];
    [self createNavigationRightButtonWithTitle:@"兑换记录"  action:@selector(showMenuRight)];
    _goldLable.font=[UIFont boldFlatFontOfSize:34];
    _goldLable.textColor=GREEN_COLOR;
    if (APPDELEGATE.appVersionInfo) {
        [GoldExchangeType getAllGoldExchangeTypesOnSuccess:^(NSMutableArray *array) {
            self.dataArray=array;
            [self.tableView reloadData];
        } failure:^(id error) {
        }];
    }

    [self buildScrollTextView];
}

-(void) buildScrollTextView
{
    if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==0) {
        if (_scrollTextView) {
            [_scrollTextView removeFromSuperview];
        }
        NSArray *textArray=APPDELEGATE.exchangeArrayForWall;
        if (([AppUtilities isIOS6] || [AppUtilities isIOS5]) && ([APP_NAME isEqualToString:APPNAME_ZuanZuanZuan] ||
                                                                 [APP_NAME isEqualToString:APPNAME_DAZUANPAN]  ||
                                                                 [APP_NAME isEqualToString:APPNAME_YAOQIANZUAN]) && !APPDELEGATE.isChangeStatusBarY){
            _scrollTextView =[self createTextScrollViewWithFrame:CGRectMake(0, 20, 320, 20) withTextArray:textArray];
        }else
            _scrollTextView =[self createTextScrollViewWithFrame:CGRectMake(0, 0, 320, 20) withTextArray:textArray];
        _scrollTextView.tag=786;
        [self.view addSubview:_scrollTextView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[GoldExchangeLogViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"goldExchangeLogViewController"];
    }
    
   // [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.tableView.frame=CGRectMake(0, 76, 320, mainScreenHeightWithoutBar-76);
}

#pragma mark ---customer Actions
-(void) afterGoldReloaded
{
    [super afterGoldReloaded];
    [_goldLable setText:[NSString stringWithFormat:@"%d",APPDELEGATE.userGoldAmont ]];
    if (APPDELEGATE.deviceToken==nil) {
        [APPDELEGATE registPushNotification];
    }
}

-(void)afterGoldReduced
{
    [_goldLable setText:[NSString stringWithFormat:@"%d",APPDELEGATE.userGoldAmont-self.reduceGoldType.goldAmount ]];
    self.reduceGoldType=nil;
    [super afterGoldReduced];
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
    GoldExchangeType *exchangeType=[self.dataArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [UITableViewCell configureFlatCellWithColor:[UIColor whiteColor] selectedColor:GREEN_COLOR style:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setSeparatorHeight:1  ];
        UILabel *amountLable=[TTLabel createLabeWithTxt:[NSString stringWithFormat:@"%d金币",exchangeType.goldAmount] Frame:CGRectMake(230, 14, 85, 24) Font:[UIFont flatFontOfSize:13] textColor:GREEN_COLOR backGroudColor:[UIColor clearColor]];
        amountLable.tag=520;
        [cell.contentView addSubview:amountLable];
    }
    UILabel *amountLable = (UILabel *)[cell.contentView viewWithTag:520];
    amountLable.text=[NSString stringWithFormat:@"%d金币",exchangeType.goldAmount];
    cell.textLabel.text=exchangeType.typeContent;
    cell.textLabel.textColor=GREEN_COLOR;
    cell.textLabel.font=[UIFont boldFlatFontOfSize:17];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    GoldExchangeType *exchangeType=[self.dataArray objectAtIndex:indexPath.row];
    if (APPDELEGATE.userGoldAmont>=exchangeType.goldAmount) {
        self.reduceGoldType=exchangeType;
        NSString *title=@"";
        NSString *message=@"";
        BOOL isExchangeNumberSetted=NO;
        if ([exchangeType.typeName isEqualToString:@"1zfb"]) {
            if (APPDELEGATE.loginUser.userExchangeNumber && APPDELEGATE.loginUser.userExchangeNumber.zhifubao.length>0) {
                title=@"支付宝兑换";
                message=[NSString stringWithFormat:@"是否确定要%@到您的支付宝账号:%@ ?",self.reduceGoldType.typeContent,APPDELEGATE.loginUser.userExchangeNumber.zhifubao];
                isExchangeNumberSetted=YES;
                self.exchangeNumber=APPDELEGATE.loginUser.userExchangeNumber.zhifubao;
            }else{
                title=@"未设置兑换账号";
                message=@"您的支付宝兑换账户尚未设定,现在就去设置吧!";
                isExchangeNumberSetted=NO;
            }
            
        }else if ([exchangeType.typeName isEqualToString:@"2cellPhone"]) {
            if (APPDELEGATE.loginUser.userExchangeNumber && APPDELEGATE.loginUser.userExchangeNumber.cellphone.length>0) {
                title=@"手机充值兑换";
                message=[NSString stringWithFormat:@"是否确定要%@到您的手机号码:%@ ?",self.reduceGoldType.typeContent,APPDELEGATE.loginUser.userExchangeNumber.cellphone];
                isExchangeNumberSetted=YES;
                self.exchangeNumber=APPDELEGATE.loginUser.userExchangeNumber.cellphone;
            }else{
                title=@"未设置兑换手机号码";
                message=@"您的手机充值手机号码尚未设定,现在就去设置吧!";
                isExchangeNumberSetted=NO;
            }
        }else if ([exchangeType.typeName isEqualToString:@"3qq"]) {
            if (APPDELEGATE.loginUser.userExchangeNumber && APPDELEGATE.loginUser.userExchangeNumber.qq.length>0) {
                title=@"QQ币充值兑换";
                message=[NSString stringWithFormat:@"是否确定要%@到您的QQ号码:%@ ?",self.reduceGoldType.typeContent,APPDELEGATE.loginUser.userExchangeNumber.qq];
                isExchangeNumberSetted=YES;
                self.exchangeNumber=APPDELEGATE.loginUser.userExchangeNumber.qq;
            }else{
                title=@"未设置兑换QQ号码";
                message=@"您的QQ币兑换QQ号码尚未设定,现在就去设置吧!";
                isExchangeNumberSetted=NO;
            }
        }
        
        if (isExchangeNumberSetted) {
            [self showFUIAlertViewWithTitle:title message:message withTag:exchangeGoldAlertTag cancleButtonTitle:@"算了,不兑了" otherButtonTitles:@"好的,确定!", nil];
        }else{
            [self showFUIAlertViewWithTitle:title message:message withTag:exchangeGoldNotSetNumberAlertTag cancleButtonTitle:@"好的!" otherButtonTitles:nil];
        }

        
    }else{
        [self showFUIAlertViewWithTitle:@"残念!" message:@"客官,您的金币不足!" withTag:goldNotEnoughAlertTag cancleButtonTitle:@"知道了" otherButtonTitles:nil];
    }
}

#pragma mark FUIAlerView delegate

-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag==exchangeGoldAlertTag)
    {
        if (buttonIndex==0) {
            [self reduceGold];
        }
    }else if (alertView.tag==goldNotEnoughAlertTag)
    {
        
    }else if(alertView.tag==ReduceGoldSuccessAlertTag){
        [self performSelector:@selector(reloadGoldAmount)];
    }else if(alertView.tag==exchangeGoldNotSetNumberAlertTag){
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"settingViewController",@"identifier", nil]];
    }
}
@end
