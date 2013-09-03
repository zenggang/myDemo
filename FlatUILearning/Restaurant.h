//
//  Restaurant.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-24.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequestCenter.h"
@interface Restaurant : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;


-(Restaurant *) initWithAttributes:(NSDictionary *) attributes;
+(AFHTTPRequestOperation *) getNearByRestaurantOnSuccess:(void (^)(id))success failure:(void (^)(id))failure parameters:(NSDictionary *) param;
@end
