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

@interface BaseGoldViewController()
@property (nonatomic,strong) DMOfferWallViewController *DMOWallController;

@property (nonatomic,strong) immobView *liMei_AdWall;
//@property (atomic,assign) int latestGoldAmount;
@property (atomic,assign) int platformRoundCheckCount;
@property (nonatomic,assign) BOOL isAllGoldLoaded;
@property (nonatomic, retain) YouMiWall *youmiWall;

@property (nonatomic,assign) NSInteger addToSysGoldAmount;
//@property (nonatomic,assign) int reducePlatformCount;
//@property (atomic,assign) int reduceRoundCheckCount;
@property (nonatomic,assign) BOOL isRuduceGold;
@property (nonatomic,strong) NSMutableString *reduceGoldData;
@property (nonatomic,strong) NSMutableString *reduceGoldKeyString;
@end
#define GIFT_ALERVIEW_TAG 888
//96ZJ1DugzewKLwTA2p 我的
#define DMO_PUBLISHER_ID @"96ZJ1DugzewKLwTA2p"
#define LIMEI_PUBLISHER_ID @"cad9cd3a95588e5de2c65cd75b910ce2"



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
        }else
            [self showFUIAlertViewWithTitle:@"欢迎使用!" message:@"您是第一次使用免费赚金币功能,系统将赠送给您一份神秘大礼!" withTag:GIFT_ALERVIEW_TAG cancleButtonTitle:@"确认接收"  otherButtonTitles:nil];
    }else{
        [self reloadGoldAmount];
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
    if (!_DMOWallController) {
        _DMOWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DMO_PUBLISHER_ID];
        _DMOWallController.disableStoreKit = YES;
        _DMOWallController.delegate = self;
        // 加载积分墙并等待delegate的回调。
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        _DMOWallController.rootViewController=rootViewController;
    }
    
    if (!_liMei_AdWall) {
        _liMei_AdWall=[[immobView alloc] initWithAdUnitID:LIMEI_PUBLISHER_ID];
        _liMei_AdWall.delegate=self;
    }
    //点入平台
    [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
    //有米
    self.youmiWall = [YouMiWall new] ;

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    //指定获取用户积分的回调方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUpdatedPoints:)
                                                 name:WAPS_GET_POINTS_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUpdatedPointsFailed:)
                                                 name:WAPS_GET_POINTS_FAILED
                                               object:nil];

    
}


-(void)viewWillUnload{
    [super viewWillUnload];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WAPS_GET_POINTS_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WAPS_GET_POINTS_FAILED object:nil];
    
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
    [DianRuAdWall showAdWall:self];
}

-(void) openMIDIWall
{
    [MiidiAdWall showAppOffers:self withDelegate:self];
}

-(void) openYOUMIWall
{
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

-(void) changeTheGoldToNewVersion
{
    for (UserGold *gold in APPDELEGATE.loginUser.userGoldList) {
        if (gold.pid>1 && gold.goldAmount) {
            
        }
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
//    _latestGoldAmount=0;
    

    
    [UserGold getUserGifGodOnSuccess:^(UserGold *gold) {
        [self handlePlatformGoldReturnWithGold:gold.goldAmount andPid:SYS_GIF_ID_INT pidStr:SYS_GIF_ID];
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:DOMO_ID]).state==1)
            [_DMOWallController requestOnlinePointCheck];
        if(((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:LIMEI_ID]).state ==1)
            [_liMei_AdWall immobViewQueryScoreWithAdUnitID:LIMEI_PUBLISHER_ID];
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
    } failure:^(id error) {
        [self handleErrorLoadGoldWithPid:SYS_GIF_ID_INT];
    }];
    _isAllGoldLoaded=YES;
}


