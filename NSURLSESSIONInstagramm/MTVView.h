//
//  MTVView.h
//  NSURLSESSIONInstagramm
//
//  Created by mac on 14.06.15.
//  Copyright (c) 2015 soft eng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTVView : UIView
@property CGFloat angleOne;
@property CGFloat angleTwo;
@property CGFloat angleThree;
@property CGPoint targetCoords;
@property CGPoint targetOne;
@property CGPoint targetTwo;
@property CGPoint targetThree;
@property CGPoint tapPoint;
@property UIImage *backGroundImage;
@property UIImage *anImage;
@property UIImage *imageOne;
@property UIImage *imageTwo;
@property UIImage *imageThree;
- (void)checkIntersects;
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
- (int)checkIntersectsWithPoint:(CGPoint)intersectPoint;
@end
