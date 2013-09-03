//
//  TTDate.m
//  Golf_fourm
//
//  Created by 张峰 on 13-3-29.
//  Copyright (c) 2013年 Âº†Â≥∞. All rights reserved.
//

#import "TTDate.h"

@implementation TTDate


+ (NSDateFormatter *)loadNsDateFormatter  {
    static NSDateFormatter *instance;
   
    if(!instance) {
        instance = [[NSDateFormatter alloc] init];
        
    }
    return instance;
}

+(NSString *)dateString:(NSDate *)date dateFormatter:(NSString *)formatter{
    if (!formatter) {
        formatter = dateFormatterUntilDD;
    }
    NSDateFormatter *dateFormatter = [TTDate loadNsDateFormatter];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+(NSDate *)dateWithString:(NSString *)timeStr dateFormatter:(NSString *)formatter{
    if (!formatter) {
        formatter = dateFormatterUntilDD;
    }
    NSDateFormatter *dateFormatter = [TTDate loadNsDateFormatter];
    [dateFormatter setDateFormat:formatter];
    NSDate * date = [dateFormatter dateFromString:timeStr];
    return date;
}

+(NSString*)convertDateFormatter:(NSString*)sourceFormatter targetFormatter:(NSString*)targetFormatter dateString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [TTDate loadNsDateFormatter];
    [dateFormatter setDateFormat:sourceFormatter];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:targetFormatter];
    
    return[dateFormatter stringFromDate:date];
}

+ (NSString *) fromNowTimeFromDate:(NSDate *)date {
    NSTimeInterval t =[date timeIntervalSinceNow];
    int time = [[NSNumber numberWithDouble:t] intValue]*-1;
    
    if (time<0) {
        time=1;
    }
    //gghhhhh
    
    if (time<60) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d秒前", nil),time==0 ? 1:time];
    } else if(time < 3600){
        time = [[NSNumber numberWithDouble:time*0.01666666667 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", nil),time==0 ? 1:time];
    }else if(time<86400){
        time = [[NSNumber numberWithDouble:time*0.0002777777778 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", nil),time==0 ? 1:time];
    }else if(time<2592000){
        time = [[NSNumber numberWithDouble:time*0.000011574074074 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", nil),time==0 ? 1:time];
    }else{
        time = [[NSNumber numberWithDouble:time*0.0000003858 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d个月前", nil),time==0 ? 1:time];
    }
}
@end