-(void) reduceGoldInPid:(NSString *) pidStr withGold:(int) reduceAmount
{
    if ([pidStr isEqualToString:DOMO_ID]){
        [_DMOWallController requestOnlineConsumeWithPoint:reduceAmount];
    }else if ([pidStr isEqualToString:LIMEI_ID]){
        [_liMei_AdWall immobViewReduceScore:reduceAmount WithAdUnitID:LIMEI_PUBLISHER_ID];
    }else if ([pidStr isEqualToString:DIANRU_ID]){
        [DianRuAdWall spendPoint:reduceAmount];
    }else if ([pidStr isEqualToString:MIDI_ID]){
        [MiidiAdWall requestSpendPoints:reduceAmount withDelegate:self];
    }else if ([pidStr isEqualToString:YOUMI_ID]){
        //有米平台是同步返回的,所以扣完款循环检测也-1
        if ([YouMiPointsManager spendPoints:reduceAmount]) {
//            _reducePlatformCount--;
        }
    }else if ([pidStr isEqualToString:WANPU_ID]){
        //万普平台回调接口唯一,所以要有标示符
        _isRuduceGold=YES;
        [AppConnect spendPoints:reduceAmount];
    } 
}

-(void) reduceGold
{
    if (_reduceGoldType==nil && !_isGuaGuaLeDeduce) {
        return;
    }
    [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeClear];
    //初始化变量
    NSMutableDictionary *paltFormReducGoldDict=[NSMutableDictionary dictionary];
//    _reducePlatformCount=0;
 //   _reduceRoundCheckCount=0;
    _reduceGoldData=[NSMutableString stringWithString:@""];
    _reduceGoldKeyString=[NSMutableString stringWithString:@""];
    int reduceGoldAmount=0;
    if (_isGuaGuaLeDeduce) {
        reduceGoldAmount=_guaGuaLeDeduceGoldAmount;
    }else{
        reduceGoldAmount=_reduceGoldType.goldAmount;
    }
    //sysGif的金币不在前台扣
    for (int i=2; i<=7; i++) {
        int platGold=[[APPDELEGATE.userGoldDict objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];
        if (((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:[NSString stringWithFormat:@"%d",i]]).state ==0) {
            continue;
        }
        if (platGold>=reduceGoldAmount) {
            [paltFormReducGoldDict setObject:[NSNumber numberWithInt:reduceGoldAmount] forKey:[NSString stringWithFormat:@"%d",i]];
//            _reducePlatformCount++;
            [_reduceGoldData appendFormat:@"%@,",[AppUtilities goldDataEncryptWithPid:i andGoldAmount:reduceGoldAmount]];
            [_reduceGoldKeyString appendFormat:@"%d,%d,%d,",reduceGoldAmount,platGold,i];
            [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:(platGold-reduceGoldAmount)] forKey:[NSString stringWithFormat:@"%d",i]];
            break;
        }else if(platGold>0){
            [paltFormReducGoldDict setObject:[NSNumber numberWithInt:platGold] forKey:[NSString stringWithFormat:@"%d",i]];
            [_reduceGoldData appendFormat:@"%@,",[AppUtilities goldDataEncryptWithPid:i andGoldAmount:platGold]];
            [_reduceGoldKeyString appendFormat:@"%d,%d,%d,",platGold,platGold,i];
            [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",i]];
            reduceGoldAmount=reduceGoldAmount-platGold;
//            _reducePlatformCount++;
            if (reduceGoldAmount==0) {
                break;
            }
        }
    }
    //其他平台扣完不足扣sysGif
    if (reduceGoldAmount>0) {
        int platGold=[[APPDELEGATE.userGoldDict objectForKey:@"1"] intValue];
        [paltFormReducGoldDict setObject:[NSNumber numberWithInt:reduceGoldAmount] forKey:@"1"];
        [_reduceGoldData appendFormat:@"%@,",[AppUtilities goldDataEncryptWithPid:1 andGoldAmount:reduceGoldAmount]];
        [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:(platGold-reduceGoldAmount)] forKey:@"1"];
    }
    
    for (NSString *key in paltFormReducGoldDict.allKeys) {
        int  reduceAmount = [[paltFormReducGoldDict objectForKey:key] intValue];
        if ([key isEqualToString:DOMO_ID]){
            [_DMOWallController requestOnlineConsumeWithPoint:reduceAmount];
        }else if ([key isEqualToString:LIMEI_ID]){
            [_liMei_AdWall immobViewReduceScore:reduceAmount WithAdUnitID:LIMEI_PUBLISHER_ID];
        }else if ([key isEqualToString:DIANRU_ID]){
            [DianRuAdWall spendPoint:reduceAmount];
        }else if ([key isEqualToString:MIDI_ID]){
            [MiidiAdWall requestSpendPoints:reduceAmount withDelegate:self];
        }else if ([key isEqualToString:YOUMI_ID]){
            //有米平台是同步返回的,所以扣完款循环检测也-1
            if ([YouMiPointsManager spendPoints:reduceAmount]) {
//                _reducePlatformCount--;
            }
        }else if ([key isEqualToString:WANPU_ID]){
            //万普平台回调接口唯一,所以要有标示符
            _isRuduceGold=YES;
            [AppConnect spendPoints:reduceAmount];
        }
    }
    
//    if (_reducePlatformCount==0) {
//        [self updateReduceGoldInfo:1];
//    }
}

