//
//  SetMenu.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-21.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "SetMenu.h"
#import "SetMenuCoreData.h"

@implementation SetMenu

-(SetMenu *) initWithAttributes:(NSDictionary *) attributes
{
    self =[super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    
    self.picUrl=KRequestMenuPicUrl([attributes objectForKey:@"i"]);
    self.setTitle=[attributes objectForKey:@"t"];
    self.saveMoney=[attributes objectForKey:@"s"];
    self.setId=[attributes objectForKey:@"h"];
    self.price=[attributes objectForKey:@"p"];
    
    NSArray *menuArray=[attributes objectForKey:@"c"];
    self.menusString=[menuArray componentsJoinedByString:@","];
    
    return self;
}

+(NSMutableArray *) convertCoreDateToModel:(NSArray *) coreDataArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:coreDataArray.count];
    for (SetMenuCoreData *coreData in coreDataArray) {
        SetMenu *menu =[[SetMenu alloc ] init];
        menu.picUrl=coreData.picUrl;
        menu.setTitle=coreData.setTitle;
        menu.saveMoney=coreData.saveMoney;
        menu.setId=coreData.setId;
        menu.price=coreData.price;
        menu.menusString=coreData.menusString;
        [array addObject:menu];
    }
    return array;

}

-(NSString *) getPicFileName
{
    return [NSString stringWithFormat:@"%@_%@.jpg",self.setId,self.setTitle];
}

-(NSString *) getPicFileLocation
{
    NSString *fileName= [self getPicFileName];
    
    NSString *destinationPath=[[AppUtilities HomeFilePath] stringByAppendingPathComponent:fileName];
    
    return destinationPath;
}

-(BOOL) checkImageFileDownLoaded
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getPicFileLocation]])
    {
        _progressValue=1;
        return YES;
    } 
    return NO;
}

@end
