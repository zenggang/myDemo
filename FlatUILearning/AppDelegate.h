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
@property (nonatomic,strong) NSMutableDictionary *userGoldDict;
@property (nonatomic,strong) NSString *udid;
@property (nonatomic,assign) BOOL isFirstTime;
@property (nonatomic,assign) BOOL isOldVesionUser;
@property (nonatomic,strong) Users *loginUser;
@property (nonatomic,strong) GWVersion *appVersionInfo;
@property (nonatomic,strong) NSArray *exchangeArrayForWall;
@property (nonatomic,strong) NSArray *getGoldArrayForWall;
@property (nonatomic,strong) NSMutableDictionary *platformDict;
@property (nonatomic,assign) int platformWithDelegateCount;


@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) BOOL needUpdateWall;
@property (nonatomic,strong) NSString *deviceToken;
-(void) initUserInfo:(Users *) user;
- (void) registPushNotification;
@end
