//
//  GetGoldViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-27.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GetGoldViewController.h"
#import "goldIntroductionViewController.h"
#import "goldToMoneyScrollView.h"
#import "ExchangeNOSettingViewController.h"
#import "WeiXinAwardViewController.h"
#import "WeiXinGoldShareViewController.h"
#import "SVPullToRefresh.h"
@interface GetGoldViewController()
@property (nonatomic,strong) FUIButton *DMOButton;
@property (nonatomic,strong) FUIButton *LIMEIButton;
@property (nonatomic,strong) FUIButton *DIANDIANButton;
@property (nonatomic,strong) FUIButton *MIDIButton;
@property (nonatomic,strong) FUIButton *YOUMIButton;
@property (nonatomic,strong) FUIButton *WANPUButton;


@property (nonatomic,strong) FUIButton *awardQqButton;
@property (nonatomic,strong) FUIButton *awardWeiXinButton;
@property (nonatomic,strong) FUIButton *awardFiveStarButton;
@property (nonatomic,strong) FUIButton *awardWeixinShareButton;

@property (nonatomic,strong) goldToMoneyScrollView *goldScrollView;
@property (nonatomic,weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,weak) IBOutlet UILabel *goldLable;
@property (nonatomic,weak) IBOutlet UILabel *describeLable;
@property (nonatomic,weak) IBOutlet UILabel *skillLable;

@property (nonatomic,assign) int platformInuseCount;

@end

@implementation GetGoldViewController


#define BindingQqAlertTag 865

-(void)viewDidLoad
{
    [_goldLable setText:[NSString stringWithFormat:@"%d",APPDELEGATE.userGoldAmont ]];
    [super viewDidLoad];
    [self.view setBackgroundColor:GREEN_COLOR];
    self.title=@"免费赚金币";
    [self createNavigationLeftButtonWithTitle:@"菜单"  action:@selector(showMenuLeft)];
    
    
    
    _mainScrollView.delegate=self;
    
    _platformInuseCount=0;
    for (GoldPlatForm *platForm in APPDELEGATE.appVersionInfo.platFormList) {
        if (platForm.state==0 || platForm.pid==SYS_GIF_ID_INT || APPDELEGATE.appVersionInfo.isHide==1) {
            continue;
        }
        _platformInuseCount++;
        switch (platForm.pid) {
            case DOMO_ID_INT:
            {
                _DMOButton =[self createFUIButtonWithFrame:CGRectMake(10, 125, 90, 40) cornerRadius:2 clickAction:@selector(openDUOMENWall) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"多盟平台"];
                [_mainScrollView addSubview:_DMOButton];
            }
                break;
            case LIMEI_ID_INT:
            {
                _LIMEIButton =[self createFUIButtonWithFrame:CGRectMake(115, 125, 90, 40) cornerRadius:2 clickAction:@selector(openLiMeiWall) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"力美平台"];
                 [_mainScrollView addSubview:_LIMEIButton];
            }
                break;
            case DIANRU_ID_INT:
            {
                _DIANDIANButton=[self createFUIButtonWithFrame:CGRectMake(220, 125, 90, 40) cornerRadius:2 clickAction:@selector(openDianRuWall) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"点入平台"];
                [_mainScrollView addSubview:_DIANDIANButton];
            }
                break;
            case MIDI_ID_INT:
            {
                _MIDIButton =[self createFUIButtonWithFrame:CGRectMake(10, 185, 90, 40) cornerRadius:2 clickAction:@selector(openMIDIWall) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"米迪平台"];
                [_mainScrollView addSubview:_MIDIButton];
            }
                break;
            case YOUMI_ID_INT:
            {
                _YOUMIButton =[self createFUIButtonWithFrame:CGRectMake(115, 185, 90, 40) cornerRadius:2 clickAction:@selector(openYOUMIWall) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"有米平台"];
                [_mainScrollView addSubview:_YOUMIButton];
            }
                break;
            case WANPU_ID_INT:
            {
                _WANPUButton=[self createFUIButtonWithFrame:CGRectMake(220, 185, 90, 40) cornerRadius:2 clickAction:@selector(openWANPUWall) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"万普平台"];
                [_mainScrollView addSubview:_WANPUButton];
            }
                break;
            default:
                break;
        }
    }

    _mainScrollView.contentSize=CGSizeMake(320, _mainScrollView.frame.size.height+1);
   _mainScrollView.backgroundColor=[UIColor whiteColor];
    _goldScrollView = (goldToMoneyScrollView *)[self loadViewFromXibName:@"goldToMoneyScrollView"];
    _goldScrollView.frame=CGRectMake(10, 10, 300, 140);
    [self.view addSubview:_goldScrollView];
    
    
    _goldLable.font=[UIFont boldFlatFontOfSize:34];
    _goldLable.textColor=GREEN_COLOR;
    _describeLable.font=[UIFont boldFlatFontOfSize:20];
    _describeLable.textColor=GREEN_COLOR;
    

    
    _awardQqButton=[self createFUIButtonWithFrame:CGRectMake(10, 365, 300, 40) cornerRadius:2 clickAction:@selector(openAwardQqView) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"当前可领推荐金币"];
    [_mainScrollView addSubview:_awardQqButton];
    
    _awardWeixinShareButton=[self createFUIButtonWithFrame:CGRectMake(10, 415, 300, 40) cornerRadius:2 clickAction:@selector(openWeixinShareAward) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"分享收入到朋友圈,每天领10金币"];
    [_mainScrollView addSubview:_awardWeixinShareButton];
    
    _awardWeiXinButton=[self createFUIButtonWithFrame:CGRectMake(10, 465, 300, 40) cornerRadius:2 clickAction:@selector(openAwardWeixinView) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"关注微信公共账号,领取30金币"];
    [_mainScrollView addSubview:_awardWeiXinButton];
    
    _awardFiveStarButton=[self createFUIButtonWithFrame:CGRectMake(10, 515, 300, 40) cornerRadius:2 clickAction:@selector(openAwardFiveStar) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"去AppStroe评价5星送金币!"];
    [_mainScrollView addSubview:_awardFiveStarButton];
    
    
    if (_platformInuseCount==0 || APPDELEGATE.appVersionInfo.isHide==1) {
        _describeLable.text=@"推荐给朋友得金币!";
        _awardQqButton.frame=[AppUtilities changeViewFrameJustForY:125 withView:_awardQqButton];
        _awardWeiXinButton.frame=[AppUtilities changeViewFrameJustForY:175 withView:_awardWeiXinButton];
        _awardWeixinShareButton.frame=[AppUtilities changeViewFrameJustForY:225 withView:_awardWeixinShareButton];

        [[_mainScrollView viewWithTag:21] removeFromSuperview];
        [[_mainScrollView viewWithTag:22] removeFromSuperview];
        [_awardFiveStarButton removeFromSuperview];
        [_skillLable removeFromSuperview]; 
    }else{
        UILabel *describeLable2 =(UILabel *) [_mainScrollView viewWithTag:22];
        describeLable2.font=[UIFont boldFlatFontOfSize:20];
        describeLable2.textColor=GREEN_COLOR;
        _skillLable.textColor=GREEN_COLOR;
        _skillLable.font=[UIFont flatFontOfSize:14];
        [self createNavigationRightButtonWithTitle:@"使用说明"  action:@selector(showMenuRight)];
    }
    
    [self setUpScrollTextView];
    //下拉刷新
    __weak GetGoldViewController *weakelf=self;
    [_mainScrollView addPullToRefreshWithActionHandler:^{
        [weakelf performSelector:@selector(reloadGoldAmount)];
    }];
    [_mainScrollView.pullToRefreshView setTitle:@"下拉刷新金币数量" forState:SVPullToRefreshStateStopped];
    [_mainScrollView.pullToRefreshView setTitle:@"释放开始刷新" forState:SVPullToRefreshStateTriggered];
    [_mainScrollView.pullToRefreshView setArrowColor:GREEN_COLOR];
    [_mainScrollView.pullToRefreshView setTextColor:GREEN_COLOR];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[goldIntroductionViewController class]]) {
            self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"goldIntroductionViewController"];
    }
    
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
    if (_goldScrollView.stopAnimation) {
        _goldScrollView.stopAnimation=NO;
        [_goldScrollView startScrollAnimetion];
    }
    if (_mainScrollView.frame.size.height!=mainScreenHeightWithoutBar-158) {
        _mainScrollView.frame=[AppUtilities changeViewFrameJustForHight:mainScreenHeightWithoutBar-158 withView:_mainScrollView];
        if (_platformInuseCount>0) {
            _mainScrollView.contentSize=CGSizeMake(320, 565);
        }
        
    }
    
    //qq奖励按钮
    int gold=30+(APPDELEGATE.loginUser.awardQqCount * 5 > 20 ? 20:APPDELEGATE.loginUser.awardQqCount * 5);
    [_awardQqButton setTitle:[NSString stringWithFormat:@"当前可领%d推荐使用金币",gold ] forState:UIControlStateNormal];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _goldScrollView.stopAnimation=YES;
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    _goldScrollView=nil;
    
}

