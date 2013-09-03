//
//  AppDelegate.m
//  FlatUILearning
//  Created by gang zeng on 13-5-16.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "AppDelegate.h"
#import "UserGold.h"
#import "DianRuAdWall.h"
#import "MiidiManager.h"
#import "YouMiConfig.h"
#import "YouMiPointsManager.h"
#import "WapsOffer/AppConnect.h"
#import "UIColor+FlatUI.h"
#import "Harpy.h"
 
#define LOOP_CHECK_FIRST_TIME_DELAY 1

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    
    
    _deviceToken=[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    
//    //设置默认记录级别
//    [[L4Logger rootLogger] setLevel:[L4Level debug]];
//    //定义输出目标与日志模板
//    [[L4Logger rootLogger] addAppender: [[L4ConsoleAppender alloc] initTarget:YES withLayout: [L4Layout simpleLayout]]];
    
    _colorDict=[NSDictionary dictionaryWithObjectsAndKeys:@"绿宝石",@"25af95",@"蓝色多瑙河",@"3498DB",@"紫宝石",@"9B59B6",@"太阳花",@"F1C40F",@"沥青色",@"34495E", nil];
    
    _colorbuttonShadowDict=[NSDictionary dictionaryWithObjectsAndKeys:@"16A085",@"25af95",@"2980B9",@"3498DB",@"8E44AD",@"9B59B6",@"F39C12",@"F1C40F",@"2C3E50",@"34495E", nil];
    
    NSString *color =[[NSUserDefaults standardUserDefaults] valueForKey:@"sysColor"];
    if (color) {
        _sysColor=[UIColor colorFromHexCode:color];
        _sysButtonShadowColor=[UIColor colorFromHexCode:[_colorbuttonShadowDict objectForKey:color]];
    }else{
        _sysColor=[UIColor colorFromHexCode:@"25af95"];
        _sysButtonShadowColor=[UIColor colorFromHexCode:[_colorbuttonShadowDict objectForKey:@"25af95"]];
        [[NSUserDefaults standardUserDefaults] setValue:@"25af95" forKey:@"sysColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    _udid=[OpenUDID value];
    _needUpdateWall=NO;
    [self checkUserInfo];
    
    
    //向微信注册wxd930ea5d5a258f4f
    if ([APP_NAME isEqualToString:APPNAME_MCDONALD]) {
        [WXApi registerApp:@"wx24525a8fe72188c6"];
    }else if ([APP_NAME isEqualToString:APPNAME_GUAGUALE]){
        [WXApi registerApp:@"wx0cb9c1a69fbfd2e6"]; 
    }
    [[Harpy sharedInstance] setAppID:@"<app_id>"];
    
    /* (Optional) Set the Alert Type for your app
     By default, the Singleton is initialized to HarpyAlertTypeOption */
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    
    /* (Optional) If your application is not availabe in the U.S. Store, you must specify the two-letter
     country code for the region in which your applicaiton is available in. */
    [[Harpy sharedInstance] setCountryCode:@"cn"];
    
    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];
    
    //[self registPushNotification];
    
    return YES;
}


#pragma mark custom

- (void) registPushNotification {
    // Push Notification Register
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
}

-(void) checkAppInfo 
{
    [GWVersion CheckAppInfoOnSuccess:^(GWVersion *version) {
        _appVersionInfo=version;
        
        [self reloadWallArrayInfo];
        [self platFormInit];
        [[NSNotificationCenter defaultCenter] postNotificationName:APPINFO_DID_LOADED object:nil];
    } failure:^(id error) {
        
        [self platFormInit];
        [AppUtilities handleErrorMessage:error];
    }]; 
}

-(void) checkUserInfo
{
    [Users checkUserInfoOnSuccess:^(Users *user) {
        [self initUserInfo:user];
        [self checkAppInfo];
    } firstTime:^(id json) {
        _isFirstTime=YES;
        [self checkAppInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_IS_FIRST_LOGIN object:nil]; 
    } failure:^(id error) {
        
    }];
}

-(void) reloadWallArrayInfo
{
    [GWVersion GetGoldAndExchangeWallOnSuccess:^(id json) {
        _exchangeArrayForWall=[json objectForKey:@"exchangeList"];
        _getGoldArrayForWall=[json objectForKey:@"getGoldList"];
        [[NSNotificationCenter defaultCenter] postNotificationName:STRING_ARRAY_FOR_WALL_LOADED object:nil]; 
    } failure:^(id error) { 
        [AppUtilities handleErrorMessage:error];
    }];
}

-(void) platFormInit
{
    _platformDict =[NSMutableDictionary dictionaryWithCapacity:_appVersionInfo.platFormList.count];
    for (GoldPlatForm *platform in _appVersionInfo.platFormList) {
        
        if(platform.pid!=YOUMI_ID_INT && platform.state==1)
            _platformWithDelegateCount++;

        [_platformDict setObject:platform forKey:[NSString stringWithFormat:@"%d",platform.pid]];
        switch (platform.pid) {
            case DOMO_ID_INT:
            {
                if (platform.state==1) 
                    //点入平台初始化0000210E0F000068 //test 000092040C0000C5
                    [DianRuAdWall beforehandAdWallWithDianRuAppKey:@"0000210E0F000068"];
            }
                break;
            case MIDI_ID_INT:
            {
                if (platform.state==1)
                    //米迪平台
                    // 设置发布应用的应用id, 应用密码等信息,必须在应用启动的时候呼叫
                    // 参数 appID		:开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
                    // 参数 appPassword	:开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
                    // 参数 testMode		:广告条请求模式 ;    正式发布应用,务必设置为NO,否则不能计费
                    //
                    [MiidiManager setAppPublisher:@"13914"  withAppSecret:@"jkw334m8ou8r1bp4" withTestMode:NO];
            }
                break;
            case YOUMI_ID_INT:
            {
                if (platform.state==1){
                    //有米
                    //warning 替换下面的appID和appSecret为你的appid和appSecret 6191437ca20f2a14 45e2b6f1f2a6ef2b
                    //my 4b77592b4375aa19 8a05c985c4fb77ea
                    [YouMiConfig setShouldGetLocation:NO];
                    [YouMiConfig launchWithAppID:@"4b77592b4375aa19" appSecret:@"8a05c985c4fb77ea"];
                    // 开启积分管理
                    [YouMiPointsManager enable];
                    [YouMiConfig useInAppStore];
                }
            }
                break;
            case WANPU_ID_INT:
            {
                if (platform.state==1)
                    //万普
                    [AppConnect getConnect:@"17b99c6bf8a3a9ee28653d77ad3712c0" pid:@"appstore"];
            }
                break; 
                
            default:
                break;
        }
    }
}

-(void) initUserInfo:(Users *) user{
    _isOldVesionUser=NO;
    _loginUser=user;
    _userGoldAmont=0;
    _userGoldDict=[NSMutableDictionary dictionary];
    for (UserGold *gold in _loginUser.userGoldList) {
        [_userGoldDict setObject:[NSNumber numberWithInt:gold.goldAmount ] forKey:[NSString stringWithFormat:@"%d",gold.pid]];
        _userGoldAmont+=gold.goldAmount;
        if (gold.pid>1 && gold.goldAmount) {
            _isOldVesionUser=YES;
        }
    }
}

#pragma mark sys
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Get a hex string from the device token with no spaces or < >
    /*
     self.deviceToken = [[[[_deviceToken description]
     stringByReplacingOccurrencesOfString: @"<" withString: @""]
     stringByReplacingOccurrencesOfString: @">" withString: @""]
     stringByReplacingOccurrencesOfString: @" " withString: @""];
     */
    //NSLog(@"Device Token: %@", [_deviceToken description]);
    self.deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //LOG_EXPR(self.deviceToken);
    
    if ([application enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
        NSLog(@"Notifications are disabled for this application. Not registering for GOLF.");
        return; 
    }
    [[NSUserDefaults standardUserDefaults] setValue:self.deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [Users checkUserInfoOnSuccess:^(Users *user) {
    } firstTime:^(id json) {
    } failure:^(id error) { 
    }];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _needUpdateWall=YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_needUpdateWall) {
        [self reloadWallArrayInfo];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}


#pragma mark WXApiDelegate
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //[self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
       // [self onShowMediaMessage:temp.message];
    }
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEI_XIN_DID_RETURN object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:resp,@"sendMessageToWXResp", nil]];
       
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEI_XIN_OAuth_DID_RETURN object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:resp,@"sendAuthResp", nil]];
    }
}
@end
