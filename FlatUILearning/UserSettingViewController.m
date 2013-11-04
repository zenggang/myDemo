//
//  UserSettingViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "UserSettingViewController.h"
#import "ExchangeNOSettingViewController.h"
#import "goldIntroductionViewController.h"
#import "WeiXinAwardViewController.h"
#import "WeiXinShareViewCenterController.h"
#import "ChangeColorViewController.h"

@interface UserSettingViewController ()



@end

@implementation UserSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"用户设置";

    
    
    [self createNavigationLeftButtonWithTitle:@"菜单"  action:@selector(showMenuLeft)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (APPDELEGATE.deviceToken==nil) {
        [APPDELEGATE registPushNotification];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( APPDELEGATE.appVersionInfo.isHide==1 && indexPath.section==0 && indexPath.row==2) {
        return 0;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   if (section==0)
       return 20;
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; 
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==0) {
            return 5;
        }else
            return 4;
        
    }else
        return 4;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identity =@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    
    if (!cell) {
        cell = [UITableViewCell configureFlatCellWithColor:GREEN_COLOR selectedColor:[UIColor whiteColor] style:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setSeparatorHeight:1 forColor:[UIColor whiteColor]];
        UILabel *amountLable=[TTLabel createLabeWithTxt:@"＞" Frame:CGRectMake(250, 14, 40, 24) Font:[UIFont boldFlatFontOfSize:20] textColor:[UIColor whiteColor] backGroudColor:[UIColor clearColor]];
        amountLable.tag=520;
        amountLable.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:amountLable];
        
        UILabel *describeLable=[TTLabel createLabeWithTxt:@"" Frame:CGRectMake(150, 14, 120, 24) Font:[UIFont boldFlatFontOfSize:13] textColor:[UIColor whiteColor] backGroudColor:[UIColor clearColor]];
        describeLable.tag=521;
        describeLable.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:describeLable]; 
    }
    NSString *text = @"";
    UIView *accessView =[cell.contentView viewWithTag:520];
    accessView.hidden=NO;
    UILabel *describeLable =(UILabel *)[cell.contentView viewWithTag:521];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                text=@"兑换号码设置";
                describeLable.text=@"兑换时需要";
            }
                break;
            case 1:
            {
                if (APPDELEGATE.loginUser.qq.length>0) {
                    accessView.hidden=YES;
                    describeLable.text=[NSString stringWithFormat:@"已绑定:%@",APPDELEGATE.loginUser.qq];
                }else{
                    describeLable.text=@"只能绑定一次";
                }
                text=@"绑定联系QQ";
            }
                break;
            case 2:
            {
                int gold=30+(APPDELEGATE.loginUser.awardQqCount * 5 > 20 ? 20:APPDELEGATE.loginUser.awardQqCount * 5);
                text=@"领取推荐金币";
                describeLable.text=[NSString stringWithFormat:@"当前可领%d金币",gold ];
            }
                break;
            case 3:{
                text=@"关注官方微信公共号";
                describeLable.text=@"送30金币";
            }
                break;
            case 4:{
                text=@"评5星送金币";
                describeLable.text=@"规则内详";
            }
                break;
        }
    }else{
        switch (indexPath.row) {
        case 0:
            {
                text=@"帮朋友快速安装";
                describeLable.text=@"得推荐金币";
            }
                break;
        case 1:
            {
                text=@"分享到微信赚金币";
                describeLable.text=@"送12金币";
            }
                break;
        case 2:
        {
            text=@"切换颜色主题";
            describeLable.text=[APPDELEGATE.colorDict objectForKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"sysColor"]];
        }
            break;
        case 3:
        {
            text=@"开启消息推送";
            describeLable.text= APPDELEGATE.deviceToken==nil ?  @"未开启":@"已开启";
           
        }
            break;
        }
        
    }

    cell.textLabel.text=text;
    cell.textLabel.font=[UIFont boldFlatFontOfSize:17];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            ExchangeNOSettingViewController *exNoSettingVc=[self.storyboard instantiateViewControllerWithIdentifier:@"exchangeNOSettingViewController"];
            exNoSettingVc.formType=FormtypeExchangeNumberType;
            [self.navigationController pushViewController:exNoSettingVc animated:YES];
        }else if(indexPath.row==1){
            if (!(APPDELEGATE.loginUser.qq.length>0)) {
                ExchangeNOSettingViewController *exNoSettingVc=[self.storyboard instantiateViewControllerWithIdentifier:@"exchangeNOSettingViewController"];
                exNoSettingVc.formType=FormtypeBingdingQqType;
                [self.navigationController pushViewController:exNoSettingVc animated:YES];
            }
        }else if (indexPath.row==2){
            ExchangeNOSettingViewController *exNoSettingVc=[self.storyboard instantiateViewControllerWithIdentifier:@"exchangeNOSettingViewController"];
            exNoSettingVc.formType=FormtypeAwardGoldType;
            [self.navigationController pushViewController:exNoSettingVc animated:YES];
        }else if (indexPath.row==3){
            WeiXinAwardViewController *weixinVc=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinAwardViewController"];
            weixinVc.describeType=DescribeTypeWeiXin;
            [self.navigationController pushViewController:weixinVc animated:YES];
        }else if (indexPath.row==4){
            WeiXinAwardViewController *weixinVc=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinAwardViewController"];
            weixinVc.describeType=DescribeTypeFiveStar;
            [self.navigationController pushViewController:weixinVc animated:YES];
        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            WeiXinAwardViewController *weixinVc=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinAwardViewController"];
            weixinVc.describeType=DescribeTypeShareToFriens;
            [self.navigationController pushViewController:weixinVc animated:YES];
        }else if (indexPath.row==1) {
            WeiXinShareViewCenterController *weiXinShareGoldVC=[self.storyboard instantiateViewControllerWithIdentifier:@"WeiXinShareViewCenterController"];
            [self.navigationController pushViewController:weiXinShareGoldVC animated:YES]; 
        }else if (indexPath.row==2){
            ChangeColorViewController *changeColorVc =[self.storyboard instantiateViewControllerWithIdentifier:@"changeColorViewController"];
            [self.navigationController pushViewController:changeColorVc animated:YES];
        }else if (indexPath.row==3){
            
            if(APPDELEGATE.deviceToken==nil){
                [self showFUIAlertViewWithTitle:@"提示" message:@"您关闭了推送服务,强烈建议您打开此服务,当有兑换完成或者金币赠送时能及时提醒您查收,手动打开方式(去设置-通知中找到程序然后打开.)" withTag:-1 cancleButtonTitle:@"好的!" otherButtonTitles: nil];
            }
        }
    }
}
@end
