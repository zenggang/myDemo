//
//  BaseGoldViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-3.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseGoldViewController.h"
#import "Users.h"
#import "MiidiManager.h"
#import "MiidiAdWall.h"
#import "WapsOffer/AppConnect.h"
#import "AdwoOfferWall.h"


@interface BaseGoldViewController()
@property (nonatomic,strong) DMOfferWallViewController *DMOWallController;
@property (nonatomic,strong) DMOfferWallManager *offerWallManager;

@property (nonatomic,strong) immobView *liMei_AdWall;
@property (nonatomic,strong)  YJFIntegralWall *integralWall;
//@property (atomic,assign) int latestGoldAmount;
@property (atomic,assign) int platformRoundCheckCount;
@property (nonatomic,assign) BOOL isAllGoldLoaded;
@property (nonatomic, retain) YouMiWall *youmiWall;

@property (nonatomic,assign) NSInteger addGoldDOMOToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldLiMeiToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldDianRuToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldMIDIToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldYOUMiToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldWanPuToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldAnWoToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldYiJIFenToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldAiPuDongLiToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldMoPanToSysGoldAmount;



@property (nonatomic,assign) int oldUserPlatformCheckCount;
@property (nonatomic,assign) BOOL isRuduceGold;
@property (nonatomic,strong) NSMutableString *reduceGoldData;
@property (nonatomic,strong) NSString *reduceGoldKeyString;


@end
#define GIFT_ALERVIEW_TAG 888
//96ZJ1DugzewKLwTA2p 我的
//#define DMO_PUBLISHER_ID @"96ZJ1DugzewKLwTA2p"
//#define LIMEI_PUBLISHER_ID @"cad9cd3a95588e5de2c65cd75b910ce2"



@implementation BaseGoldViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self initAllAdvWallInfo];
    if (APPDELEGATE.isFirstTime) {
        if (!APPDELEGATE.appVersionInfo) {
            return;
        }
        if (APPDELEGATE.appVersionInfo.isHide==1) {
            [self showFUIAlertViewWithTitle:@"欢迎使用!" message:@"您是第一次使用,系统将赠送给您一份神秘大礼!" withTag:GIFT_ALERVIEW_TAG cancleButtonTitle:@"确认接收" otherButtonTitles:nil];
            [DianRuSDK requestAdmobileViewWithDelegate:self];
        }else
            [self showFUIAlertViewWithTitle:@"欢迎使用!" message:@"您是第一次使用免费赚金币功能,系统将赠送给您一份神秘大礼!" withTag:GIFT_ALERVIEW_TAG cancleButtonTitle:@"确认接收"  otherButtonTitles:nil];
    }else{
        [self reloadGoldAmount];
        if (APPDELEGATE.appVersionInfo.isHide==1) {
             [DianRuSDK requestAdmobileViewWithDelegate:self];
        }else{
            if (APPDELEGATE.appVersionInfo.announcementId!=APPDELEGATE.announcementId) {
                if (APPDELEGATE.appVersionInfo.announcement && APPDELEGATE.appVersionInfo.announcement.length>0) {
                    [self showFUIAlertViewWithTitle:@"系统公告" message:APPDELEGATE.appVersionInfo.announcement withTag:-1 cancleButtonTitle:@"好的" otherButtonTitles: nil];
                    APPDELEGATE.announcementId=APPDELEGATE.appVersionInfo.announcementId;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:APPDELEGATE.announcementId] forKey:@"announcementId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(void) initAllAdvWallInfo
{
    if (APPDELEGATE.DuoMenPlatform.state==1 && !_DMOWallController) {
        _DMOWallController = [[DMOfferWallViewController alloc] initWithPublisherID:APPDELEGATE.DuoMenPlatform.appKey];
        _DMOWallController.disableStoreKit = YES;
        _DMOWallController.delegate = self;
        // 加载积分墙并等待delegate的回调。
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        _DMOWallController.rootViewController=rootViewController;
        _offerWallManager = [[DMOfferWallManager alloc] initWithPublishId:APPDELEGATE.DuoMenPlatform.appKey userId:nil];
        _offerWallManager.delegate = self;
    }
    
    if (APPDELEGATE.LiMeiPlatform.state==1 && !_liMei_AdWall) {
        _liMei_AdWall=[[immobView alloc] initWithAdUnitID:APPDELEGATE.LiMeiPlatform.appKey];
        _liMei_AdWall.delegate=self;
    }
    //点入平台
    
    [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
    
    //有米
    if (APPDELEGATE.YouMiPlatform.state==1 && !self.youmiWall) {
        self.youmiWall = [YouMiWall new] ;
    }
    

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    //指定获取用户积分的回调方法
    if (APPDELEGATE.WanPuPlatform.state==1) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getUpdatedPoints:)
                                                     name:WAPS_GET_POINTS_SUCCESS
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getUpdatedPointsFailed:)
                                                     name:WAPS_GET_POINTS_FAILED
                                                   object:nil];
    }


    //磨盘
    if (APPDELEGATE.MoPanPlatform.state==1 && !_mopanAdWallControl) {
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:APPDELEGATE.MoPanPlatform.appKey withAppSecret:APPDELEGATE.MoPanPlatform.appSecret];
        _mopanAdWallControl.delegate = self;
        _mopanAdWallControl.rootViewController = self;
    }
    
    
    //爱普动力
    if (APPDELEGATE.MoPanPlatform.state==1 && !_powerWallViewController) {
        _powerWallViewController = [ADCPowerWallViewController initWithSiteId:APPDELEGATE.AiPuDongLiPlatform.appKey
                                                                      siteKey:APPDELEGATE.AiPuDongLiPlatform.appSecret
                                                                      mediaId:APPDELEGATE.AiPuDongLiPlatform.mediaId
                                                               userIdentifier:APPDELEGATE.udid
                                                                   useSandBox:NO
                                                                    useReward:YES
                                              powerWallViewControllerDelegate:self];
        _powerWallViewController.delegate=self;
    }
    
    
}


