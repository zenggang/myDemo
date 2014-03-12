//
//  AppDelegate.h
//  FlatUILearning
//
//  Created by gang zeng on 13-5-16.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenUDID.h"
#import "Users.h"
#import "GWVersion.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIColor *sysColor;
@property (strong,nonatomic) UIColor *sysButtonShadowColor;
@property (nonatomic,strong) NSDictionary *colorDict;
@property (nonatomic,strong) NSDictionary *colorbuttonShadowDict;
//麦当劳相关
@property (nonatomic,strong) NSDictionary *menuDateDic;
@property (nonatomic,strong) NSMutableArray *allMenuSet;
@property (nonatomic,strong) NSMutableArray *allSingleMenuArray;

//用户金币相关
@property (nonatomic,assign) int userGoldAmont;
//@property (nonatomic,strong) NSMutableDictionary *userGoldDict;
@property (nonatomic,strong) NSString *udid;
@property (nonatomic,assign) BOOL isFirstTime;
@property (nonatomic,assign) BOOL isOldVesionUser;
@property (nonatomic,assign) int  oldVesionUserPlatIdCount;
@property (nonatomic,strong) Users *loginUser;
@property (nonatomic,strong) GWVersion *appVersionInfo;
@property (nonatomic,strong) NSArray *exchangeArrayForWall;
@property (nonatomic,strong) NSArray *getGoldArrayForWall;
@property (nonatomic,strong) NSMutableDictionary *platformDict;
@property (nonatomic,assign) int platformCount;
@property (nonatomic,assign) int announcementId;

//图片缓存dict
@property (nonatomic,strong) NSMutableDictionary *menuImageDict;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) BOOL needUpdateWall;
@property (nonatomic,strong) NSString *deviceToken;
@property (nonatomic,assign) BOOL isAllowMusic;
@property (nonatomic,assign) BOOL isAllowSound;
@property (nonatomic,assign) BOOL isChangeStatusBarY;

//平台相关
@property (nonatomic,strong) GoldPlatForm *DuoMenPlatform;
@property (nonatomic,strong) GoldPlatForm *LiMeiPlatform;
@property (nonatomic,strong) GoldPlatForm *DianRuPlatform;
@property (nonatomic,strong) GoldPlatForm *MidiPlatform;
@property (nonatomic,strong) GoldPlatForm *YouMiPlatform;
@property (nonatomic,strong) GoldPlatForm *WanPuPlatform;
@property (nonatomic,strong) GoldPlatForm *AnWoPlatform;
@property (nonatomic,strong) GoldPlatForm *YiJiFenPlatform;
@property (nonatomic,strong) GoldPlatForm *MoPanPlatform;
@property (nonatomic,strong) GoldPlatForm *AiPuDongLiPlatform;


-(void) initUserInfo:(Users *) user;
- (void) registPushNotification;
@end