#pragma mark ---customer Actions

-(void) setUpScrollTextView
{
    [_goldScrollView setUpTextScrollView:APPDELEGATE.getGoldArrayForWall];
}

-(void)openAwardQqView
{
    if (APPDELEGATE.loginUser.qq && APPDELEGATE.loginUser.qq.length>0) {
        ExchangeNOSettingViewController *exNoSettingVc=[self.storyboard instantiateViewControllerWithIdentifier:@"exchangeNOSettingViewController"];
        exNoSettingVc.formType=FormtypeAwardGoldType;
        [self.navigationController pushViewController:exNoSettingVc animated:YES];
    }else{
        [self showFUIAlertViewWithTitle:@"提示" message:@"在领取推荐金币前,您得在'我的设置'-'绑定联系QQ'中绑定自己的QQ号,里面有规则的详细介绍." withTag:BindingQqAlertTag cancleButtonTitle:@"知道了" otherButtonTitles:nil];
    }
    
}
-(void)openWeixinShareAward
{
    WeiXinGoldShareViewController *weiXinShareGoldVC=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinGoldShareViewController"];
    [self.navigationController pushViewController:weiXinShareGoldVC animated:YES];
}
-(void)openAwardWeixinView
{
    WeiXinAwardViewController *weixinVc=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinAwardViewController"];
    [self.navigationController pushViewController:weixinVc animated:YES];
}
-(void)openAwardFiveStar
{
    WeiXinAwardViewController *weixinVc=[self.storyboard instantiateViewControllerWithIdentifier:@"weiXinAwardViewController"];
    weixinVc.describeType=DescribeTypeFiveStar;
    [self.navigationController pushViewController:weixinVc animated:YES];
}

-(void) afterGoldReloaded
{
    [super afterGoldReloaded];
    [self.mainScrollView.pullToRefreshView stopAnimating ];
    [_goldLable setText:[NSString stringWithFormat:@"%d",APPDELEGATE.userGoldAmont ]];
    
}

#define mark fuiAlerViewDelegate

-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag==BindingQqAlertTag) {
         [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"settingViewController",@"identifier", nil]];
    }
}



@end
