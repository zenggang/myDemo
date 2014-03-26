//
//  NSObject_AllObjectDefine.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-20.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

//appDelegate
#import "AppDelegate.h"

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568) 

//Color
#define GREEN_COLOR APPDELEGATE.sysColor
#define CELL_SELECT_COLOR [UIColor colorFromHexCode:@"e5e8ee"]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

//广告平台对后台platForm的Id
#define SYS_GIF_ID    @"1"
#define DOMO_ID       @"2"
#define LIMEI_ID      @"3"
#define DIANRU_ID      @"4"
#define MIDI_ID      @"5"
#define YOUMI_ID    @"6"
#define WANPU_ID    @"7"
#define ANWO_ID     @"8"
#define YIJIFEN_ID  @"9"
#define AIPUDONGLI_ID  @"10"
#define MOPAN_ID  @"11"
#define AIDESIQI_ID @"12"
#define XINGYUN_ID @"13"

#define SYS_GIF_ID_INT   1
#define DOMO_ID_INT 2
#define LIMEI_ID_INT 3
#define DIANRU_ID_INT 4
#define MIDI_ID_INT 5
#define YOUMI_ID_INT   6
#define WANPU_ID_INT   7
#define ANWO_ID_INT    8
#define YIJIFEN_ID_INT 9
#define AIPUDONGLI_ID_INT  10
#define MOPAN_ID_INT  11
#define AIDESIQI_ID_INT 12
#define XINGYUN_ID_INT 13


