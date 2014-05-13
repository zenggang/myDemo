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
#import "PunchBoxAd.h"


@interface BaseGoldViewController()<PBOfferWallDelegate>

@property (nonatomic,strong) DMOfferWallViewController *DMOWallController;
@property (nonatomic,strong) DMOfferWallManager *offerWallManager;

@property (nonatomic,strong) immobView *liMei_AdWall;
@property (nonatomic,strong)  YJFIntegralWall *integralWall;
@property (nonatomic,strong)     QumiOfferWall *qumiViewController;
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
@property (nonatomic,assign) NSInteger addGoldAiDeSiQiToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldXingYunToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldJuPengToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldGuoMengToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldQuMiToSysGoldAmount;
@property (nonatomic,assign) NSInteger addGoldChuKongToSysGoldAmount;

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
            [self reqeustQuMIBannar];
        }else
            [self showFUIAlertViewWithTitle:@"欢迎使用!" message:@"您是第一次使用免费赚金币功能,系统将赠送给您一份神秘大礼!" withTag:GIFT_ALERVIEW_TAG cancleButtonTitle:@"确认接收"  otherButtonTitles:nil];
    }else{
        [self reloadGoldAmount];
        if (APPDELEGATE.appVersionInfo.isHide==1) {
             [self reqeustQuMIBannar];
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

//趣米bananr广告条
-(void) reqeustQuMIBannar
{
    _qumiBannerAD = [[QumiBannerAD alloc] initWithQumiBannerAD];
    self.qumiBannerAD.frame = CGRectMake(0, 0, 320, 50);
    //设置代理
    self.qumiBannerAD.delegate = self;
    //设置根式图
    self.qumiBannerAD.rootViewController = self;
    //开始加载和展示广告
    [self.qumiBannerAD loadBannerAd];
    //将广告视图添加到父视图中去
    [self.view addSubview:self.qumiBannerAD];
}
#pragma mark -
#pragma mark QumiBannerADDelegate Methods
//加载广告成功后，回调该方法
- (void)qmAdViewSuccessToLoadAd:(QumiBannerAD *)adView
{
    NSLog(@"banner广告加载成功！");
}
//加载广告失败后，回调该方法
- (void)qmAdViewFailToLoadAd:(QumiBannerAD *)adView withError:(NSError *)error
{
    NSLog(@"banner广告加载失败，失败信息是：%@",error);
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    //开发者在销毁控制器的时候，注意销毁注册响应事件，否则可能会因为异步处理问题造成程序崩溃。
    AdwoOWUnregisterResponseEvents(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS|ADWO_OFFER_WALL_REFRESH_POINT|ADWO_OFFER_WALL_CONSUMEPOINTS_POINT);
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
                                              powerWallViewControllerDelegate:self];
        _powerWallViewController.delegate=self;
    }
    
    if (APPDELEGATE.AiDeSiQiPlatform.state==1) {
        _owViewController=[[MobiSageOfferWallViewController alloc] initWithPublisherID:APPDELEGATE.AiDeSiQiPlatform.appKey];
        [_owViewController setURLScheme:APPDELEGATE.appVersionInfo.weixinId];
        _owViewController.delegate=self;
    }
    //安沃
    if (APPDELEGATE.AnWoPlatform.state==1) {
        // 注册积分墙被关闭事件消息
        AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS, self, @selector(dismissSelector));
        // 注册积分消费响应事件消息
        AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_CONSUMEPOINTS_POINT, self, @selector(adwoOWConsumepoint));
        // 注册积分墙刷新最新积分响应事件消息，使用分数的时候，开发者应该先刷新积分接口获得服务器的最新积分，再利用此分数进行相关操作
        AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_REFRESH_POINT, self, @selector(adwoOWRefreshPoint));
    }
    
    //果盟
    if (APPDELEGATE.GuoMengPlatForm.state==1) {
        _guoMengWallVc=[[GuoMobWallViewController alloc] initWithId:APPDELEGATE.GuoMengPlatForm.appKey];
        _guoMengWallVc.delegate=self;
        _guoMengWallVc.updatetime=0;
        //设置积分墙是否显示状态栏 默认隐藏
        _guoMengWallVc.isStatusBarHidden=NO;
    }
    
    if (APPDELEGATE.QuMiPlatForm.state==1) {
        //创建积分墙广告 pointUserId可选，根据需要开发者自己设置，设置pointUserId可以实现在不同设备上同步该用户的积分。
        _qumiViewController = [[QumiOfferWall alloc] initwithPointUserID:nil];
        _qumiViewController.delegate = self;
        _qumiViewController.rootViewController = self;
    }
    
    if (APPDELEGATE.ChuKongPlatForm.state==1) {
        [PBOfferWall sharedOfferWall].delegate = self;
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

- (void)getAnWoPoints
{
    AdwoOWRefreshPoint();
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
                                                         useSandBox:NO];
    
}

