//
//  GoldPlatform.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GoldExchangeType.h"

@implementation GoldExchangeType

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) return self;
    _typeContent=[attributes objectForKey:@"typeContent"];
    _typeId=[[attributes objectForKey:@"typeId"] intValue];
    _typeName=[attributes objectForKey:@"typeName"];
    _moneyAmount=[[attributes objectForKey:@"moneyAmount"] doubleValue];
    _goldAmount=[[attributes objectForKey:@"goldAmount"] intValue];
    _state=[[attributes objectForKey:@"state"] intValue];
    return self;
}

+(AFHTTPRequestOperation *) getAllGoldExchangeTypesOnSuccess:(void (^)(id))success failure:(void (^)(id))failure {
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        
        if (success) {
            NSMutableArray *mutableArray=[NSMutableArray arrayWithCapacity:[json count]];
            for (NSDictionary *attribute in json) {
                GoldExchangeType *type=[[GoldExchangeType alloc] initWithAttributes:attribute];
                [mutableArray addObject:type];
            }
            success(mutableArray);
        }
    } failure:^(id error) {
        if (failure) {
            [AppUtilities handleErrorMessage:error];
            failure(error);
        }
    } withPath:GOLDRequestExchangeTypes parameters:nil];
}
@end