//循环扣积分回调
-(void) updateReduceGoldInfo:(int) pid
{
    //log4Debug(@"reduce %d %d",pid,_reduceRoundCheckCount);
    
//    if (_reduceRoundCheckCount==_reducePlatformCount) {
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
//        }
    }
}

-(void) afterGoldReduced
{
    [self showFUIAlertViewWithTitle:@"恭喜!" message:@"兑换金币成功,客服会在24小时内完成确认与发放,兑换状态可再右边栏查询!" withTag:ReduceGoldSuccessAlertTag cancleButtonTitle:@"确认" otherButtonTitles:nil];
}

-(void) updateGoldInfo:(int) pid
{
    //log4Debug(@"reload %d %d",pid,_platformRoundCheckCount);
    if (_platformRoundCheckCount==APPDELEGATE.platformWithDelegateCount) {
        [self checkUndelegateGold];
 //       APPDELEGATE.userGoldAmont=_latestGoldAmount;
        [self afterGoldReloaded];
    }
}

-(void) checkUndelegateGold
{
    //有米
    if (((GoldPlatForm *)[APPDELEGATE.platformDict objectForKey:YOUMI_ID]).state==1) {
        int totalPoint =[YouMiPointsManager pointsRemained];
 //       int oldGold=[[APPDELEGATE.userGoldDict objectForKey:YOUMI_ID] intValue];
 //       _latestGoldAmount=_latestGoldAmount+totalPoint;
//        if (oldGold!=totalPoint) {
 //           if(totalPoint>oldGold){
//                [UserGold addGoldOnSuccess:^(id json) {
//                    //log4Debug(json);
//                } failure:^(id json) {
//                    [SVProgressHUD showErrorWithStatus:[json objectForKey:@"message"]];
//                } withGoldData:[AppUtilities goldDataEncryptWithPid:YOUMI_ID_INT andGoldAmount:(totalPoint-oldGold)] withSecret:[AppUtilities TheSecretForAddGold:(totalPoint-oldGold) WithOldGold:oldGold withPid:YOUMI_ID_INT]];
//            }else if (totalPoint<oldGold){
//                [UserGold synchroGoldOnSuccess:^(id json) {
//                    //log4Debug(json);
//                } failure:^(id json) {
//                    [SVProgressHUD showErrorWithStatus:[json objectForKey:@"message"]];
//                } withGoldData:[AppUtilities goldDataEncryptWithPid:YOUMI_ID_INT andGoldAmount:totalPoint]];
//            }
//            [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:totalPoint] forKey:YOUMI_ID];
//        }
        if (totalPoint>0) {
            [self reduceGoldInPid:YOUMI_ID withGold:totalPoint];
        }
    }
    
}

