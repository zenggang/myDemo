//
//  BaseGoldViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-3.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMOfferWallViewController.h"
#import <immobSDK/immobView.h>
#import "DianRuAdWall.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "YouMiWall.h"
#import "YouMiPointsManager.h"
#import "GoldExchangeType.h"
#import "UserGold.h"
#import <Escore/YJFIntegralWall.h>
#import <Escore/YJFScore.h>
#import "DianRuSDK.h"
#import "MopanAdWall.h"
#import "ADCPowerWallViewController.h"
#import "ADCPowerWallViewControllerDelegate.h"
#import "ADCError.h"
#import "DMOfferWallManager.h"
#import "MobiSageOfferWallViewController.h"
#import <AdWalker/AdHotWall.h>
#import <AdWalker/GuScoreWall.h>
#import <AdWalker/PobFrameWall.h>
#import <AdWalker/GuScore.h>

#define exchangeGoldAlertTag 234
#define goldNotEnoughAlertTag  235
#define exchangeGoldNotSetNumberAlertTag 236
#define ReduceGoldSuccessAlertTag 237

@interface BaseGoldViewController : BaseListViewController<DMOfferWallDelegate,immobViewDelegate,DianRuAdWallDelegate,DianRuSDKDelegate,MiidiAdWallShowAppOffersDelegate,MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate,YJFIntegralWallDelegate,MopanAdWallDelegate,ADCPowerWallViewControllerDelegate,DMOfferWallManagerDelegate,MobiSageOfferWallDelegate,GuHotWallDelegate,GuScoreWallDelegate>

-(void) afterGoldReloaded;
-(void) reduceGold;
-(void) afterGoldReduced;
@property (nonatomic,strong) GoldExchangeType *reduceGoldType;
@property (nonatomic,strong) NSString *exchangeNumber;
@property (nonatomic,assign) BOOL isGuaGuaLeDeduce;
@property (nonatomic,assign) int guaGuaLeDeduceGoldAmount;
@property (nonatomic,strong) DianRuSDK *dianruBannarView;
@property (nonatomic,strong) MopanAdWall *mopanAdWallControl;
@property (nonatomic,strong) ADCPowerWallViewController *powerWallViewController;
@property (nonatomic,strong) MobiSageOfferWallViewController *owViewController;

@end