//磨盘平台
-(void) openMoPanWall
{
    [_mopanAdWallControl showAppOffers];
}

//艾德思奇
-(void) openAiDeSiQiWall
{
    [_owViewController presentOfferWallWithViewController:self];
}
//行云平台
-(void) openXingYunWall
{
    GuScoreWall *socreWall = [[GuScoreWall alloc]init];
    [self presentViewController:socreWall animated:YES completion:nil];
}

-(void)getXingYunScore
{
    [GuScore getScore:self];
}

//巨朋平台
-(void) openJuPengWall
{
    [JupengWall showOffers:self
              didShowBlock:^{
                  NSLog(@"巨朋积分墙已显示");
              } didDismissBlock:^{
                  NSLog(@"巨朋积分墙已退出");
              }];
}

-(void) getJuPengScore
{
    [JupengWall getScore:^(NSError* error,NSInteger userTotalScore)
     {
        if(error == nil){
             
             [self handlePlatformGoldReturnWithGold:userTotalScore andPid:JUPENG_ID_INT pidStr:JUPENG_ID];
        }else{
             [self handleErrorLoadGoldWithPid:JUPENG_ID_INT];
         }
     }];
}

//果盟广告
- (void)openGuoMengWall
{
    //第一个参数YES表示允许旋转,NO表示禁止旋转
    
    //第二个参数isHscreen表示应用如果禁止旋转，那么固定是横还是竖，YES是横、NO是竖
    [_guoMengWallVc pushGuoMobWall:NO Hscreen:NO];
}

-(void)getGuoMengGold
{
    [_guoMengWallVc updatePoint];
}

//趣米平台
//打开趣米积分墙
- (void)openQumiWall
{
    [_qumiViewController presentQumiOfferWall];
}

//领取积分
- (void)getQuMiScore
{
    [_qumiViewController getPointsQueue];
}

