//
//  UserExchangeNumber.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "UserExchangeNumber.h"

@implementation UserExchangeNumber


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) return self;
    
    _udid=[attributes objectForKey:@"udid"];
    _qq=[attributes objectForKey:@"qq"];
    _cellphone=[attributes objectForKey:@"cellphone"];
    _zhifubao=[attributes objectForKey:@"zhifubao"];
    return self;
}
@end
