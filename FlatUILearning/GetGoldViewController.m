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
@property (nonatomic,strong) FUIButton *ANWOButton;
@property (nonatomic,strong) FUIButton *YiJiFenButton;


@property (nonatomic,strong) FUIButton *awardQqButton;
@property (nonatomic,strong) FUIButton *awardWeiXinButton;
@property (nonatomic,strong) FUIButton *awardFiveStarButton;
@property (nonatomic,strong) FUIButton *awardWeixinShareButton;

@property (nonatomic,strong) goldToMoneyScrollView *goldScrollView;
@property (nonatomic,weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,weak) IBOutlet UILabel *goldLable;
@property (nonatomic,weak) IBOutlet UILabel *describeLable;
@property (nonatomic,weak) IBOutlet UILabel *skillLable;
@property (nonatomic,strong) DMScrollingTicker *scrollTextView;

@property (nonatomic,assign) int theY_OffSet;
@property (nonatomic,assign) int platformInuseCount;

-(void) buildScrollTextView;
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
    int thex=10;
    int theY=125;
    _theY_OffSet=125;
    for (GoldPlatForm *platForm in APPDELEGATE.appVersionInfo.platFormList) {
        if (platForm.state==0 || platForm.pid==SYS_GIF_ID_INT || APPDELEGATE.appVersionInfo.isHide==1) {
            continue;
        }
        if (_platformInuseCount%3==0) {
            thex=10;
            _theY_OffSet+=60;
            if (_platformInuseCount>1) {
                theY+=60;
            }
        }else{
            thex+=105;
        }
        _platformInuseCount++;
        
        
        switch (platForm.pid) {
            case DOMO_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_DMOButton andTitle:@"多盟平台" withAction:@selector(openDUOMENWall)];
                break;
            case LIMEI_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_LIMEIButton andTitle:@"力美平台" withAction:@selector(openLiMeiWall)];
                break;
            case DIANRU_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_DIANDIANButton andTitle:@"点入平台" withAction:@selector(openDianRuWall)];
                break;
            case MIDI_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_MIDIButton andTitle:@"米迪平台" withAction:@selector(openMIDIWall)];
                break;
            case YOUMI_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_YOUMIButton andTitle:@"有米平台" withAction:@selector(openYOUMIWall)];
                break;
            case WANPU_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_WANPUButton andTitle:@"万普平台" withAction:@selector(openWANPUWall)];
                break;
            case ANWO_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_ANWOButton andTitle:@"安沃平台" withAction:@selector(openAnwoWall)];
                break;
            case YIJIFEN_ID_INT:
                [self creatGoldButtonWithFrame:CGRectMake(thex, theY, 90, 40) andButton:_YiJiFenButton andTitle:@"易积分平台" withAction:@selector(OpenYiJIFenWall)];
                break;
            default:
                break;
        }
    }

    _mainScrollView.contentSize=CGSizeMake(320, _mainScrollView.frame.size.height+1);
   _mainScrollView.backgroundColor=[UIColor whiteColor];
    _goldScrollView = (goldToMoneyScrollView *)[self loadViewFromXibName:@"goldToMoneyScrollView"];
    _goldScrollView.frame=CGRectMake(10, 25, 300, 140);
    [self.view addSubview:_goldScrollView];
    
    
    _goldLable.font=[UIFont boldFlatFontOfSize:34];
    _goldLable.textColor=GREEN_COLOR;
    _describeLable.font=[UIFont boldFlatFontOfSize:20];
    _describeLable.textColor=GREEN_COLOR;
    
    
    _skillLable.frame = [AppUtilities changeViewFrameJustForY:_theY_OffSet withView:_skillLable];
    
    _awardQqButton=[self createFUIButtonWithFrame:CGRectMake(10, _theY_OffSet+120, 300, 40) cornerRadius:2 clickAction:@selector(openAwardQqView) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"当前可领推荐金币"];
    [_mainScrollView addSubview:_awardQqButton];
    
    _awardWeixinShareButton=[self createFUIButtonWithFrame:CGRectMake(10, _theY_OffSet+175, 300, 40) cornerRadius:2 clickAction:@selector(openWeixinShareAward) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"分享收入到微信,每天领12金币"];
    [_mainScrollView addSubview:_awardWeixinShareButton];
    
    _awardWeiXinButton=[self createFUIButtonWithFrame:CGRectMake(10, _theY_OffSet+230, 300, 40) cornerRadius:2 clickAction:@selector(openAwardWeixinView) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"关注微信公共账号,领取30金币"];
    [_mainScrollView addSubview:_awardWeiXinButton];
    
    _awardFiveStarButton=[self createFUIButtonWithFrame:CGRectMake(10, _theY_OffSet+285, 300, 40) cornerRadius:2 clickAction:@selector(openAwardFiveStar) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"去AppStroe评价5星送金币!"];
    [_mainScrollView addSubview:_awardFiveStarButton];
    
    
    if (_platformInuseCount==0 || APPDELEGATE.appVersionInfo.isHide==1) {
        _describeLable.text=@"推荐给朋友得金币!";
       
        _awardWeiXinButton.frame=[AppUtilities changeViewFrameJustForY:125 withView:_awardWeiXinButton];
        _awardWeixinShareButton.frame=[AppUtilities changeViewFrameJustForY:175 withView:_awardWeixinShareButton];

        [[_mainScrollView viewWithTag:21] removeFromSuperview];
        [[_mainScrollView viewWithTag:22] removeFromSuperview];
        [_awardFiveStarButton removeFromSuperview];
        [_skillLable removeFromSuperview];
        [_awardQqButton removeFromSuperview];
    }else{
        UILabel *describeLable2 =(UILabel *) [_mainScrollView viewWithTag:22];
        describeLable2.font=[UIFont boldFlatFontOfSize:20];
        describeLable2.textColor=GREEN_COLOR;
        _skillLable.textColor=GREEN_COLOR;
        _skillLable.font=[UIFont flatFontOfSize:14];
        UIView *theLineView=[_mainScrollView viewWithTag:21] ;
        theLineView.frame=[AppUtilities changeViewFrameJustForY:_theY_OffSet+70 withView:theLineView];
        theLineView=[_mainScrollView viewWithTag:22] ;
        theLineView.frame=[AppUtilities changeViewFrameJustForY:_theY_OffSet+85 withView:theLineView];
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
    [self buildScrollTextView];
}