-(void)viewWillUnload{
    [super viewWillUnload];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    if (APPDELEGATE.WanPuPlatform.state==1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:WAPS_GET_POINTS_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:WAPS_GET_POINTS_FAILED object:nil];
    }

    
}


#pragma mark ---customer Actions
// online
-(void) openDUOMENWall
{
    [_DMOWallController presentOfferWall];
}
- (void) openLiMeiWall{
    //      //AdUnitID 可以到力美广告平台去获取:http://www.limei.com
    [SVProgressHUD show];
    [_liMei_AdWall immobViewRequest];
    
}

-(void) openDianRuWall{
    APPDELEGATE.isChangeStatusBarY=YES;
    [DianRuAdWall showAdWall:self];
}

-(void) openMIDIWall
{
    
    [MiidiAdWall showAppOffers:self withDelegate:self];
}

-(void) openYOUMIWall
{
    //[YouMiPointsManager rewardPoints:100];
    [YouMiWall showOffers:YES didShowBlock:^{
        //log4Debug(@"有米积分墙已显示");
    } didDismissBlock:^{
        //log4Debug(@"有米积分墙已退出");
    }];
}

-(void) openWANPUWall
{
    [AppConnect showOffers:self.parentViewController];
}

//安沃平台
-(void) openAnwoWall
{
    APPDELEGATE.isChangeStatusBarY=YES;
    // 初始化并登录积分墙
    BOOL result = AdwoOWPresentOfferWall(APPDELEGATE.AnWoPlatform.appKey, self);
    if(!result)
    {
        NSLog(@"安沃初始化失败");
    }
}

- (int)getAnWoPoints
{
    NSInteger currPoints = 0;
    
    // 通过传0来查询剩余虚拟货币
    if(AdwoOWConsumePoints(0, &currPoints))
        NSLog(@"Current points: %d", currPoints);
    return currPoints;
}

//易积分平台
//积分墙
-(void)OpenYiJIFenWall
{
    if (!_integralWall) {
        _integralWall = [[YJFIntegralWall alloc]init];
        _integralWall.delegate = self;
    }

    [self presentModalViewController:_integralWall animated:YES];
}

