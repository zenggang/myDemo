//
//  SingleMenu.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-21.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleMenu : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * price;

-(SingleMenu *) initWithAttributes:(NSDictionary *) attributes;
+(NSMutableArray *) convertCoreDateToModel:(NSArray *) coreDataArray;
@end
