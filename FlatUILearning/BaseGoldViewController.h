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

#define exchangeGoldAlertTag 234
#define goldNotEnoughAlertTag  235
#define exchangeGoldNotSetNumberAlertTag 236
#define ReduceGoldSuccessAlertTag 237

@interface BaseGoldViewController : BaseListViewController<DMOfferWallDelegate,immobViewDelegate,DianRuAdWallDelegate,MiidiAdWallShowAppOffersDelegate,MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate,YJFIntegralWallDelegate>

-(void) afterGoldReloaded;
-(void) reduceGold;
-(void) afterGoldReduced;
@property (nonatomic,strong) GoldExchangeType *reduceGoldType;
@property (nonatomic,strong) NSString *exchangeNumber;
@property (nonatomic,assign) BOOL isGuaGuaLeDeduce;
@property (nonatomic,assign) int guaGuaLeDeduceGoldAmount;
@end
