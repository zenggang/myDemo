//
//  UserExchangeNumber.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserExchangeNumber : NSObject

@property (nonatomic,strong) NSString *udid;
@property (nonatomic,strong) NSString *qq;
@property (nonatomic,strong) NSString *zhifubao;
@property (nonatomic,strong) NSString *cellphone;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
