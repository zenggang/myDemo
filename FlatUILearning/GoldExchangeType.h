//
//  GoldPlatform.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldExchangeType : NSObject
@property (nonatomic,assign) int typeId;
@property (nonatomic,strong) NSString *typeContent;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,assign) int goldAmount;
@property (nonatomic,assign) double moneyAmount;
@property (nonatomic,assign) int state;

- (id)initWithAttributes:(NSDictionary *)attributes;
+(AFHTTPRequestOperation *) getAllGoldExchangeTypesOnSuccess:(void (^)(id))success failure:(void (^)(id))failure ;
@end
