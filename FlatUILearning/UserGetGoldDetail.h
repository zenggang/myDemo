//
//  UserGetGoldDetail.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGetGoldDetail : NSObject
@property (nonatomic,assign) int gid;
@property (nonatomic,strong) NSString *udid;
@property (nonatomic,strong) NSString *postDate;
@property (nonatomic,assign) int pid;
@property (nonatomic,strong) NSString *pCnName;
@property (nonatomic,assign) int goldAmount;
@property (nonatomic,strong) NSString *meno;

- (id)initWithAttributes:(NSDictionary *)attributes;
+(AFHTTPRequestOperation *) getUserGetGoldLogOnSuccess:(void (^)(id))success failure:(void (^)(id))failure pageNo:(int) pageNo;
@end