-(int)getYiJifenScore
{
    NSString * str = [YJFScore getScore];
    int score=0;
    if (str) {
        score = [str intValue];
    }
    return score;
}
//艾普动力
- (void)openAiPuDongLiWall
{
    
    [ADCPowerWallViewController showPowerWallViewFromViewController:self
                                                             siteId:APPDELEGATE.AiPuDongLiPlatform.appKey
                                                            siteKey:APPDELEGATE.AiPuDongLiPlatform.appSecret
                                                            mediaId:APPDELEGATE.AiPuDongLiPlatform.mediaId
                                                     userIdentifier:APPDELEGATE.udid
                                                          useReward:YES
                                                         useSandBox:NO];
    
}

//磨盘平台
-(void) openMoPanWall
{
    [_mopanAdWallControl showAppOffers];
}


-(void) changeTheGoldToNewVersion
{
    _oldUserPlatformCheckCount=0;
    for (UserGold *gold in APPDELEGATE.loginUser.userGoldList) {
        if (gold.pid>1 && gold.goldAmount) {
            int totalPoint=gold.goldAmount;
            switch (gold.pid) {
                case DOMO_ID_INT:
                    _addGoldDOMOToSysGoldAmount=totalPoint;
                    break;
                case LIMEI_ID_INT:
                    _addGoldLiMeiToSysGoldAmount=totalPoint;
                    break;
                case DIANRU_ID_INT:
                    _addGoldDianRuToSysGoldAmount=totalPoint;
                    break;
                case MIDI_ID_INT:
                    _addGoldMIDIToSysGoldAmount=totalPoint;
                    break;
                case YOUMI_ID_INT:
                    _addGoldYOUMiToSysGoldAmount=totalPoint;
                    break;
                case WANPU_ID_INT:
                    _addGoldWanPuToSysGoldAmount=totalPoint;
                    break;
                    
                default:
                    break;
            }
            [self reduceGoldInPid:[NSString stringWithFormat:@"%d",gold.pid] withGold:gold.goldAmount];
        }
    }
}

-(void) handleOldUserGold
{
    if (APPDELEGATE.oldVesionUserPlatIdCount==_oldUserPlatformCheckCount) {
        APPDELEGATE.isOldVesionUser=NO;
        [self reloadGoldAmount];
    }
}

-(void) reloadGoldAmount
{
    if (!APPDELEGATE.appVersionInfo) {
        return;
    }
    if (APPDELEGATE.isOldVesionUser) {
        [self changeTheGoldToNewVersion];
        return;
    }
    [SVProgressHUD showWithStatus:@"更新金币数据中..." maskType:SVProgressHUDMaskTypeBlack];
    _platformRoundCheckCount=0;
    
    [UserGold getUserGifGodOnSuccess:^(UserGold *gold) {
        [self handlePlatformGoldReturnWithGold:gold.goldAmount andPid:SYS_GIF_ID_INT pidStr:SYS_GIF_ID];
        
        if (((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:YOUMI_ID]).state==1) {
            int totalPoint =[YouMiPointsManager pointsRemained];
            [self handlePlatformGoldReturnWithGold:totalPoint andPid:YOUMI_ID_INT pidStr:YOUMI_ID];
        }
        if (APPDELEGATE.AnWoPlatform.state==1) {
            int totalPoint =[self getAnWoPoints];
            [self handlePlatformGoldReturnWithGold:totalPoint andPid:ANWO_ID_INT pidStr:ANWO_ID];
        }
        if (APPDELEGATE.YiJiFenPlatform.state==1) {
            int totalPoint =[self getYiJifenScore];
            [self handlePlatformGoldReturnWithGold:totalPoint andPid:YIJIFEN_ID_INT pidStr:YIJIFEN_ID];
        }
        if (((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:AIPUDONGLI_ID]).state==1)
            [_powerWallViewController getScore];
        
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:DOMO_ID]).state==1)
            [_offerWallManager requestOnlinePointCheck];
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:LIMEI_ID]).state ==1)
            [_liMei_AdWall immobViewQueryScoreWithAdUnitID:APPDELEGATE.LiMeiPlatform.appKey];
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:DIANRU_ID] ).state==1)
            //    //获取积分，异步方法，结果在代理中进行回调
            [DianRuAdWall getRemainPoint];
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:MIDI_ID]).state==1)
            [MiidiAdWall requestGetPoints:self];
        
        //万普平台回调接口唯一,所以要有标示符
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:WANPU_ID]).state==1){
            _isRuduceGold=NO;
            [AppConnect getPoints];
        }
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:MOPAN_ID]).state==1)
            [_mopanAdWallControl getMoney];
        

        
    } failure:^(id error) {
        [self handleErrorLoadGoldWithPid:SYS_GIF_ID_INT];
    }];
    _isAllGoldLoaded=YES;
}


