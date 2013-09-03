//
//  Restaurant.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-24.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant

-(Restaurant *) initWithAttributes:(NSDictionary *) attributes
{
    self =[super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    _name=[attributes objectForKey:@"name"];
    _address=[attributes objectForKey:@"vicinity"];
    NSDictionary *location=[[attributes objectForKey:@"geometry"] objectForKey:@"location"];
    _latitude=[[location objectForKey:@"lat"] doubleValue];
    _longitude=[[location objectForKey:@"lng"] doubleValue];
    
    return self;
}

+(AFHTTPRequestOperation *) getNearByRestaurantOnSuccess:(void (^)(id))success failure:(void (^)(id))failure parameters:(NSDictionary *) param
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id data) {
        if (success) {
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:[[data objectForKey:@"results"] count]];
            for (id obj in [data objectForKey:@"results"]) {
                Restaurant *res =[[Restaurant alloc ] initWithAttributes:obj];
                [array addObject:res];
            }
            success(array);
        }
    } failure:^(id error) {
        failure(error);
    } withPath:KRequestFindNearbyRestaurant([[param objectForKey:@"lat"] doubleValue],[[param objectForKey:@"lng"] doubleValue]) parameters:nil];
}
@end
