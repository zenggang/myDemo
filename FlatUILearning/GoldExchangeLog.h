//
//  GoldExchangeLog.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldExchangeLog : NSObject

@property (nonatomic,assign) int eid;
@property (nonatomic,strong) NSString   *udid;
@property (nonatomic,strong) NSString   *postDate;
@property (nonatomic,assign) int        typeId;
@property (nonatomic,strong) NSString   *receiveNumber;
@property (nonatomic,assign) int        state;
@property (nonatomic,strong) NSString   *exchangeDate;

@property (nonatomic,strong) NSString   *typeContent;
@property (nonatomic,assign) int        goldAmount;

- (id)initWithAttributes:(NSDictionary *)attributes;
+(AFHTTPRequestOperation *) getUserExchangeLogOnSuccess:(void (^)(id))success failure:(void (^)(id))failure pageNo:(int) pageNo;
@end