-(void) buildScrollTextView
{
    if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==0) {
        if (_scrollTextView) {
            [_scrollTextView removeFromSuperview];
        }
        NSArray *textArray=APPDELEGATE.exchangeArrayForWall;
        if (([AppUtilities isIOS6] || [AppUtilities isIOS5]) && [APP_NAME isEqualToString:APPNAME_ZuanZuanZuan] && !APPDELEGATE.isChangeStatusBarY){
            _scrollTextView =[self createTextScrollViewWithFrame:CGRectMake(0, 20, 320, 20) withTextArray:textArray];
        }else
            _scrollTextView =[self createTextScrollViewWithFrame:CGRectMake(0, 0, 320, 20) withTextArray:textArray];
        _scrollTextView.tag=786;
        [self.view addSubview:_scrollTextView];
    }
}

-(void) creatGoldButtonWithFrame:(CGRect) theframe andButton:(FUIButton *) fUIButton andTitle:(NSString *) title withAction:(SEL) action
{
    fUIButton=[self createFUIButtonWithFrame:theframe cornerRadius:2 clickAction:action fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:title];
    [_mainScrollView addSubview:fUIButton];
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
            _mainScrollView.contentSize=CGSizeMake(320, _theY_OffSet+350);
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
    WeiXinGoldShareViewController *weiXinShareGoldVC=[self.storyboard instantiateViewControllerWithIdentifier:@"WeiXinShareViewCenterController"];
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
