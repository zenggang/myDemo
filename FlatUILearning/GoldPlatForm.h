//
//  GoldPlatForm.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-8.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldPlatForm : NSObject

@property (nonatomic,assign) int pid;
@property (nonatomic,strong) NSString *pName;
@property (nonatomic,strong) NSString *pCnName;
@property (nonatomic,assign) int state;
@property (nonatomic,strong) NSString *appKey;
@property (nonatomic,strong) NSString *appSecret;
- (id)initWithAttributes:(NSDictionary *)attributes;
@end
