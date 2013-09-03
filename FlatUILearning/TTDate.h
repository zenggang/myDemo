//
//  TTDate.h
//  Golf_fourm
//
//  Created by 张峰 on 13-3-29.
//  Copyright (c) 2013年 Âº†Â≥∞. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dateFormatterUntilSSS @"yyyy-MM-dd HH:mm:ss ZZZZ"
#define dateFormatterUntilSS @"yyyy-MM-dd HH:mm:ss"
#define dateFormatterUntilMM @"yyyy-MM-dd HH:ss"
#define dateFormatterUntilHH @"yyyy-MM-dd HH"
#define dateFormatterUntilDD @"yyyy-MM-dd"
#define dateFormatterUSA @"MMM dd, yyyy"
#define dateFormatterChinese @"yyyy年M月dd日"
/*
    时间相关类，继承自NSDate
*/
@interface TTDate : NSDate 

+ (NSDateFormatter *)loadNsDateFormatter;
+(NSString *)dateString:(NSDate *)date dateFormatter:(NSString *)formatter;

+(NSDate *)dateWithString:(NSString *)timeStr dateFormatter:(NSString *)formatter;

+(NSString*)convertDateFormatter:(NSString*)sourceFormatter targetFormatter:(NSString*)targetFormatter dateString:(NSString*)dateString;

//从一个时间推算出据现在有多长时间
+ (NSString *) fromNowTimeFromDate:(NSDate *)date;

@end
