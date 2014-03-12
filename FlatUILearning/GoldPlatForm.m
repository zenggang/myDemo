//
//  GoldPlatForm.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-8.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GoldPlatForm.h"

@implementation GoldPlatForm

- (id)initWithAttributes:(NSDictionary *)attributes
{
    _pid =[[attributes objectForKey:@"pid"] intValue];
    _pName =[attributes objectForKey:@"pName"];
    _pCnName=[attributes objectForKey:@"pCnName"];
    _state=[[attributes objectForKey:@"state"] intValue];
    _appKey=[attributes objectForKey:@"appKey"];
    _appSecret=[attributes objectForKey:@"appSecret"];
    _mediaId =[attributes objectForKey:@"mediaId"];
    return self;
}
@end