-(void) reduceGold
{
    if (_reduceGoldType==nil && !_isGuaGuaLeDeduce) {
        return;
    }
    [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeClear];
    //初始化变量
    _reduceGoldData=[NSMutableString stringWithString:@""];
    
    int reduceGoldAmount=0;
    if (_isGuaGuaLeDeduce) {
        reduceGoldAmount=_guaGuaLeDeduceGoldAmount;
    }else{
        reduceGoldAmount=_reduceGoldType.goldAmount;
    }
    

    
    if (APPDELEGATE.userGoldAmont>=reduceGoldAmount) {
        
        [_reduceGoldData appendFormat:@"%@,",[AppUtilities goldDataEncryptWithPid:1 andGoldAmount:reduceGoldAmount]];
        _reduceGoldKeyString=[NSString stringWithFormat:@"%d,%d,%d,",reduceGoldAmount,APPDELEGATE.userGoldAmont,1];
        
        if (_isGuaGuaLeDeduce) {
            [UserGold deductingGoldOnSuccess:^(id json) {
                [self afterGoldReduced];
            } failure:^(id error) {
                [AppUtilities handleErrorMessage:error];
            } withGoldData:_reduceGoldData];
        }else{
            [UserGold ExcgangeGoldOnSuccess:^(id json) {
                [SVProgressHUD showSuccessWithStatus:@"操作成功!"];
                [self afterGoldReduced];
            } failure:^(id error) {
                [AppUtilities handleErrorMessage:error];
            } withreciveNumber:_exchangeNumber withData:_reduceGoldData withTypeId:_reduceGoldType.typeId withSecret:[AppUtilities TheSecretForExchangeGold:_reduceGoldKeyString]];
        }
    }
    
    
}


-(void) afterGoldReduced
{
    [self showFUIAlertViewWithTitle:@"恭喜!" message:@"兑换金币成功,客服会在24小时内完成确认与发放,兑换状态可再右边栏查询!" withTag:ReduceGoldSuccessAlertTag cancleButtonTitle:@"确认" otherButtonTitles:nil];
}

-(void) updateGoldInfo:(int) pid
{
    if (_platformRoundCheckCount==APPDELEGATE.platformCount) {
        [self afterGoldReloaded];
    }
}



-(void) afterGoldReloaded{
    [SVProgressHUD showSuccessWithStatus:@"更新成功!"];
    //[MiidiAdWall requestAwardPoints:100 withDelegate:self];
    //[YouMiPointsManager rewardPoints:301];
    
}

-(void) handleErrorLoadGoldWithPid:(int ) pid
{
    _isAllGoldLoaded=NO;
    _platformRoundCheckCount++;
    [self updateGoldInfo:pid];
    
}



