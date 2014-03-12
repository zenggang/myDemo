//
//  GuaGuaKa.h
//  FlatUILearning
//
//  Created by gang zeng on 13-9-25.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuaGuaKa : NSObject
@property (nonatomic, assign) int gid;
@property (nonatomic, assign) int benjin;
@property (nonatomic, assign) double baobenRate;
@property (nonatomic, assign) int state;

+(AFHTTPRequestOperation *) getGuaGuaKaListOnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) buyGuaGuaKaWithGid:(int) gid OnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end
