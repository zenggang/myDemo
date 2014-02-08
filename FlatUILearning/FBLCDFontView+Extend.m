//
//  FBLCDFontView+Extend.m
//  FlatUILearning
//
//  Created by gang zeng on 13-12-30.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "FBLCDFontView+Extend.h"

@implementation FBLCDFontView (Extend)

-(void) setIntNumber:(int) number numberSize:(int) numberSize
{
    NSMutableString *fomartString=[NSMutableString stringWithString:[NSString stringWithFormat:@"%d",number]];
    int zeroCount = numberSize-[fomartString length];
    for (int i=0; i<zeroCount; i++) {
        [fomartString insertString:@"0" atIndex:0];
    }
    [self updateText:[NSString stringWithFormat:@"%@",fomartString]];
}
-(void) updateText:(NSString *) text
{
    self.text=text;
    [self setNeedsDisplay];
}
@end