-(void) handlePlatformGoldReturnWithGold:(int) totalPoint andPid:(int) pid pidStr:(NSString *) pidStr
{    @synchronized(self)
    {
        NSLog(@"return %d %d %d",pid,_platformRoundCheckCount,totalPoint);
        switch (pid) {
            case DOMO_ID_INT:
                _addGoldDOMOToSysGoldAmount=totalPoint;
                break;
            case LIMEI_ID_INT:
                _addGoldLiMeiToSysGoldAmount=totalPoint;
                break;
            case DIANRU_ID_INT:
                _addGoldDianRuToSysGoldAmount=totalPoint;
                break;
            case MIDI_ID_INT:
                _addGoldMIDIToSysGoldAmount=totalPoint;
                break;
            case YOUMI_ID_INT:
                _addGoldYOUMiToSysGoldAmount=totalPoint;
                break;
            case WANPU_ID_INT:
                _addGoldWanPuToSysGoldAmount=totalPoint;
                break;
            case ANWO_ID_INT:
                _addGoldAnWoToSysGoldAmount=totalPoint;
                break;
             case YIJIFEN_ID_INT:
                _addGoldYiJIFenToSysGoldAmount=totalPoint;
                break;
            case MOPAN_ID_INT:
                _addGoldMoPanToSysGoldAmount=totalPoint;
                break;
            case AIPUDONGLI_ID_INT:
                _addGoldAiPuDongLiToSysGoldAmount=totalPoint;
                break;
            default:
                break;
        }
        if (pid!=SYS_GIF_ID_INT) {
            if (totalPoint>0) {
                //如果有金币,先扣除(转化到sysGif中)
                [self reduceGoldInPid:pidStr withGold:totalPoint];
            }else{
                //如果没有了金币,则往下继续
                _platformRoundCheckCount++;
                [self updateGoldInfo:pid];
            }
        }else{
            // 第一次返回sysGif的总量
            _platformRoundCheckCount++;
            APPDELEGATE.userGoldAmont=totalPoint;
            [self updateGoldInfo:pid];
        }
        
    }
}



-(void) reduceGoldInPid:(NSString *) pidStr withGold:(int) reduceAmount
{
    if ([pidStr isEqualToString:DOMO_ID]){
        [_offerWallManager requestOnlineConsumeWithPoint:reduceAmount];
    }else if ([pidStr isEqualToString:LIMEI_ID]){
        [_liMei_AdWall immobViewReduceScore:reduceAmount WithAdUnitID:APPDELEGATE.LiMeiPlatform.appKey];
    }else if ([pidStr isEqualToString:DIANRU_ID]){
        [DianRuAdWall spendPoint:reduceAmount];
    }else if ([pidStr isEqualToString:MIDI_ID]){
        [MiidiAdWall requestSpendPoints:reduceAmount withDelegate:self];
    }else if ([pidStr isEqualToString:YOUMI_ID]){
        //有米平台是同步返回的,所以扣完款循环检测也-1
        if ([YouMiPointsManager spendPoints:reduceAmount]) {
            [self handleReducePlatformGoldWithPid:YOUMI_ID_INT]; 
        }else{
            [self handleErrorReduceGoldWithPid:YOUMI_ID_INT];
        }
    }else if ([pidStr isEqualToString:WANPU_ID]){
        //万普平台回调接口唯一,所以要有标示符
        _isRuduceGold=YES;
        [AppConnect spendPoints:reduceAmount];
    }else if([pidStr isEqualToString:ANWO_ID]){
        // 消费value个虚拟货币
        if(AdwoOWConsumePoints(reduceAmount, NULL))
        {
            [self handleReducePlatformGoldWithPid:ANWO_ID_INT];
        }else{
            [self handleErrorReduceGoldWithPid:ANWO_ID_INT];
        }
    }else if ([pidStr isEqualToString:YIJIFEN_ID]){
        int succ = [YJFScore consumptionScore:reduceAmount]; //[yjfScore consumptionScore:_sc] 返回1 表示成功消耗  0 失败
        if (succ == 1) {
            [self handleReducePlatformGoldWithPid:YIJIFEN_ID_INT];
        }else{
            [self handleErrorReduceGoldWithPid:YIJIFEN_ID_INT];
        }
    }else if ([pidStr isEqualToString:MOPAN_ID]){
        [_mopanAdWallControl spendMoney:reduceAmount];
    }else if([pidStr isEqualToString:AIPUDONGLI_ID]){
        [_powerWallViewController reduceScore:reduceAmount];
    }
}

-(void) handleErrorReduceGoldWithPid:(int ) pid
{
    if (!APPDELEGATE.isOldVesionUser) {
        _platformRoundCheckCount++;
        [self updateGoldInfo:pid];
    }else{
        _oldUserPlatformCheckCount++;
        [self handleOldUserGold];
    }
    
}

