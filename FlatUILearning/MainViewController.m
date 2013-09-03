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
#import "SingleMenuCoreData.h"


@interface MainViewController ()

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
    
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    if ([APP_NAME isEqualToString: APPNAME_MCDONALD]) {
        [self checkMenuInfo];
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
    }else if ([APP_NAME isEqualToString:APPNAME_GUAGUALE]){
        
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"guagualeViewController"];
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
            }
            
        }
    }else{
        [self reloadMenusInfo];
    }
}

-(void) reloadMenusInfo
{
    [AppUtilities showHUDWithStatusMaskTypeClear:@"数据加载中..."];
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
         
    } withPath:KRequestLatestMenu parameters:nil];
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
