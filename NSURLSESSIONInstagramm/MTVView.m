//
//  MTVView.m
//  NSURLSESSIONInstagramm
//
//  Created by mac on 14.06.15.
//  Copyright (c) 2015 soft eng. All rights reserved.
//

#import "MTVView.h"

@interface MTVView () {
    int i;
}

@property CGSize imageSiaze;
@property UIBezierPath *pathOne;
@property UIBezierPath *pathTwo;
@property UIBezierPath *pathThree;
@end


@implementation MTVView

//-(CGImageRef)image
//{
//    if (_image == NULL)
//    {
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"land.jpg" ofType:nil];
//        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
//        _image = CGImageRetain(img.CGImage);
//        [self setAnImage:img];
//    }
//    return _image;
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        i = 0;
        _targetCoords.x = 0;
        _targetCoords.y = 0;
        
        _angleOne = 0.0f;
        

        UIImage *img = image;
        _anImage = img;
        _imageSiaze = _anImage.size;
        _tapPoint = CGPointMake(1, 200);
        
        _imageOne = img;
        _imageTwo = img;
        _imageThree = img;
        
        CGFloat width = [self bounds].size.width;
        CGFloat height = [self bounds].size.height;
        UIBezierPath *pathOne = [UIBezierPath bezierPath];
        [pathOne moveToPoint:CGPointMake(0, 0)];
        [pathOne addLineToPoint:CGPointMake(width, 0)];
        [pathOne addLineToPoint:CGPointMake(width, 200)];
        [pathOne addLineToPoint:CGPointMake(0, 150)];
        [pathOne closePath];
        
        UIBezierPath *pathTwo = [UIBezierPath bezierPath];
        [pathTwo moveToPoint:CGPointMake(0, 150)];
        [pathTwo addLineToPoint:CGPointMake(width, 200)];
        [pathTwo addLineToPoint:CGPointMake(width, 300)];
        [pathTwo addLineToPoint:CGPointMake(0, 350)];
        [pathTwo closePath];
        
        UIBezierPath *pathThree = [UIBezierPath bezierPath];
        [pathThree moveToPoint:CGPointMake(0, 350)];
        [pathThree addLineToPoint:CGPointMake(width, 300)];
        [pathThree addLineToPoint:CGPointMake(width, height)];
        [pathThree addLineToPoint:CGPointMake(0, height)];
        [pathThree closePath];
        
        [self setPathOne:pathOne];
        [self setPathTwo:pathTwo];
        [self setPathThree:pathThree];
    }
    return self;
};


-(int)checkIntersectsWithPoint:(CGPoint)intersectPoint{
    //CGPoint checkPoint = [self tapPoint];
    CGPoint checkPoint = intersectPoint;
    if ([[self pathOne] containsPoint:checkPoint]) {
        i = 1;
    } else if ([[self pathTwo] containsPoint:checkPoint]){
        i = 2;
    } else if ([[self pathThree] containsPoint:checkPoint]){
        i = 3;
    } else {
        i = 4;
    }
    return i;
}

-(void)drawRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, NO, [[UIScreen mainScreen] scale]);
    //[self drawPathes];
    [self drawClipImagesWithContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackGroundImage:image];
    image = nil;
    UIGraphicsEndImageContext();
    [[self backGroundImage] drawAtPoint:CGPointMake(3, 3)];
    
//    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, NO, [[UIScreen mainScreen] scale]);
//    [self drawInContext:UIGraphicsGetCurrentContext()];
//    UIGraphicsEndImageContext();
//    [[self backGroundImage] drawAtPoint:CGPointMake(20, 20)];
}

-(void)drawClipImagesWithContext:(CGContextRef)context{
    
    CGContextSetRGBFillColor(context, 0.4, 0.5, 0.5, 1.0);
    CGContextFillRect(context, [self bounds]);
    
    
    CGFloat xpos = self.targetCoords.x;
    CGFloat ypos = self.targetCoords.y;
    
    CGFloat xposOne = [self targetOne].x;
    CGFloat yposOne = [self targetOne].y;
    
    CGFloat xposTwo = [self targetTwo].x;
    CGFloat yposTwo = [self targetTwo].y;
    
    CGFloat xposThree = [self targetThree].x;
    CGFloat yposThree = [self targetThree].y;
    
    UIBezierPath *pathOne = [self pathOne];
    UIBezierPath *pathTwo = [self pathTwo];
    UIBezierPath *pathThree = [self pathThree];
    
    CGContextSaveGState(context);
    
    [pathOne addClip];
    CGContextTranslateCTM(context, xposOne, yposOne);
    CGContextRotateCTM(context, [self angleOne]);
    CGRect transrect = CGRectMake(-[self imageSiaze].width/4, -[self imageSiaze].height/4, [self imageSiaze].width/2, [self imageSiaze].height/2);
    [[self imageOne] drawInRect:transrect];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    [pathTwo addClip];
    CGContextTranslateCTM(context, xposTwo, yposTwo + 200);
    CGContextRotateCTM(context, [self angleTwo]);
    CGRect transrectTwo = CGRectMake(-[self imageSiaze].width/4, -[self imageSiaze].height/4, [self imageSiaze].width/2, [self imageSiaze].height/2);
    [[self imageTwo] drawInRect:transrectTwo];

    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    [pathThree addClip];
    CGContextTranslateCTM(context, xposThree, yposThree + 400);
    CGContextRotateCTM(context, [self angleThree]);
    CGRect transrectThree = CGRectMake(-[self imageSiaze].width/4, -[self imageSiaze].height/4, [self imageSiaze].width/2, [self imageSiaze].height/2);
    [[self imageThree] drawInRect:transrectThree];
    
    CGContextRestoreGState(context);
}

-(void)drawPathes{
    CGPoint checkPoint = [self tapPoint];
    
    UIBezierPath *pathOne = [self pathOne];
    UIBezierPath *pathTwo = [self pathTwo];
    UIBezierPath *pathThree = [self pathThree];
    
    [[UIColor darkGrayColor] setFill];
    [pathOne fill];
    [pathTwo fill];
    [pathThree fill];
    
    [[UIColor grayColor] setFill];
    
    if (i == 1) {
        [pathOne fill];
    }
    if (i == 2) {
        [pathTwo fill];
    }
    if (i == 3) {
        [pathThree fill];
    }
    
    NSLog(@"tap point x = %f, y = %f", checkPoint.x, checkPoint.y);
    
}

-(BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath *)path{
    if ([path containsPoint:point]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)drawInContext:(CGContextRef)context{
    
    i += 10;
    CGFloat xpos = self.targetCoords.x;
    CGFloat ypos = self.targetCoords.y;
    
    CGContextSetRGBFillColor(context, 0.4, 0.5, 0.5, 1.0);
    CGContextFillRect(context, [self bounds]);
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(200, 0)];
    [aPath addLineToPoint:CGPointMake(100, 200)];
    [aPath closePath];
    [[UIColor whiteColor] setStroke];
    [aPath addClip];
    
    CGContextTranslateCTM(context, xpos, ypos);
    CGContextRotateCTM(context, [self angleOne]);
    CGRect transrect = CGRectMake(-[self imageSiaze].width/2, -[self imageSiaze].height/2, [self imageSiaze].width, [self imageSiaze].height);
    [[self anImage] drawInRect:transrect];
    CGContextRotateCTM(context, -[self angleOne]);
    CGContextTranslateCTM(context, -xpos, -ypos);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackGroundImage:image];
    image = nil;
}

- (void)makeTriangleInContext:(CGColorRef)context{
    
}


@end