-(void) handleReducePlatformGoldWithPid:(int) pid{
    @synchronized(self)
    {
        int addGold=0;
        switch (pid) {
            case DOMO_ID_INT:
                addGold =_addGoldDOMOToSysGoldAmount;
                break;
            case LIMEI_ID_INT:
                addGold =_addGoldLiMeiToSysGoldAmount;
                break;
            case DIANRU_ID_INT:
                addGold =_addGoldDianRuToSysGoldAmount;
                break;
            case MIDI_ID_INT:
                addGold =_addGoldMIDIToSysGoldAmount;
                break;
            case YOUMI_ID_INT:
                addGold =_addGoldYOUMiToSysGoldAmount;
                break;
            case WANPU_ID_INT:
                addGold =_addGoldWanPuToSysGoldAmount;
                break;
            case ANWO_ID_INT:
                addGold=_addGoldAnWoToSysGoldAmount;
                break;
            case YIJIFEN_ID_INT:
                addGold=_addGoldYiJIFenToSysGoldAmount;
                break;
            case MOPAN_ID_INT:
                addGold=_addGoldMoPanToSysGoldAmount;
                break;
            case AIPUDONGLI_ID_INT:
                addGold=_addGoldAiPuDongLiToSysGoldAmount;
                break;
            default:
                break;
        }
        
        
        [UserGold addGoldOnSuccess:^(id json) {
            
            if (!APPDELEGATE.isOldVesionUser) {
                int resultGold=[[json objectForKey:@"goldAmount"] intValue];
                APPDELEGATE.userGoldAmont=APPDELEGATE.userGoldAmont+resultGold;
                _platformRoundCheckCount++;
                [self updateGoldInfo:pid];
            }else{
                _oldUserPlatformCheckCount++;
                [self handleOldUserGold];
            }

        } failure:^(id json) {
            [SVProgressHUD showErrorWithStatus:[json objectForKey:@"message"]];
            if (!APPDELEGATE.isOldVesionUser) {
                _platformRoundCheckCount++;
                [self updateGoldInfo:pid];
            }else{
                _oldUserPlatformCheckCount++;
                [self handleOldUserGold];
            }
            
        } withGoldData:[AppUtilities goldDataEncryptWithPid:pid andGoldAmount:addGold] withSecret:[AppUtilities TheSecretForAddGold:addGold WithTotalGold:APPDELEGATE.userGoldAmont withPid:SYS_GIF_ID_INT]];
        
    }
}
#pragma mark FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==GIFT_ALERVIEW_TAG) {
        [SVProgressHUD showWithStatus:@"收取礼物中..." maskType:SVProgressHUDMaskTypeBlack];
        [Users createUserOnSuccess:^(Users *user) {
            [APPDELEGATE initUserInfo:user];
            APPDELEGATE.isFirstTime=NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_CREATED_SUCCESS object:nil];
            [self performSelector:@selector(reloadGoldAmount) withObject:nil afterDelay:1];
        } failure:^(id error) {
            [AppUtilities handleErrorMessage:error];
        }];
    }
}
#pragma mark DMOfferWallDelegate
// 积分墙开始加载数据。
- (void)offerWallDidStartLoad
{
}
// 积分墙加载完成。此⽅方法实现中可进⾏行积分墙⼊入⼝口Button显⽰示等操作。
- (void)offerWallDidFinishLoad
{
    
}
// 积分墙加载失败。可能的原因由error部分提供,例如⺴⽹网络连接失败、被禁⽤用等。建议在此隐藏积分墙⼊入⼝口 Button。
- (void)offerWallDidFailLoadWithError:(NSError *)error
{
}



// 积分墙页面被关闭。
// Offer wall closed.
- (void)offerWallDidClosed
{
    //log4Debug(@"close");
}
#pragma mark Point Check Callbacks
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
// Called when finished to do point check.
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed
{
    
    [self handlePlatformGoldReturnWithGold:totalPoint-consumed andPid:DOMO_ID_INT pidStr:DOMO_ID];
}
// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
// Called when failed to do point check.
- (void)offerWallDidFailCheckPointWithError:(NSError *)error
{
    [self handleErrorLoadGoldWithPid:DOMO_ID_INT];
}
#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
// Called when finished to do consume point request and return the result of this consume.
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed
{
    if (statusCode==DMOfferWallConsumeStatusCodeSuccess) {
        [self handleReducePlatformGoldWithPid:DOMO_ID_INT];
    }else{
        [self handleErrorReduceGoldWithPid:DOMO_ID_INT];
    }
}
// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error
{
    //log4Error(error);
}

