//
//  MTVCoord.h
//  NSURLSESSIONInstagramm
//
//  Created by mac on 13.06.15.
//  Copyright (c) 2015 soft eng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface MTVCoord : NSObject
@property CGFloat xpos;
@property CGFloat ypos;
@property CGPoint coord;
- (id)initWithPoint:(CGPoint)point;
- (NSString *)description;
@end
