//
//  GuaGuaKa.m
//  FlatUILearning
//
//  Created by gang zeng on 13-9-25.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GuaGuaKa.h"

@implementation GuaGuaKa


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _gid=[[attributes objectForKey:@"gid"] integerValue];
    _benjin=[[attributes objectForKey:@"benjin"] integerValue];
    
    _baobenRate=[[attributes objectForKey:@"baobenRate"] doubleValue];
    _state=[[attributes objectForKey:@"state"] integerValue];
    
    return self;
}


+(AFHTTPRequestOperation *) getGuaGuaKaListOnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        
        NSMutableArray *list =[NSMutableArray arrayWithCapacity:[json count]];
        if (success) {
            for (NSDictionary *temp in json) {
                GuaGuaKa *gauguaka =[[GuaGuaKa alloc] initWithAttributes:temp];
                [list addObject:gauguaka];
            }
            success(list);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestGAUGUAKaList parameters:nil];
}

+(AFHTTPRequestOperation *) buyGuaGuaKaWithGid:(int) gid OnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendPostRequestOnSuccess:^(id json) {
        
        if (success) {
            success(json); 
        } 
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestBuyGuaGuaKa(APPDELEGATE.udid) parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:gid],@"gid", nil]];
}

@end