//触控平台
- (void)openChuKongWall
{
    [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
}
-(void) queryChuKongCoinForThread
{
    [[PBOfferWall sharedOfferWall] queryRewardCoin:^(NSArray *taskCoins, PBRequestError *error) {
        if (taskCoins.count>0) {
            int goldAmount =0;
            for (NSDictionary *task in taskCoins) {
                goldAmount=goldAmount+[[task objectForKey:@"task"] integerValue];
            }
            [self handlePlatformGoldReturnWithGold:goldAmount andPid:CHUKONG_ID_INT pidStr:CHUKONG_ID];
        }else{
            [self handlePlatformGoldReturnWithGold:0 andPid:CHUKONG_ID_INT pidStr:CHUKONG_ID];
        }
        
    }];
}

-(void) reloadGoldAmount
{
    if (!APPDELEGATE.appVersionInfo) {
        return;
    }

    [SVProgressHUD showWithStatus:@"更新金币数据中..." maskType:SVProgressHUDMaskTypeBlack];
    _platformRoundCheckCount=0;
    
    [UserGold getUserGifGodOnSuccess:^(UserGold *gold) {
        [self handlePlatformGoldReturnWithGold:gold.goldAmount andPid:SYS_GIF_ID_INT pidStr:SYS_GIF_ID];
        
        if (APPDELEGATE.YouMiPlatform.state==1) {
            int *totalPoint =[YouMiPointsManager pointsRemained];
            [self handlePlatformGoldReturnWithGold:*totalPoint andPid:YOUMI_ID_INT pidStr:YOUMI_ID];
        }

        if (APPDELEGATE.YiJiFenPlatform.state==1) {
            int totalPoint =[self getYiJifenScore];
            [self handlePlatformGoldReturnWithGold:totalPoint andPid:YIJIFEN_ID_INT pidStr:YIJIFEN_ID];
        }
        if (APPDELEGATE.AiPuDongLiPlatform.state==1)
            [_powerWallViewController getScore];
        
        if(APPDELEGATE.DuoMenPlatform.state==1)
            [_offerWallManager requestOnlinePointCheck];
        if(APPDELEGATE.LiMeiPlatform.state ==1)
            [_liMei_AdWall immobViewQueryScoreWithAdUnitID:APPDELEGATE.LiMeiPlatform.appKey];
        if(APPDELEGATE.DianRuPlatform.state==1)
            //    //获取积分，异步方法，结果在代理中进行回调
            [DianRuAdWall getRemainPoint];
        if(APPDELEGATE.MidiPlatform.state==1)
            [MiidiAdWall requestGetPoints:self];
        
        //万普平台回调接口唯一,所以要有标示符
        if(APPDELEGATE.WanPuPlatform.state==1){
            _isRuduceGold=NO;
            [AppConnect getPoints];
        }
        if(APPDELEGATE.MoPanPlatform.state==1)
            [_mopanAdWallControl getMoney];
        if(APPDELEGATE.AiDeSiQiPlatform.state==1)
            [_owViewController requestOnlinePointCheck];
        if (APPDELEGATE.AnWoPlatform.state==1) {
            [self getAnWoPoints];
        }
        if (APPDELEGATE.XingYunPlatform.state==1) {
            [self getXingYunScore];
        }
        if (APPDELEGATE.JuPengPlatForm.state==1) {
            [self getJuPengScore];
        }
        if (APPDELEGATE.GuoMengPlatForm.state==1) {
            [self getGuoMengGold];
        }
        if (APPDELEGATE.QuMiPlatForm.state==1) {
            [self getQuMiScore];
        }
        if (APPDELEGATE.ChuKongPlatForm.state==1) {
            [NSThread detachNewThreadSelector:@selector(queryChuKongCoinForThread) toTarget:self withObject:nil];
        }
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
        NSLog(@"return 平台id:%d 顺序: %d %d",pid,_platformRoundCheckCount,totalPoint);
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
            case AIDESIQI_ID_INT:
                _addGoldAiDeSiQiToSysGoldAmount=totalPoint;
                break;
            case XINGYUN_ID_INT:
                _addGoldXingYunToSysGoldAmount=totalPoint;
                break;
            case JUPENG_ID_INT:
                _addGoldJuPengToSysGoldAmount=totalPoint;
                break;
            case GUOMENG_ID_INT:
                _addGoldGuoMengToSysGoldAmount=totalPoint;
                break;
            case QUMI_ID_INT:
                _addGoldQuMiToSysGoldAmount=totalPoint;
                break;
            case CHUKONG_ID_INT:
                _addGoldChuKongToSysGoldAmount=totalPoint;
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
        AdwoOWConsumePoints(reduceAmount);
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
    }else if([pidStr isEqualToString:AIDESIQI_ID]){
        [_owViewController requestOnlineConsumeWithPoint:reduceAmount];
    }else if ([pidStr isEqualToString:XINGYUN_ID])
        [GuScore consumptionScore:reduceAmount delegate:self];
    else if ([pidStr isEqualToString:JUPENG_ID]){
        [JupengWall spendScore:reduceAmount didSpendBlock:^(NSError* error,NSInteger userTotalScore)
         {
             if(error == nil){
                 [self handleReducePlatformGoldWithPid:JUPENG_ID_INT];
             }else{
                 [self handleErrorReduceGoldWithPid:JUPENG_ID_INT];
             }
         }];
    }else if ([pidStr isEqualToString:GUOMENG_ID]){
        [self handleReducePlatformGoldWithPid:GUOMENG_ID_INT];
    }else if([pidStr isEqualToString:QUMI_ID]){
        
        [_qumiViewController consumePoints:reduceAmount];
    }else if ([pidStr isEqualToString:CHUKONG_ID]){
        [self handleReducePlatformGoldWithPid:CHUKONG_ID_INT];
    }
        
}

-(void) handleErrorReduceGoldWithPid:(int ) pid
{
    _platformRoundCheckCount++;
    [self updateGoldInfo:pid];
    
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
             case AIDESIQI_ID_INT:
                addGold=_addGoldAiDeSiQiToSysGoldAmount;
                break;
            case XINGYUN_ID_INT:
                addGold=_addGoldXingYunToSysGoldAmount;
                break;
            case JUPENG_ID_INT:
                addGold=_addGoldJuPengToSysGoldAmount;
                break;
            case GUOMENG_ID_INT:
                addGold=_addGoldGuoMengToSysGoldAmount;
                break;
            case QUMI_ID_INT:
                addGold=_addGoldQuMiToSysGoldAmount;
                break;
            case CHUKONG_ID_INT:
                addGold=_addGoldChuKongToSysGoldAmount;
                break;
            default:
                break;
        }
        
        if (addGold>0) {
            [UserGold addGoldOnSuccess:^(id json) {
                
                int resultGold=[[json objectForKey:@"goldAmount"] intValue];
                APPDELEGATE.userGoldAmont=APPDELEGATE.userGoldAmont+resultGold;
                _platformRoundCheckCount++;
                [self updateGoldInfo:pid];
                
            } failure:^(id json) {
                [SVProgressHUD showErrorWithStatus:[json objectForKey:@"message"]];
                _platformRoundCheckCount++;
                [self updateGoldInfo:pid];
            } withGoldData:[AppUtilities goldDataEncryptWithPid:pid andGoldAmount:addGold] withSecret:[AppUtilities TheSecretForAddGold:addGold WithTotalGold:APPDELEGATE.userGoldAmont withPid:SYS_GIF_ID_INT]];
        }

        
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

- (void)didReceiveOffers
{}

- (void)didShowWallView
{}
- (void)didDismissWallView
{}
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
    [self handlePlatformGoldReturnWithGold:totalScore andPid:AIPUDONGLI_ID_INT  pidStr:AIPUDONGLI_ID];

}

- (void)reduceScoreFinished:(CGFloat)totalScore{
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

//艾德思奇回调
//----------------检查积分通知
- (void)offerWallDidFinishCheckPointWithBalancePoint:(MobiSageOfferWallViewController *)owInterstitial balance:(NSInteger)balance
                               andTotalConsumedPoint:(NSInteger)consumed
{
    if(owInterstitial==_owViewController)
    {
        [self handlePlatformGoldReturnWithGold:balance andPid:AIDESIQI_ID_INT pidStr:AIDESIQI_ID];
        NSLog(@"检查积分DidFinish");
    }
    
}
- (void)offerWallDidFailCheckPointWithError:(MobiSageOfferWallViewController *)owInterstitial withError:(NSError *)error
{
    if(owInterstitial==_owViewController)
    {
     
        [self handleErrorLoadGoldWithPid:AIDESIQI_ID_INT];
        NSLog(@"检查积分offerWallDidFailCheckPointWithError:%@",error);
    }
    
}
//-------------------消费积分通知
- (void)offerWallDidFinishConsumePointWithStatusCode:(MobiSageOfferWallViewController *)owInterstitial code:(MobiSageOfferWallConsumeStatusCode)statusCode
                                        balancePoint:(NSInteger)balance
                                  totalConsumedPoint:(NSInteger)consumed
{
    if(owInterstitial==_owViewController)
    {
        if(statusCode==MobiSageOfferWallConsumeStatusCodeSuccess)
        {
            NSLog(@"消费积分完成");
            [self handleReducePlatformGoldWithPid:AIDESIQI_ID_INT];
            
        }
        if(statusCode==MobiSageOfferWallConsumeStatusCodeInsufficient)
        {
            NSLog(@"消费积分余额不足");
            [self handleErrorReduceGoldWithPid:AIDESIQI_ID_INT];
        }
        if(statusCode==MobiSageOfferWallConsumeStatusCodeDuplicateOrder)
        {
            NSLog(@"消费积分错误未知");
            [self handleErrorReduceGoldWithPid:AIDESIQI_ID_INT];
        }
    }
}
- (void)offerWallDidFailConsumePointWithError:(MobiSageOfferWallViewController *)owInterstitial withError:(NSError *)error;
{
    if(owInterstitial==_owViewController)
    {
        [self handleErrorReduceGoldWithPid:AIDESIQI_ID_INT];
        NSLog(@"消费积分offerWallDidFailConsumePointWithError:%@",error);
    }
}
#pragma mark - adwo offerwall delegates
//登陆积分墙的代理方法
- (void)loginSelector
{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
        NSLog(@"Login successfully!");
    else
        NSLog(@"Login failed, because ");
}
//退出积分墙的代理方法
- (void)dismissSelector
{
    NSLog(@"I know, the wall is dismissed!");
}

//消费积分响应的代理方法，开发者每次消费积分之后，需要在收到此响应之后才表示完成一次消费
-(void)adwoOWConsumepoint{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
    {
        [self handleReducePlatformGoldWithPid:ANWO_ID_INT];
    }
    else{
        [self handleErrorReduceGoldWithPid:ANWO_ID_INT];
    }
}

//刷新积分响应的代理方法
-(void)adwoOWRefreshPoint{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
    {
        NSLog(@"adwoOWRefreshPoint successfully!");
        int pRemainPoints;
        //当刷新到最新积分之后，利用此函数获得当前积分。
        AdwoOWGetCurrentPoints(&pRemainPoints);
        [self handlePlatformGoldReturnWithGold:pRemainPoints andPid:ANWO_ID_INT pidStr:ANWO_ID];
    }
    else{
        NSLog(@"Login failed, because ");
        [self handleErrorLoadGoldWithPid:ANWO_ID_INT];
    }
}

#pragma mark 行云平台 Delegate- 查询积分成功回调 _score:剩余总积分；unit：单位
-(void)getAdScoreSucess:(int)_score unit:(NSString *) unit;
{
    NSLog(@"当前积分为：%d,单位:%@",_score,unit);
    [self handlePlatformGoldReturnWithGold:_score andPid:XINGYUN_ID_INT pidStr:XINGYUN_ID];
    
}
#pragma mark - 查询积分失败回调
-(void)getAdSCoreFailed:(int)_code error:(NSString *) error;
{
    NSLog(@"查询失败:%@",error);
    [self handleErrorLoadGoldWithPid:XINGYUN_ID_INT];
}

#pragma mark - 消耗积分成功回调 _score:消耗的分；balance:剩余总积分;unit:单位
-(void)consumptionAdScoreSucess:(int)_score balance:(int)balance unit:(NSString *) unit;
{
    
    NSLog(@"消耗积分为:%d,剩余积分:%d",_score,balance);
    [self handleReducePlatformGoldWithPid:XINGYUN_ID_INT];
}
#pragma mark - 消耗积分失败回调
-(void)consumptionAdScoreFailed:(int)_code error:(NSString *)error;
{
    NSLog(@"消耗失败:%@",error);
    [self handleErrorReduceGoldWithPid:XINGYUN_ID_INT];
}

#pragma mark - 果盟回调
//刷新积分的错误
- (void)GMUpdatePointError:(NSString *)error
{
    [self handleErrorLoadGoldWithPid:GUOMENG_ID_INT];
}
//appname 返回打开或下载的应用名字  point返回积分
- (void)checkPoint:(NSString *)appname point:(int)point
{
    [self handlePlatformGoldReturnWithGold:point andPid:GUOMENG_ID_INT pidStr:GUOMENG_ID];
}

#pragma mark -趣米回调

//请求领取积分成功方法的回调
- (void)qumiAdWallGetPointSuccess:(NSString *)getPointState
{
    [_qumiViewController queryRemainPoints];
}

//请求领取积分失败方法的回调
- (void)qumiAdWallGetPointFailed:(NSError *)error
{
    [self handleErrorLoadGoldWithPid:QUMI_ID_INT];
}

//请求检查剩余积分成功后，回调该方法，获得总积分数和返回的积分数。
- (void)QumiAdWallCheckPointsSuccess:(NSInteger)remainPoints
{
    [self handlePlatformGoldReturnWithGold:remainPoints andPid:QUMI_ID_INT pidStr:QUMI_ID];
}

//请求检查剩余积分失败后，回调该方法，返回检查积分失败信息
-(void)QumiAdWallCheckPointsFailWithError:(NSError *)error
{
    [self handleErrorLoadGoldWithPid:QUMI_ID_INT];
}

//消费请求成功之后，回调该方法，返回消费情况(消费成功，或者当前的余额不足)，以及当前的总积分数
- (void)QumiAdWallConsumePointsSuccess:(NSString *)ConsumeState remainPoints:(NSInteger)points
{
    [self handleReducePlatformGoldWithPid:QUMI_ID_INT];
}

//消费请求失败之后，回调该方法，返回失败信息。
- (void)QumiAdWallConsumePointsFailWithError:(NSError *)error
{
    [self handleErrorReduceGoldWithPid:QUMI_ID_INT];
}

#pragma mark -
#pragma mark QumiOfferWall GetPointsFromWall Methods
//点击积分墙上的领取按钮，获得的积分
- (void)QumiADWallGetPointsFromWall:(NSInteger)points
{
    //如果领取积分成功，失败信息就填写nil，如果失败，就填写失败的内容。
    NSString *error = @"nil";
    //如果用户领取积分成功，那么就发送成功信息
    //用户是否获取积分成功  如果获取积分成功，就发送成功的状态，如果失败，就发送失败的信息
    BOOL isSuccess = YES;
    NSDictionary *dictionary = [[NSDictionary alloc] init] ;
    NSString *getScoreState = nil;
    if (isSuccess)
    {
        NSLog(@"用户获取了%d积分！",points);
        //领取积分之后，开发者需要调用追加积分的方法。
        [_qumiViewController appendPoints:points];
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:QUMI_GET_POINTS_SUCCESS,QUMI_GET_POINTS_KEY_STATES,error,QUMI_GET_POINTS_ERROR, nil];
        getScoreState = @"恭喜您获取积分成功";
        [_qumiViewController queryRemainPoints];
    }
    else
    {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:QUMI_GET_POINTS_FAILED,QUMI_GET_POINTS_KEY_STATES,error,QUMI_GET_POINTS_ERROR, nil];
        getScoreState = @"获取积分失败";
        [self handlePlatformGoldReturnWithGold:0 andPid:QUMI_ID_INT pidStr:QUMI_ID];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:QUMI_GET_POINTS_STATES object:self userInfo:dictionary];
}

#pragma mark - ChuKongWallDelagte

- (void)pbOfferWall:(PBOfferWall *)pbOfferWall queryResult:(NSArray *)taskCoins
          withError:(PBRequestError *)error
{
    
}

- (void)pbOfferWallDidPresentScreen:(PBOfferWall *)pbOfferWall
{
    NSLog(@"打开触控墙");
}

@end