-(void) afterGoldReloaded{
    [SVProgressHUD showSuccessWithStatus:@"更新成功!"];
    //[MiidiAdWall requestAwardPoints:100 withDelegate:self];
    //[YouMiPointsManager rewardPoints:100];
    
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
        
//        _latestGoldAmount=_latestGoldAmount+totalPoint;
 //       int oldGold=[[APPDELEGATE.userGoldDict objectForKey:pidStr] intValue];
        if (pid!=SYS_GIF_ID_INT) {
            
//            if (totalPoint!=oldGold) {
//                if(totalPoint>oldGold){
//                    [UserGold addGoldOnSuccess:^(id json) {
//                        //log4Debug(json);
//                    } failure:^(id json) {
//                       [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:oldGold] forKey:pidStr];
//                    } withGoldData:[AppUtilities goldDataEncryptWithPid:pid andGoldAmount:(totalPoint-oldGold)] withSecret:[AppUtilities TheSecretForAddGold:(totalPoint-oldGold) WithOldGold:oldGold withPid:pid]];
//                }else if (totalPoint<oldGold){
//                    [UserGold synchroGoldOnSuccess:^(id json) {
//                        //log4Debug(json);
//                    } failure:^(id json) {
//                        [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:oldGold] forKey:pidStr];
//                    } withGoldData:[AppUtilities goldDataEncryptWithPid:pid andGoldAmount:totalPoint]];
//                }
//                [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:totalPoint] forKey:pidStr];
//            }
            if (totalPoint>0) {
                [self reduceGoldInPid:pidStr withGold:totalPoint];
                //_addToSysGoldAmount=totalPoint;
            }
        }else{
            int oldGold=[[APPDELEGATE.userGoldDict objectForKey:pidStr] intValue];
            if (totalPoint!=oldGold) 
                [APPDELEGATE.userGoldDict setObject:[NSNumber numberWithInt:totalPoint] forKey:pidStr];
        }
        _platformRoundCheckCount++;
        [self updateGoldInfo:pid];
    }
}

-(void) handleReducePlatformGoldWithPid:(int) pid pidStr:(NSString *) pidStr{
    @synchronized(self)
    {
        [UserGold addGoldOnSuccess:^(id json) {
            APPDELEGATE.userGoldAmont=APPDELEGATE.userGoldAmont+_addToSysGoldAmount;
        } failure:^(id json) {
            [SVProgressHUD showErrorWithStatus:[json objectForKey:@"message"]];
        } withGoldData:[AppUtilities goldDataEncryptWithPid:pid andGoldAmount:_addToSysGoldAmount] withSecret:[AppUtilities TheSecretForAddGold:_addToSysGoldAmount WithTotalGold:APPDELEGATE.userGoldAmont withPid:pid]];
        
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
        [self handleReducePlatformGoldWithPid:DOMO_ID_INT pidStr:DOMO_ID];
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
        [self handleReducePlatformGoldWithPid:LIMEI_ID_INT pidStr:LIMEI_ID];
    }
}

#pragma mark DIANRU delegate
/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess
{
    if (isSuccess) {
        [self handleReducePlatformGoldWithPid:DIANRU_ID_INT pidStr:DIANRU_ID];
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
	
	[self handleReducePlatformGoldWithPid:MIDI_ID_INT pidStr:MIDI_ID];
}


- (void)didFailReceiveSpendPoints:(NSError *)error{
	//log4Debug(error);
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
        [self handleReducePlatformGoldWithPid:WANPU_ID_INT pidStr:WANPU_ID];
    }else{
        [self handlePlatformGoldReturnWithGold:pointsValue andPid:WANPU_ID_INT pidStr:WANPU_ID];
    }
}

- (void)getUpdatedPointsFailed:(NSNotification*)notifyObj
{
    [self handleErrorLoadGoldWithPid:WANPU_ID_INT];
}
@end
