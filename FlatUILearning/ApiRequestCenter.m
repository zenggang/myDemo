//
//  ApiRequestCenter.m
//  NewStartTest
//
//  Created by gang zeng on 13-4-17.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "ApiRequestCenter.h"

@implementation ApiRequestCenter


+(AFHTTPRequestOperation *) sendGetRequestOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withPath:(NSString *) path parameters:(NSDictionary *) param
{
    NSMutableDictionary *newParam =[NSMutableDictionary dictionaryWithDictionary:param];
//    [newParam addEntriesFromDictionary:accessAppInfo];
    [newParam addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:VERSION_STRING,@"version",APP_NAME,@"appName", nil]];
    return [ApiRequestCenter sendRequestOnSuccess:success failure:failure withPath:path parameters:newParam requestWithMethod:kRequestMethodGet];
}

+(AFHTTPRequestOperation *) sendPostRequestOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withPath:(NSString *) path parameters:(NSMutableDictionary *) param
{
    
    [param addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:VERSION_STRING,@"version",APP_NAME,@"appName", nil]];
    return [ApiRequestCenter sendRequestOnSuccess:success failure:failure withPath:path parameters:param requestWithMethod:kRequestMethodPost];
}

+(AFHTTPRequestOperation *) sendRequestOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withPath:(NSString *) path parameters:(NSDictionary *) param requestWithMethod:(NSString *) method
{
    AFHTTPClient *client = [AFGolfAPIClient sharedClient];
    NSURLRequest *request = [client requestWithMethod:method path:path parameters:param];
    
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            success(responseObject);
        }
        else if ([[responseObject objectForKey:@"error"] intValue]==1) {
            if (failure) {
                //log4Error(@"%@",responseObject);
                failure(responseObject);
            }
        }else if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //log4Error(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"网络请求失败!"];
            failure(error);
        }
    }]; 
    [client enqueueHTTPRequestOperation:operation];
    return operation;
} 

@end
