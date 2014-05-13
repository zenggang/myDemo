//
//  MainViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-18.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "MainViewController.h"
#import "ApiRequestCenter.h"
#import "TTDate.h"
#import "SetMenuCoreData.h"
#import "ZuanZuanZuanViewController.h"
#import "SingleMenuCoreData.h"
#import "DaZuanPanViewController.h"
#import "YaoQianZuanViewController.h"

@interface MainViewController ()

@property (nonatomic,assign)  BOOL isReloadDataYet;

-(void) checkMenuInfo;
-(void) reloadMenusInfo;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isReloadDataYet=NO;
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     
    if ([APP_NAME isEqualToString: APPNAME_MCDONALD] || [APP_NAME isEqualToString:APPNAME_KFC]) {
        [self checkMenuInfo];
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAppNeedUpdateInfo:) name:APPINFO_DID_LOADED object:nil];
    }else if ([APP_NAME isEqualToString:APPNAME_GUAGUALE]){
        
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"guagualeViewController"];
       
    }else if ([APP_NAME isEqualToString:APPNAME_ZuanZuanZuan])
    {
        self.topViewController =
        
        [[ZuanZuanZuanViewController alloc] initWithNibName:@"ZuanZuanZuanViewController" bundle:nil];
    }else if ([APP_NAME isEqualToString:APPNAME_DAZUANPAN]){
        self.topViewController=[[DaZuanPanViewController alloc] initWithNibName:@"DaZuanPanViewController" bundle:nil];
        
    }else if ([APP_NAME isEqualToString:APPNAME_YAOQIANZUAN]){
        self.topViewController=[[YaoQianZuanViewController alloc] initWithNibName:@"YaoQianZuanViewController" bundle:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) checkAppNeedUpdateInfo:(NSNotification *) notify
{
    int localDataNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"dataSynchNumber"];
    if( APPDELEGATE.appVersionInfo.dataSynchNumber>localDataNumber)
    {
        if (!_isReloadDataYet) {
            [self reloadMenusInfo];
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:APPDELEGATE.appVersionInfo.dataSynchNumber forKey:@"dataSynchNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


-(void) clearPicFileCache
{
    for (SetMenu *menu in APPDELEGATE.allMenuSet) {
         NSString *destinationPath=[[AppUtilities HomeFilePath] stringByAppendingPathComponent:[menu getPicFileName]];
        [AppUtilities removeFileAtPath:destinationPath];
    }
}

-(void) checkMenuInfo
{
    NSDictionary *latestDateInfo =[[NSUserDefaults standardUserDefaults] objectForKey:defaults_latest_menu_date];
    
    if (latestDateInfo) {
        NSDate *latestDate=[latestDateInfo objectForKey:@"latestDate"];
        if ([[NSDate date] timeIntervalSince1970]>([latestDate timeIntervalSince1970]+118800)) {
            [self reloadMenusInfo];
        }else{
            APPDELEGATE.menuDateDic=latestDateInfo; 
            APPDELEGATE.allMenuSet=[SetMenu convertCoreDateToModel:[SetMenuCoreData MR_findAll]];
            APPDELEGATE.allSingleMenuArray=[SingleMenu convertCoreDateToModel:[SingleMenuCoreData MR_findAll]];
            if (APPDELEGATE.allMenuSet.count==0) {
                [self reloadMenusInfo];
            }else{
                [self loadCacheImages];
            }
            
            
        }
    }else{
        [self reloadMenusInfo];
    }
}

- (void) loadCacheImages{
	/* 建立线程操作队列 */
//    NSOperationQueue *queue = [NSOperationQueue new];
//    
//    /* 创建一个NSInvocationOperation对象来在线程中执行loadImagesWithThread操作 */
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
//                                                                            selector:@selector(loadImagesWithThread)
//                                                                              object:nil];
//    /* 将operation添加到线程队列 */
//    [queue addOperation:operation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadImagesWithThread];
    });
    
}

- (void) loadImagesWithThread{
    
    for (SetMenu *setMenu in APPDELEGATE.allMenuSet) {
        //线程从这里执行，可以向普通操作一样读取图片、完成后刷新界面等
        if(![APPDELEGATE.menuImageDict objectForKey:[setMenu getPicFileName]])
        {
            UIImage *theImage = [UIImage imageWithContentsOfFile:[setMenu getPicFileLocation]];
            if (theImage) {
                [APPDELEGATE.menuImageDict setObject:theImage forKey:[setMenu getPicFileName]];
            }
            
        }
        NSLog(@"加载图片");
    }
}

-(void) reloadMenusInfo
{
    
    if (APPDELEGATE.allMenuSet && APPDELEGATE.allMenuSet.count>0) {
         [self clearPicFileCache];
    }
    _isReloadDataYet=YES;
    [AppUtilities showHUDWithStatusMaskTypeClear:@"数据加载中..."];
    NSString *pathUrl=KRequestKfcMenu;
    if ([APP_NAME isEqualToString:APPNAME_MCDONALD]) {
        pathUrl=KRequestLatestMenu;
    }
    [ApiRequestCenter sendGetRequestOnSuccess:^(id data) {
        
        NSArray *menuSetArray=[data objectForKey:@"m"];
        NSMutableArray *menuArray =[NSMutableArray arrayWithCapacity:menuSetArray.count];
        NSArray *oldArray =[SetMenuCoreData MR_findAll];
        for (SetMenuCoreData *setData in oldArray) {
            [setData deleteMenuWithSetTitle];
        }
        
        for (NSDictionary *singleSet in menuSetArray) {
            SetMenu *menu = [[SetMenu alloc] initWithAttributes:singleSet];
            [menuArray addObject:menu];
            [SetMenuCoreData saveSetMenuToDisc:menu];
        }
        APPDELEGATE.allMenuSet=menuArray;
        menuSetArray =[data objectForKey:@"fp"];
        NSMutableArray *singleMenuArray =[NSMutableArray arrayWithCapacity:menuSetArray.count];
        NSArray *oldMenuArray =[SingleMenuCoreData MR_findAll];
        for (SingleMenuCoreData *singleData in oldMenuArray) {
            [singleData deleteMenuWithTitle];
        }
        for (NSDictionary *singleMenu in menuSetArray) {
            SingleMenu *menu = [[SingleMenu alloc] initWithAttributes:singleMenu];
            [singleMenuArray addObject:menu];
            [SingleMenuCoreData saveSingleMenuToDisc:menu ]; 
        }
        APPDELEGATE.allSingleMenuArray=singleMenuArray;
        NSDictionary *menuDateDic =[[NSDictionary alloc ] initWithObjectsAndKeys:[TTDate dateWithString:[data objectForKey:@"e"] dateFormatter:dateFormatterChinese],@"latestDate", [TTDate dateWithString:[data objectForKey:@"s"] dateFormatter:dateFormatterChinese],@"startDate",nil];
        APPDELEGATE.menuDateDic=menuDateDic;
        [AppUtilities dismissHUD];
        [[NSUserDefaults standardUserDefaults] setObject:menuDateDic forKey:defaults_latest_menu_date];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_MENU_UPDATE_SUCCESS object:nil];
    } failure:^(id error) {
        [AppUtilities dismissHUDWithErrorForAWhile:@"加载失败..."];
         
    } withPath:pathUrl parameters:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
