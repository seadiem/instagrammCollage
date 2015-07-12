//
//  MTVCoord.m
//  NSURLSESSIONInstagramm
//
//  Created by mac on 13.06.15.
//  Copyright (c) 2015 soft eng. All rights reserved.
//

#import "MTVCoord.h"

@implementation MTVCoord
- (id)initWithPoint:(CGPoint)point{
    self = [super init];
    
    if (self) {
        //_coord = point;
        _coord.x = point.x + 30;
        _coord.y = point.y + 30;
    }
    
    return self;
}
- (NSString *)description{
    NSString *descString = [NSString stringWithFormat:@"xpos = %.0f, ypos = %.0f", [self coord].x, [self coord].y];
    return descString;
}
@end