#pragma mark LIMEI delegate


/**
 *email phone sms等所需要
 *返回当前添加immobView的ViewController
 */
- (UIViewController *)immobViewController{
    
    return self;
}

- (void) immobViewDidReceiveAd:(immobView *)immobView{
    [SVProgressHUD dismiss];
    _liMei_AdWall.frame=[APPDELEGATE.window frame]; 
    //_liMei_AdWall.frame=[AppUtilities changeViewFrameJustForY:-40 withView:_liMei_AdWall];
    [self.parentViewController.view addSubview:_liMei_AdWall];
    [_liMei_AdWall immobViewDisplay];
    
}


/**
 *查询积分接口回调
 */
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message
{
    [self handlePlatformGoldReturnWithGold:score andPid:LIMEI_ID_INT pidStr:LIMEI_ID];
}

/**
 *减少积分接口回调
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message
{
    if (status) {
        [self handleReducePlatformGoldWithPid:LIMEI_ID_INT];
    }else{
        [self handleErrorReduceGoldWithPid:LIMEI_ID_INT];
    }
}

#pragma mark DIANRU delegate
/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess
{
    if (isSuccess) {
        [self handleReducePlatformGoldWithPid:DIANRU_ID_INT];
    }else{
        [self handleErrorReduceGoldWithPid:DIANRU_ID_INT];
    }
}

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point
{
    if(point == -1)
    {
        [self handleErrorLoadGoldWithPid:DIANRU_ID_INT];
    }
    else
    {
        //获取积分成功
        [self handlePlatformGoldReturnWithGold:point andPid:DIANRU_ID_INT pidStr:DIANRU_ID];
    }
    
}

#pragma mark MIDI delegate
#pragma mark  MiidiAdWallSpendPointsDelegate


- (void)didReceiveSpendPoints:(NSInteger)totalPoints{
	
	[self handleReducePlatformGoldWithPid:MIDI_ID_INT];
}


- (void)didFailReceiveSpendPoints:(NSError *)error{
    [self handleErrorReduceGoldWithPid:MIDI_ID_INT];
}

#pragma mark  MiidiAdWallGetPointsDelegate


- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName{
	[self handlePlatformGoldReturnWithGold:totalPoints andPid:MIDI_ID_INT pidStr:MIDI_ID];
}


- (void)didFailReceiveGetPoints:(NSError *)error{
	[self handleErrorLoadGoldWithPid:MIDI_ID_INT];
}
- (void)didReceiveAwardPoints:(NSInteger)totalPoints
{
    //log4Debug(@"award %d",totalPoints);
} 

// 请求奖励积分数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveAwardPoints:(NSError *)error
{
    //log4Debug(error);
}

#pragma mark -
#pragma mark YouMiWallDelegate




#pragma mark -
#pragma mark WANPU delegate

-(void)getUpdatedPoints:(NSNotification*)notifyObj
{  
    WapsUserPoints *userPointsObj = notifyObj.object;
    int  pointsValue=[userPointsObj getPointsValue];
    if (_isRuduceGold) {
        [self handleReducePlatformGoldWithPid:WANPU_ID_INT];
    }else{
        [self handlePlatformGoldReturnWithGold:pointsValue andPid:WANPU_ID_INT pidStr:WANPU_ID];
    }
}

- (void)getUpdatedPointsFailed:(NSNotification*)notifyObj
{
    [self handleErrorLoadGoldWithPid:WANPU_ID_INT];
}
#pragma mark -
#pragma mark DianRu delegate

- (NSString *)applicationKey {
    if (APPDELEGATE.appVersionInfo.isHide==1) {
        return @"00001304090000C5";
    }else
        return APPDELEGATE.DianRuPlatform.appKey;
}

- (int) adType
{
    return 0;
}


- (NSString *)keyWords
{
    return @"生活";
}


- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (BOOL)shouldUsingOrientationRelatedContent
{
    return YES;
}

//此处需要判断一下sdkView是否已设置，如果已存在直接更新Frame即可
-(void)didReceiveAdView:(UIView*)adView
{
    
    if(!_dianruBannarView)
    {
        _dianruBannarView = (DianRuSDK *)adView;
        [self.view addSubview:_dianruBannarView];
        self.dianruBannarView.center=CGPointMake(160, -25);
    }
}


#pragma mark Point Check Callbacks
// 积分墙开始加载数据。
// Adall starts to work.
- (void)adwallDidShowAppsStartLoad
{
    NSLog(@"[mopan] 开始加载积分墙");
	
	
}

// 关闭积分墙页面。
// Offer wall closed.
- (void)adwallDidShowAppsClosed
{
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)adwallDidFailShowAppsWithError:(NSError *)error
{
	
}

// 请求积分值成功后调用
//
// 详解:当接收服务器返回的积分值成功后调用该函数
// 补充：totalMoney: 返回用户的总积分
//      moneyName  : 返回的积分名称
- (void)adwallSuccessGetMoney:(NSInteger)totalMoney forMoneyName:(NSString*)moneyName
{
    NSLog(@"[mopan] 成功获取金币! 总金币值=%d",totalMoney);
    [self handlePlatformGoldReturnWithGold:totalMoney andPid:MOPAN_ID_INT pidStr:MOPAN_ID];
	
}

// 请求积分值数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)adwallFailGetMoney:(NSError *)error
{
    NSLog(@"[mopan] 获取金币失败!");
    [self handleErrorLoadGoldWithPid:MOPAN_ID_INT];
}

// 消耗金币成功后调用
//
// 详解:当接收服务器返回的消耗积分成功后调用该函数
// 补充：totalMoney: 返回用户的总积分

- (void)adwallSuccessSpendMoney:(NSInteger)totalMoney
{
    NSLog(@"[mopan] 成功减少金币! 总金币值=%d",totalMoney);
	[self handleReducePlatformGoldWithPid:MOPAN_ID_INT];
}


// 请求消耗积分数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)adwallFailSpendMoney:(NSError *)error
{
    NSLog(@"[mopan] 减少金币失败!");
    [self handleErrorReduceGoldWithPid:MOPAN_ID_INT];
}

#pragma mark - ADCADCPowerWallViewControllerDelegate methods

- (void)powerWallDidDismiss{
    NSLog(@"power wall dismiss !");
}

-(void)iOSAppListLoaded:(id)responseObject
{
    if ([[responseObject class] isSubclassOfClass:[NSString class]]) {      // 获取iPhoneApp数据成功
        NSLog(@"%@", (NSString *)responseObject);
    }else if ([[responseObject class] isSubclassOfClass:[ADCError class]]) {    // 获取iPhoneApp数据失败
        NSLog(@"%@", [(ADCError *)responseObject description]);
    }
}

-(void)iOSRecommendAppListLoaded:(id)responseObject
{
    if ([[responseObject class] isSubclassOfClass:[NSString class]]) {      // 获取特别赞助数据数据成功
        NSLog(@"%@", (NSString *)responseObject);
    }else if ([[responseObject class] isSubclassOfClass:[ADCError class]]) {    // 获取特别赞助数据数据失败
        NSLog(@"%@", [(ADCError *)responseObject description]);
    }
}

-(void)getScoreFinished:(CGFloat)totalScore
{
   // _scoreLabel.text = [NSString stringWithFormat:@"当前积分：%.0f", totalScore];
    [self handlePlatformGoldReturnWithGold:totalScore andPid:AIPUDONGLI_ID_INT  pidStr:AIPUDONGLI_ID];

}

- (void)reduceScoreFinished:(CGFloat)totalScore{
    //_scoreLabel.text = [NSString stringWithFormat:@"消耗掉 5 个积分， 剩余积分 %.0f", totalScore];
    [self handleReducePlatformGoldWithPid:AIPUDONGLI_ID_INT];
    
}

- (void)getScoreFailed:(ADCError *)error{
    NSLog(@"%@",[error description]);
    [self handleErrorLoadGoldWithPid:AIPUDONGLI_ID_INT];
}

- (void)reduceScoreFailed:(ADCError *) error{
    NSLog(@"%@",[error description]);
    [self handleErrorReduceGoldWithPid:AIPUDONGLI_ID_INT];
}

@end
