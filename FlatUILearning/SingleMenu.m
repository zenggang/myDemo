//
//  SingleMenu.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-21.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "SingleMenu.h"
#import "SingleMenuCoreData.h"

@implementation SingleMenu


-(SingleMenu *) initWithAttributes:(NSDictionary *) attributes
{
    self =[super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    self.title=[attributes objectForKey:@"n"];
    self.price=[attributes objectForKey:@"p"];
    return self;
}

+(NSMutableArray *) convertCoreDateToModel:(NSArray *) coreDataArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:coreDataArray.count];
    for (SingleMenuCoreData *coreData in coreDataArray) {
        SingleMenu *menu =[[SingleMenu alloc ] init];
        menu.price=coreData.price;
        menu.title=coreData.title;
        [array addObject:menu];
    }
    return array;
}

@end
