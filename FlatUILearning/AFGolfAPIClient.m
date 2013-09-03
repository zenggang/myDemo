//
//  AFScanCardAPIClient.m
//  golfmedia2
//
//  Created by Ljx 李洁信 on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFGolfAPIClient.h"
#import "AFJSONRequestOperation.h"

#if (DEBUG==0)
    static NSString * const kAFGolfAPIBaseURLString = @"http://176.34.16.52:8080/";
#else
    static NSString * const kAFGolfAPIBaseURLString = @"http://54.248.126.168/";
#endif 

@implementation AFGolfAPIClient

+ (AFGolfAPIClient *)sharedClient {
    static AFGolfAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFGolfAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
