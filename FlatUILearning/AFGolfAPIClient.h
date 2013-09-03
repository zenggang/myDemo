//
//  AFScanCardAPIClient.h
//  golfmedia2
//
//  Created by Ljx 李洁信 on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface AFGolfAPIClient : AFHTTPClient

+ (AFGolfAPIClient *)sharedClient;
@end
