//
//  GuaGuaKaLog.h
//  FlatUILearning
//
//  Created by gang zeng on 13-9-26.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuaGuaKaLog : NSObject

@property (nonatomic,assign) int logId;
@property (nonatomic,strong) NSString *udid;
@property (nonatomic,assign) int gid;
@property (nonatomic,strong) NSString *postDate;
@property (nonatomic,assign) int resultValue;
@property (nonatomic,assign) int benjin;
@property (nonatomic,assign) double appVersion;

+(AFHTTPRequestOperation *) getGuaGuaKaLogWithPageNo:(int) pageNo OnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end
