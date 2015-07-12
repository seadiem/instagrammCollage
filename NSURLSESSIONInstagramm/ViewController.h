//
//  ViewController.h
//  NSURLSESSIONInstagramm
//
//  Created by mac on 04.05.15.
//  Copyright (c) 2015 soft eng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, NSURLSessionDataDelegate>
@property CGSize resolution;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
@end

