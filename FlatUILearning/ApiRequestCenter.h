//
//  ApiRequestCenter.h
//  NewStartTest
//
//  Created by gang zeng on 13-4-17.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFGolfAPIClient.h"


#define accessAppInfo [NSDictionary dictionaryWithObjectsAndKeys:LANGUAGE_CODE,@"language",APP_NAME,@"appName", nil]
#define forumBoardsUrl @"golf/api/board/"
@interface ApiRequestCenter : NSObject


+(AFHTTPRequestOperation *) sendGetRequestOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withPath:(NSString *) path parameters:(NSDictionary *) param;

+(AFHTTPRequestOperation *) sendPostRequestOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withPath:(NSString *) path parameters:(NSMutableDictionary *) param;

+(AFHTTPRequestOperation *) sendRequestOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withPath:(NSString *) path parameters:(NSDictionary *) param requestWithMethod:(NSString *) method;
@end
