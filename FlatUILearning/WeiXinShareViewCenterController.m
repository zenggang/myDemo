//
//  WeiXinShareViewCenterController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-9-9.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "WeiXinShareViewCenterController.h"
#import "TTDate.h"
#import "WeiXinGoldShareViewController.h"
#import "UserGold.h"
#import "UserGetGoldDetail.h"

#define SHOULD_SEND_Three_GOLD_TAG  565
@interface WeiXinShareViewCenterController ()
@property (nonatomic,weak) IBOutlet UILabel *titleLabele;

@property (nonatomic,strong) UIButton *shareAppToTimeLineButton;
@property (nonatomic,strong) UIButton *shareGoldToTimeLineButton;
@property (nonatomic,strong) UIButton *shareAppToFriendButton;
@property (nonatomic,strong) UIButton *shareGoldToFreindButton;

@property (nonatomic,strong) NSString *shareAppToTimeLineKey;
@property (nonatomic,strong) NSString *shareGoldToTimeLineKey;
@property (nonatomic,strong) NSString *shareAppToFriendKey;
@property (nonatomic,strong) NSString *shareGoldToFrendKey;

@property (nonatomic,assign) enum WXScene scene;

@end 

@implementation WeiXinShareViewCenterController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title=@"分享得金币";
    _shareAppToTimeLineKey=[NSString stringWithFormat:@"shareAppToTimeLine_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    _shareGoldToTimeLineKey=[NSString stringWithFormat:@"shareGoldToTimeLine_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    _shareAppToFriendKey=[NSString stringWithFormat:@"shareAppToFriend_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    _shareGoldToFrendKey=[NSString stringWithFormat:@"shareGoldToFriend_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    
    
    _shareAppToTimeLineButton=[self createFUIButtonWithFrame:CGRectMake(10, 100, 300, 40) cornerRadius:2 clickAction:@selector(shareAppToWeixin:) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:[[NSUserDefaults standardUserDefaults] objectForKey:_shareAppToTimeLineKey] ? @"分享应用到朋友圈(已领取)": @"分享应用到朋友圈(可领3金币)"];
    _shareAppToTimeLineButton.tag=123;
    
    _shareGoldToTimeLineButton=[self createFUIButtonWithFrame:CGRectMake(10, 170, 300, 40) cornerRadius:2 clickAction:@selector(shareGoldToWeixin:) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:[[NSUserDefaults standardUserDefaults] objectForKey:_shareGoldToTimeLineKey] ? @"分享收入到朋友圈(已领取)":@"分享收入到朋友圈(可领3金币)"];
    _shareGoldToTimeLineButton.tag=124;
    
    
    
    _shareGoldToFreindButton=[self createFUIButtonWithFrame:CGRectMake(10, 240, 300, 40) cornerRadius:2 clickAction:@selector(shareGoldToWeixin:) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:[[NSUserDefaults standardUserDefaults] objectForKey:_shareGoldToFrendKey] ?  @"分享收入给微信朋友(已领取)":@"分享收入给微信朋友(可领3金币)"];
    _shareGoldToFreindButton.tag=125;
    
    _shareAppToFriendButton=[self createFUIButtonWithFrame:CGRectMake(10, 310, 300, 40) cornerRadius:2 clickAction:@selector(shareAppToWeixin:) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:[[NSUserDefaults standardUserDefaults] objectForKey:_shareAppToFriendKey] ? @"分享应用给微信朋友(已领取)":@"分享应用给微信朋友(可领3金币)"];
    _shareAppToFriendButton.tag=126;
    
    [self.view addSubview:_shareAppToTimeLineButton];
    [self.view addSubview:_shareGoldToTimeLineButton];
    [self.view addSubview:_shareAppToFriendButton];
    [self.view addSubview:_shareGoldToFreindButton];
    
    _titleLabele.textColor=GREEN_COLOR;
    _titleLabele.font=[UIFont flatFontOfSize:14];
    
    _weixinController =[[BaseWeiXInController alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    _shareAppToTimeLineKey=[NSString stringWithFormat:@"shareAppToTimeLine_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    _shareGoldToTimeLineKey=[NSString stringWithFormat:@"shareGoldToTimeLine_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    _shareAppToFriendKey=[NSString stringWithFormat:@"shareAppToFriend_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    _shareGoldToFrendKey=[NSString stringWithFormat:@"shareGoldToFriend_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    
    [_shareAppToTimeLineButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:_shareAppToTimeLineKey] ? @"分享应用到朋友圈(已领取)": @"分享应用到朋友圈(可领3金币)" forState:UIControlStateNormal];
    [_shareGoldToTimeLineButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:_shareGoldToTimeLineKey] ? @"分享收入到朋友圈(已领取)":@"分享收入到朋友圈(可领3金币)" forState:UIControlStateNormal];
    [_shareGoldToFreindButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:_shareGoldToFrendKey] ?  @"分享收入给微信朋友(已领取)":@"分享收入给微信朋友(可领3金币)" forState:UIControlStateNormal];
    [_shareAppToFriendButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:_shareAppToFriendKey] ? @"分享应用给微信朋友(已领取)":@"分享应用给微信朋友(可领3金币)" forState:UIControlStateNormal];
    _weixinController.delegate=self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    _weixinController.delegate=nil;
}

-(void) shareAppToWeixin:(UIButton *) sender
{
    NSString *description=@"把你的赚钱小秘密告诉朋友们把!";
    NSString *title=@"这APP用零散时间能赚钱,不开玩笑,我最近赚了点,来试试吧.";
    if (sender.tag==123) {
        _scene=WXSceneTimeline;

    }else if (sender.tag==126){
        description=@"几分钟就能赚个几块钱,以后玩游戏或者充话费也不用自掏腰包了.";
        title=@"这APP用零散时间能赚钱赚话费,不开玩笑,我最近赚了点,来试试吧.";
        _scene=WXSceneSession;
    }
    
    [_weixinController changeScene:_scene];
     UIImage *myImage =[UIImage imageNamed:@"Icon-144"];
    [_weixinController sendAppContentWithThumbData:myImage withMessage:title withDescription:description andLink:@"https://itunes.apple.com/cn/app/mai-dang-lao-you-hui-juan/id675526778?ls=1&mt=8"];
    
}

-(void) shareGoldToWeixin:(UIButton *) sender
{
    WeiXinGoldShareViewController *weiXinShareGoldVC=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinGoldShareViewController"];
    if (sender.tag==124) {
        weiXinShareGoldVC.scene=WXSceneTimeline;
    }else if (sender.tag==125)
        weiXinShareGoldVC.scene=WXSceneSession;
    
    [self.navigationController pushViewController:weiXinShareGoldVC animated:YES];
}


#pragma mark sendMsgToWeChatViewDelegate

-(void) didSendMessageSuccess
{

    NSString *key =_shareAppToTimeLineKey;
    if (_scene==WXSceneSession) {
        key =_shareAppToFriendKey;
    }
    NSString *shareState=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (shareState) {
        [self showFUIAlertViewWithTitle:@"消息" message:@"分享成功!" withTag:-1 cancleButtonTitle:@"好的" otherButtonTitles:nil];
    }else{

        [[NSUserDefaults standardUserDefaults] setValue:@"done" forKey:key];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self showFUIAlertViewWithTitle:@"恭喜!分享成功!" message:@"分享成功,您将获得系统赠送的3金币!" withTag:SHOULD_SEND_Three_GOLD_TAG cancleButtonTitle:@"确认收取" otherButtonTitles:nil];
    }
}

-(void) didSendMessageError
{
    [self showFUIAlertViewWithTitle:@"很遗憾!" message:@"分享失败,请重试!" withTag:-1 cancleButtonTitle:@"知道了" otherButtonTitles:nil];
}

-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==SHOULD_SEND_Three_GOLD_TAG) {
        [SVProgressHUD showWithStatus:@"收取中!"];
        NSString *type =@"shareAppToTimeLine";
        if (_scene==WXSceneSession) {
            type =@"shareAppToFriend";
        }
        [UserGold getWeixinAwardWithType:type OnSuccess:^(id json) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功收取%@金币!",[json objectForKey:@"amount"]]];
            if (_scene==WXSceneSession) {
                [_shareAppToFriendButton setTitle:@"分享应用给微信朋友(已领取)" forState:UIControlStateNormal];
            }else{
                [_shareAppToTimeLineButton setTitle:@"分享应用到朋友圈(已领取)" forState:UIControlStateNormal];
            }
        } failure:^(id error) {
            [AppUtilities handleErrorMessage:error];
        }];
    }
}


@end
