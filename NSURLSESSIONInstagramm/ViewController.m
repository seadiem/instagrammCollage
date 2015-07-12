//
//  ViewController.m
//  NSURLSESSIONInstagramm
//
//  Created by mac on 04.05.15.
//  Copyright (c) 2015 soft eng. All rights reserved.
//

#import "ViewController.h"
#import "MTVCoord.h"
#import "MTVView.h"

@interface ViewController () <UITextFieldDelegate>
{
    BOOL inInsta;
    BOOL mustInstaLoad;
    int checker;
}

@property BOOL inIsta;
@property BOOL mustIstaLoad;

@property UIView *canvasView;
@property UIView *transitionView;
@property UIView *predBackgroundView;
@property UIWebView *webView;

//-------debug view
@property UITextView *debugView;
@property NSString *placeHolder;
@property CGPoint startTap;

//-------diluting view
@property UIView *dilutingView;

//-------text Field view
@property UITextField *nameField;

//-------animation button view
@property UIButton *animationButton;

//-------instagram part
@property UIView *instaCanvasView;
@property UIView *instagramView;
@property NSString *accessToken;
@property NSString *userID;
@property NSMutableArray *defaultCoords;

//-------net part
@property NSURLSession *epheralSession;
@property NSURLSessionConfiguration *epheralConfigObject;
@property NSArray *linkArray;
@property NSArray *standartResArray;

- (void)transitionToNextWithBool:(BOOL)whichView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *angilla = [UIFont fontWithName:@"AngillaTattooPersonalUse" size:20.0f];
    UIFont *angillaBig = [UIFont fontWithName:@"AngillaTattooPersonalUse" size:50.0f];
    
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
    
    [self setDefaultCoords:[NSMutableArray array]];
    
    [self setInIsta:NO];
    inInsta = NO;
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    [self setResolution:windowFrame.size];
    
    CGSize resolution = [self resolution];
    
    CGRect canvasRect = CGRectMake(10, 20, resolution.width - 30, resolution.height - 42);
    UIColor *orangeColor = [UIColor colorWithRed:210/255.f green:100/255.f blue:100/255.f alpha:1.0];
    [self setCanvasView:[[UIView alloc] initWithFrame:canvasRect]];
    [[self canvasView] setBackgroundColor:orangeColor];
    [[self view] addSubview:[self canvasView]];
    
    CGRect transitionViewRect = CGRectMake(5, 0, resolution.width - 40, resolution.height - 50);
    [self setTransitionView:[[UIView alloc] initWithFrame:transitionViewRect]];
    [[self transitionView] setBackgroundColor:[UIColor colorWithRed:102/255.f green:166/255.f blue:10/255.f alpha:1.0]];
    [[self canvasView] addSubview:[self transitionView]];
    
    CGRect predMainRect = CGRectMake(5, 0, resolution.width - 50, resolution.height - 70);
    UIColor *blueColor = [UIColor colorWithRed:64/255.f green:211/255.f blue:228/255.f alpha:1.0];
    [self setPredBackgroundView:[[UIView alloc] initWithFrame:predMainRect]];
    [[self predBackgroundView] setBackgroundColor:blueColor];
    [[self transitionView] addSubview:[self predBackgroundView]];
    
    [[self view] setBackgroundColor:[UIColor darkGrayColor]];
    
    CGRect webrect = CGRectMake(0, 145, predMainRect.size.width, 250);
    [self setWebView:[[UIWebView alloc] initWithFrame:webrect]];
    [[self webView] setBackgroundColor:blueColor];
    [[self webView] setDelegate:self];
    [[self predBackgroundView] addSubview:[self webView]];
    
    CGRect rectButTon = CGRectMake(0, 30, 80, 50);
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [actionButton setFrame:rectButTon];
    [actionButton setTitle:@"Mail Load" forState:UIControlStateNormal];
    [actionButton setTintColor:[UIColor whiteColor]];
    [actionButton addTarget:self action:@selector(startLoading:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rectButTonTwo = CGRectMake(0, 30, 100, 50);
    UIButton *googleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [googleButton setFrame:rectButTonTwo];
    [googleButton setTitle:@"Google Load" forState:UIControlStateNormal];
    [googleButton setTintColor:[UIColor whiteColor]];
    [googleButton addTarget:self action:@selector(startLoading:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rectButTonThree = CGRectMake(0, 45, [[self predBackgroundView] bounds].size.width, 100);
    UIButton *instaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [instaButton setFrame:rectButTonThree];
    [instaButton setTitle:@"Login" forState:UIControlStateNormal];
    [instaButton setTintColor:[UIColor whiteColor]];
    [instaButton setBackgroundColor:[UIColor colorWithRed:(68 + 20)/255.f green:(215 + 20)/255.f blue:(233 + 20)/255.f alpha:8.0]];
    [instaButton addTarget:self action:@selector(startLoading:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self predBackgroundView] addSubview:actionButton];
    [[self predBackgroundView] addSubview:googleButton];
    [[self predBackgroundView] addSubview:instaButton];
   
    
    //------DebugView
    UIFont *debugFont = [UIFont systemFontOfSize:5];
    UITextView *debugView = [[UITextView alloc] initWithFrame:CGRectMake( 0, resolution.height - 40, 120, 200) textContainer:nil];
    [debugView setTextColor:[UIColor whiteColor]];
    [debugView setFont:debugFont];
    UIColor *textBackColor = [UIColor colorWithRed:210/255.f green:100/255.f blue:100/255.f alpha:0.0];
    [debugView setBackgroundColor:textBackColor];;
    [debugView setEditable:NO];
    [[self debugView] setText:[NSString stringWithFormat:@"InInsta = %i \nmustIstaLoad = %i", [self inIsta], [self mustIstaLoad]]];
    [self setDebugView:debugView];
    [[self view] addSubview:[self debugView]];
    [self setStartTap:CGPointMake(0, 0)];
    
    //----------Instagram Part
    //---InstaCanvas View
    CGRect instaCanvas = CGRectMake(3, 3, transitionViewRect.size.width - 6, resolution.height - 60);
    [self setInstaCanvasView:[[UIView alloc] initWithFrame:predMainRect]];
    [[self instaCanvasView] setBackgroundColor:[UIColor orangeColor]];
    
    
    //---Instagram View (Brown)
    [self setMustIstaLoad:NO];
    CGRect instagramRect = CGRectMake(3, 103, resolution.width - 56, resolution.height - 170);
    [self setInstagramView:[[UIView alloc] initWithFrame:instagramRect]];
    UIColor *instaColor = [UIColor colorWithRed:121/255.f green:71/255.f blue:16/255.f alpha:1.0];
    [[self instagramView] setBackgroundColor:instaColor];
    [[self instaCanvasView] addSubview:[self instagramView]];
    
    //---Diluting View
    CGRect dilutingRect = CGRectMake(3, 40, instagramRect.size.width, 90);
    UIView *dilView = [[UIView alloc] initWithFrame:dilutingRect];
    [dilView setBackgroundColor:[UIColor darkGrayColor]];
    [self setDilutingView:dilView];
    [[self instaCanvasView] addSubview:dilView];
    
    //---Text Field
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, instagramRect.size.width, 90)];
    [textField setBackgroundColor:[UIColor purpleColor]];
    [textField setFont:angillaBig];
    [textField setAdjustsFontSizeToFitWidth:YES];
    [textField setTextAlignment:NSTextAlignmentCenter];
    textField.placeholder = NSLocalizedString(@"Placeholder text", nil);
    textField.returnKeyType = UIReturnKeyDone;
    [textField setDelegate:self];
    [self setNameField:textField];
    //[[self dilutingView] addSubview:[self nameField]];
    //[[self nameField] becomeFirstResponder];
    
    //---Animation Button
    CGRect instButtonrect = CGRectMake(instagramRect.size.width / 2 - 250 / 2, 10, 250, 40);
    UIButton *trigAnimation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [trigAnimation setFrame:instButtonrect];
    [trigAnimation setFont:angilla];
    [trigAnimation setTitle:@"Trig Animation" forState:UIControlStateNormal];
    [trigAnimation setTintColor:[UIColor whiteColor]];
    [trigAnimation addTarget:self action:@selector(diluting:) forControlEvents:UIControlEventTouchUpInside];
    [trigAnimation setBackgroundColor:[UIColor grayColor]];
    [self setAnimationButton:trigAnimation];
    [[self dilutingView] addSubview:[self animationButton]];
    
    //--rearange
    [[self instaCanvasView] bringSubviewToFront:[self instagramView]];
    
    //------Net Part
    [self setEpheralConfigObject:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    [self setEpheralSession:[NSURLSession sessionWithConfiguration:[self epheralConfigObject] delegate:nil delegateQueue:[NSOperationQueue mainQueue]]];
    
    //-------------------------setup instagramView Hierarchy
    //------setup mini views
    CGFloat xpos = 0;
    CGFloat ypos = 0;
    for (int i = 0; i < 6; i ++) {
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning:)];
        
        CGPoint coord = CGPointMake(xpos, ypos);
        MTVCoord *coordObj = [[MTVCoord alloc] initWithPoint:coord];
        [[self defaultCoords] addObject:coordObj];
        
        CGRect rect = CGRectMake(xpos, ypos, 60, 60);
        UIView *tempView = [[UIView alloc] initWithFrame:rect];
        [tempView setBackgroundColor:[UIColor colorWithRed:210/255.f green:100/255.f blue:100/255.f alpha:1.0]];
        [tempView setTag:i + 1];
        [tempView addGestureRecognizer:panRecognizer];
        [tempView setClipsToBounds:YES];
        [[self instagramView] addSubview:tempView];
        xpos += 61;
        if (xpos > 60 * 1) {
            ypos += 61;
            xpos = 0;
        }
    }
    //------setup drawning view
    CGRect drawingRect = CGRectMake(61, 0, [[self instagramView] bounds].size.width - 61, [[self instagramView] bounds].size.height - 5);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"imageHolder.png" ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    MTVView *drawingView = [[MTVView alloc] initWithFrame:drawingRect andImage:img];
    [drawingView setTag:100];
    [[self instagramView] addSubview:drawingView];
    
    //------- add Logout
    CGRect rectButTonFour = CGRectMake(3, 0, 100, 40);
    UIButton *resetDefaults = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [resetDefaults setBackgroundColor:[UIColor blackColor]];
    [resetDefaults setTag:50];
    [resetDefaults setFrame:rectButTonFour];
    [resetDefaults setTitle:@"Log Out" forState:UIControlStateNormal];
    [resetDefaults setTintColor:[UIColor whiteColor]];
    [resetDefaults addTarget:self action:@selector(resetDefaults:) forControlEvents:UIControlEventTouchUpInside];
    [[self instaCanvasView] addSubview:resetDefaults];
    
    //------- send to e-mail
    CGRect emailbuttonRect = CGRectMake(103, 0, instaCanvas.size.width - 106, 40);
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setBackgroundColor:[UIColor colorWithRed:45/255.f green:45/255.f blue:45/255.f alpha:1.0]];
    [sendButton setFrame:emailbuttonRect];
    [sendButton setTitle:@"send to e-mail" forState:UIControlStateNormal];
    [sendButton setTintColor:[UIColor whiteColor]];
    [sendButton addTarget:self action:@selector(saveToFile:) forControlEvents:UIControlEventTouchUpInside];
    [[self instaCanvasView] addSubview:sendButton];
    
    //------- recognizaers part
    UIColor *thirdColor = [UIColor colorWithRed:228/255.f green:43/255.f blue:143/255.f alpha:1.0];
    CGRect activeRect = CGRectMake(0, 0, 10, 10);
    UIView *activeView = [[UIView alloc] initWithFrame:activeRect];
    [activeView setTag:90];
    [activeView setBackgroundColor:thirdColor];
    [[self instaCanvasView] addSubview:activeView];
    
     UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panningImage:)];
    [[self instaCanvasView] addGestureRecognizer:panRecognizer];
    
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateDrawingView:)];
    [[self instaCanvasView] addGestureRecognizer:rotateRecognizer];
    
    //[self startLoading:instaButton];
}

- (void)setInIsta:(BOOL)inIsta{
    if (inInsta != _inIsta) {
        _inIsta = inInsta;
        [self reloadDebugText];
    }
}

- (void)setMustIstaLoad:(BOOL)mustIstaLoad{
    _mustIstaLoad = mustIstaLoad;
    [self reloadDebugText];
}

- (void)setStartTap:(CGPoint)startTap{
    _startTap = startTap;
    [self reloadDebugText];
}

- (void)reloadDebugText{
    [[self debugView] setText:[NSString stringWithFormat:@"InInsta = %i \nmustIstaLoad = %i \nstartx = %f \nstarty = %f", [self inIsta], [self mustIstaLoad], [self startTap].x, [self startTap].y]];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"loading is started");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self inIsta]) {
        NSLog(@"we are in the webView");
        NSLog(@"%@", [[self webView] request]);
        
        NSURLRequest *tempRequest = [[self webView] request];
        NSURL *requestURL = [tempRequest URL];
        NSString *requestString = [requestURL absoluteString];
        
        NSLog(@"string is '%@'", requestString);
        
        NSRange range = [requestString rangeOfString:@"access_token"];
        NSLog(@"NSRange");
        NSLog(@"location = %lu", range.location);
        NSLog(@"length = %lu", range.length);
        
        //----------inner to instagramm part
        if (range.length > 0) {
            NSLog(@"Lets working on");
            [self transitionToNextWithBool:YES];
            [self getTokenWithString:requestString];
            [self setMustIstaLoad:YES];
            //---net part
            [[[self epheralSession] dataTaskWithURL:[NSURL URLWithString:[self getGallery]]
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                     [self handlingSelfUserData:data];
                                 }] resume ];
        }
        
    } else {
        NSLog(@"loading is finished");
    }
}

- (void)innerInInstagrampart{
    NSLog(@"reload instagemm part with name %@", [[self nameField] text]);
    NSString *firstPart = @"https://api.instagram.com/v1/users/search?q=";
    NSString *secondPart = [firstPart stringByAppendingString:[[self nameField] text]];
    NSString *thirdPart = [secondPart stringByAppendingString:@"&access_token="];
    NSString *fourthPart = [thirdPart stringByAppendingString:[self accessToken]];
    [[[self epheralSession] dataTaskWithURL:[NSURL URLWithString:fourthPart]
                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                              [self handlingSelfUserData:data];
                          }] resume ];
}

- (NSString *)getGallery{
    NSString *firstPart = @"https://api.instagram.com/v1/users/search?q=";
    NSString *secondPart = [firstPart stringByAppendingString:@"buzurka"];
    NSString *thirdPart = [secondPart stringByAppendingString:@"&access_token="];
    NSString *fourthPart = [thirdPart stringByAppendingString:[self accessToken]];
    return fourthPart;
}

- (NSString *)getMyFeed{
    NSString *firstPart = @"https://api.instagram.com/v1/users/self/feed?access_token=";
    NSString *secondPart = [firstPart stringByAppendingString:[self accessToken]];
    return secondPart;
}

- (NSString *)getMyProfile{
    NSString *firstPart = @"https://api.instagram.com/v1/users/";
    NSString *secondPart = [firstPart stringByAppendingString:@"self/"];
    NSString *thirdPart = [secondPart stringByAppendingString:@"?access_token="];
    NSString *fourthPart = [thirdPart stringByAppendingString:[self accessToken]];
    return fourthPart;
}

- (void)handlingSelfUserData:(NSData *)data{
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSDictionary *jsonDictopnary = result;
    NSLog(@"%@", jsonDictopnary);
    NSArray *dataArray = [jsonDictopnary valueForKey:@"data"];
    //NSLog(@"%i", [dataArray count]);
    if ([dataArray count] == 0) {
        NSLog(@" user not found");
        [[self nameField] setText:@""];
        [[self nameField] setPlaceholder:@" user not found"];
    } else {
        NSLog(@"user founded");
        NSDictionary *profile = [dataArray objectAtIndex:0];
        NSString *identifier = [profile objectForKey:@"id"];
        NSString *placeHolder = [profile objectForKey:@"full_name"];
        [[self nameField] setText:@""];
        [[self nameField] setPlaceholder:placeHolder];
        NSLog(@"identifier = %@", identifier);
        [self setUserID:identifier];
        [[self animationButton] setTitle:placeHolder forState:UIControlStateNormal];
        [[[self epheralSession] dataTaskWithURL:[NSURL URLWithString:[self getRecentMediaStrind]]
                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                  NSLog(@"download compleet");
                                  [self getTenLinksFromData:data];
                              }] resume ];
    }
}

- (NSString *)getRecentMediaStrind{
    NSString *firstPart = @"https://api.instagram.com/v1/users/";
    NSString *secondPart = [firstPart stringByAppendingString:[self userID]];
    NSString *thirdPart = [secondPart stringByAppendingString:@"/media/recent/?access_token="];
    NSString *fourthPart = [thirdPart stringByAppendingString:[self accessToken]];
    return fourthPart;
}

- (void)handlingData:(NSData *)data{
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSDictionary *jsonArray = result;
    NSLog(@"\n");
    NSLog(@"%@", [jsonArray allKeys]);
    NSArray *dataDictionary = [jsonArray valueForKey:@"data"];
 
        
        for (int i = 0; i < [dataDictionary count]; i ++) {
            NSDictionary *tempDictionary = [dataDictionary objectAtIndex:i];
            NSLog(@"%@ \n", [tempDictionary valueForKey:@"username"]);
        }
   
}

- (void)getTenLinksFromData:(NSData *)data{
    NSMutableArray *imagesURL = [NSMutableArray array];
    NSMutableArray *standartResURL = [NSMutableArray array];
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSDictionary *jsonDictopnary = result;
    NSLog(@"%@", [jsonDictopnary allKeys]);
    NSLog(@"%@", jsonDictopnary);
    
    if ([jsonDictopnary objectForKey:@"data"] == nil) {
        NSLog(@"you are not a friends");
        [[self nameField] setPlaceholder:@"you are not a friends"];
    } else {
    NSArray *array = [jsonDictopnary objectForKey:@"data"];
    NSLog(@"%lu", (unsigned long)[array count]);
        if ([array count] == 0) {
            NSLog(@"gallery not exist");
            [[self nameField] setPlaceholder:@"gallery not exist"];
        } else {
            for (int i = 0; i < [array count] - 1; i ++) {
            NSDictionary *image = [array objectAtIndex:i];
            //NSLog(@"%@", [[[image objectForKey:@"images"] objectForKey:@"low_resolution"]objectForKey:@"url"]);
            NSString *tempString = [[[image objectForKey:@"images"] objectForKey:@"low_resolution"]objectForKey:@"url"];
            [imagesURL addObject:tempString];
            tempString = [[[image objectForKey:@"images"] objectForKey:@"standard_resolution"]objectForKey:@"url"];
            [standartResURL addObject:tempString];
            }
         NSLog(@"%@", imagesURL);
         [self addingSubviewWithLinks:[NSArray arrayWithArray:imagesURL]];
         [self setStandartResArray:[NSArray arrayWithArray:standartResURL]];
         NSLog(@"%@", [self standartResArray]);
       }
    }
}

- (void)addingSubviewWithLinks:(NSArray *)array{
    //NSLog(@"%@", array);
    [self InstagramPartWithArray:array];
}

- (void)getTokenWithString:(NSString *)string{
    NSRange range = [string rangeOfString:@"="];
    NSLog(@"get tokken NSRange");
    NSLog(@"location = %lu", range.location);
    NSLog(@"length = %lu", range.length);
    NSArray *split = [string componentsSeparatedByString:@"="];
    NSLog(@"%@", split);
    [self setAccessToken:[split objectAtIndex:1]];
    NSLog(@"acess token is %@", [self accessToken]);
}

- (void)transitionToNextWithBool:(BOOL)whichView{
    
    UIView *fromView, *toView;
    if (whichView == NO) {
        fromView = [self instaCanvasView];
        toView = [self predBackgroundView];
    } else {
        fromView = [self predBackgroundView];
        toView = [self instaCanvasView];
    }
    [UIView transitionFromView:fromView toView:toView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
        //[[self nameField] becomeFirstResponder];
    }];
}

- (void)startLoading:(UIButton *)sender{
    NSURL *mail = [NSURL URLWithString:@"http://www.mail.ru"];
    NSURL *google = [NSURL URLWithString:@"http://www.google.com"];
    NSURL *insta = [NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id=65099edf61364ab1b1e328fa84c1a274&redirect_uri=http://vh59205.eurodir.ru/auth/auth.html&response_type=token"];
    
    if ([[[sender titleLabel] text] isEqual:@"Mail Load"]) {
        inInsta = NO;
        [self setInIsta:NO];
        NSURLRequest *request = [NSURLRequest requestWithURL:mail];
        [[self webView] loadRequest:request];
    } else if ([[[sender titleLabel] text] isEqual:@"Login"]){
        inInsta = YES;
        [self setInIsta:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:insta cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
        [[self webView] loadRequest:request];
    } else{
        inInsta = NO;
        [self setInIsta:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:google];
        [[self webView] loadRequest:request];
    }
    
}

- (void)resetDefaults:(UIButton *)sender{
    NSLog(@"Reset User");
    NSURL *insta = [NSURL URLWithString:@"https://instagram.com/accounts/logout/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:insta cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    [[self webView] loadRequest:request];
    
    if ([self mustIstaLoad]) {
        [self transitionToNextWithBool:NO];
        [self setMustIstaLoad:NO];
        
        for (int i = 0; i < 8; i ++) {
            UIView *tempView = [[self instagramView] viewWithTag:i + 1];
            UIImageView *tempImageView = [tempView viewWithTag:10];
            [tempImageView removeFromSuperview];
        }
    }
}

//------Instagram Part

- (void)addMtvViewWithArray:(NSArray *)array{
    
//    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    [tempView setBackgroundColor:[UIColor redColor]];
//    [[self instagramView] addSubview:tempView];
    
//    CGRect drawingRect = CGRectMake(61, 0, [[self instagramView] bounds].size.width - 61, [[self instagramView] bounds].size.height - 61);
//
//[[[self epheralSession] dataTaskWithURL:[NSURL URLWithString:[array objectAtIndex:8]]
//                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                         NSLog(@"MTVView data task got response %@  \n with error %@. \n", response, error);
//                         UIImage *image = [UIImage imageWithData:data];
//                         MTVView *drawingView = [[MTVView alloc] initWithFrame:drawingRect andImage:image];
//                         [drawingView setTag:100];
//                         [[self instagramView] addSubview:drawingView];
//                     }] resume ];
}

- (void)InstagramPartWithArray:(NSArray *)array{
    [self addMtvViewWithArray:array];
    [[self instagramView] setTag:20];
    //NSLog(@"%@", array);
   [self setLinkArray:array];
    
   for (int j = 0; j < 4; j ++) {
        [[[self epheralSession] dataTaskWithURL:[NSURL URLWithString:[array objectAtIndex:j]]
                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                  NSLog(@"loading images");
                                  NSLog(@"got response %@  \n with error %@. \n", response, error);
                                  UIImage *image = [UIImage imageWithData:data scale:5];
                                  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                  [imageView setTag:10];
                                  UIView *tempView = [[self instagramView] viewWithTag:j + 1];
                                  [tempView setBackgroundColor:[UIColor colorWithRed:210/255.f green:100/255.f blue:100/255.f alpha:1.0]];
                                  [tempView addSubview:imageView];
                              }] resume ];
    }
    
     NSLog(@"%@", [self defaultCoords]);
    MTVCoord *tempObject = [[self defaultCoords] objectAtIndex:0];
    NSLog(@"xpos = %0.1f", [tempObject coord].x);
}


- (void)diluting:(id)sender{
    UIView *fromView, *toView;
    if ([[self animationButton] superview] != nil) {
        fromView = [self animationButton];
        toView = [self nameField];
    } else {
        fromView = [self nameField];
        toView = [self animationButton];
    }
    [UIView transitionFromView:fromView toView:toView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished){}];
    if (sender == self) {
        [self trigAnimationWithBool:NO];
    } else {
        [self trigAnimationWithBool:YES];
    }
}

- (void)trigAnimationWithBool:(BOOL)check{
   NSLog(@"Animation start");
    
    CGPoint targetPoint;
    
    if (check) {
        CGPoint originCenter = [[self instagramView] center];
        targetPoint = CGPointMake(originCenter.x, originCenter.y + 90/4);
        [[self nameField] becomeFirstResponder];
    } else {
        CGPoint originCenter = [[self instagramView] center];
        targetPoint = CGPointMake(originCenter.x, originCenter.y - 90/4);
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                       [[self instagramView] setCenter:targetPoint];
                     }
                     completion:^(BOOL finished) {}
    ];

    
}

- (void)panning:(UIPanGestureRecognizer *)recognizer{
  
    UIView *senderView = [recognizer view];
    [[senderView superview] bringSubviewToFront:senderView];
    NSLog(@"tag = %i", [senderView tag]);
    
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged){
        NSLog(@"panning");
        CGPoint translation = [recognizer translationInView:[recognizer view]];
        [senderView setCenter:CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)];
        [recognizer setTranslation:CGPointZero inView:[recognizer view]];
        [senderView setBackgroundColor:[UIColor lightGrayColor]];
    }
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        MTVCoord *tempCorrd = [[self defaultCoords] objectAtIndex:[senderView tag] - 1];
        CGPoint startPoint = [tempCorrd coord];
        
        [senderView setBackgroundColor:[UIColor colorWithRed:210/255.f green:100/255.f blue:100/255.f alpha:1.0]];
        BOOL intercect = [self reloadImageWithSendersTag:[senderView tag] endLocation:[recognizer locationInView:[[self instaCanvasView] viewWithTag:100]]];
        NSLog(@"intercect = %i", intercect);
        
        CGRect originrect = [senderView bounds];
        CGRect targetRect = CGRectMake(originrect.origin.x, originrect.origin.y, originrect.size.width - 10, originrect.size.height - 10);
        
        if (intercect) {
            [UIView animateWithDuration:0.1 animations:^{
                [senderView setBounds:targetRect];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    [senderView setBounds:originrect];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        [senderView setCenter:startPoint];
                    }];
                }];
            }];
        } else {
        [UIView animateWithDuration:0.5 animations:^{
            [senderView setCenter:startPoint];
        }];
        }
    }
    
}

- (BOOL)reloadImageWithSendersTag:(int)tag endLocation:(CGPoint)location{
    CGPoint intersectPoint = location;
    MTVView *drawningView = (MTVView *)[[self instaCanvasView] viewWithTag:100];
    checker = [drawningView checkIntersectsWithPoint:intersectPoint];
    NSLog(@"checker = %i", checker);
    [[[self epheralSession] dataTaskWithURL:[NSURL URLWithString:[[self standartResArray] objectAtIndex:tag - 1]]
                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          UIImage *image = [UIImage imageWithData:data];
                             switch (checker) {
                                 case 1:
                                     [drawningView setImageOne:image];
                                     break;
                                 case 2:
                                     [drawningView setImageTwo:image];
                                     break;
                                 case 3:
                                     [drawningView setImageThree:image];
                                     break;
                                 default:
                                     break;
                             }
                             [drawningView setNeedsDisplay];
                         }] resume ];
    if (checker != 4) {
        return YES;
    } else {
        return NO;
    }
}

- (void)panningImage:(UIPanGestureRecognizer *)recognizer{
    
    MTVView *drawningView = (MTVView *)[[self instaCanvasView] viewWithTag:100];
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        [self setStartTap:[recognizer locationInView:drawningView]];
        checker = [drawningView checkIntersectsWithPoint:[self startTap]];
    }
    
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        NSLog(@"Panning");
        UIView *activeView = [[self instaCanvasView] viewWithTag:90];
        CGPoint translation = [recognizer translationInView:[recognizer view]];
        [activeView setCenter:CGPointMake([activeView center].x + translation.x, [activeView center].y + translation.y)];

        CGPoint transmitTranslation = CGPointMake(drawningView.targetCoords.x + translation.x, drawningView.targetCoords.y + translation.y);
        [drawningView setTargetCoords:transmitTranslation];
        
        switch (checker) {
            case 1:
                [drawningView setTargetOne:CGPointMake(drawningView.targetOne.x + translation.x, drawningView.targetOne.y + translation.y)];
                break;
            case 2:
                [drawningView setTargetTwo:CGPointMake(drawningView.targetTwo.x + translation.x, drawningView.targetTwo.y + translation.y)];
                break;
            case 3:
                [drawningView setTargetThree:CGPointMake(drawningView.targetThree.x + translation.x, drawningView.targetThree.y + translation.y)];
                break;
            default:
                //[drawningView setTargetOne:CGPointMake(drawningView.targetOne.x + translation.x, drawningView.targetOne.y + translation.y)];
                //[drawningView setTargetTwo:CGPointMake(drawningView.targetTwo.x + translation.x, drawningView.targetTwo.y + translation.y)];
                break;
        }
        [drawningView setNeedsDisplay];
        [recognizer setTranslation:CGPointZero inView:[recognizer view]];
        NSLog(@"checker = %i", checker);
    }
}

- (void)rotateDrawingView:(UIRotationGestureRecognizer *)recognizer{
    NSLog(@"rotation");
    MTVView *drawningView = (MTVView *)[[self instaCanvasView] viewWithTag:100];
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        [self setStartTap:[recognizer locationInView:drawningView]];
        checker = [drawningView checkIntersectsWithPoint:[self startTap]];
    }
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        switch (checker) {
            case 1:
                [drawningView setAngleOne:([drawningView angleOne] + [recognizer rotation])];
                break;
            case 2:
                [drawningView setAngleTwo:([drawningView angleTwo] + [recognizer rotation])];
                break;
            case 3:
                [drawningView setAngleThree:([drawningView angleThree] + [recognizer rotation])];
                break;
            default:
                break;
        }
        [drawningView setNeedsDisplay];
        [recognizer setRotation:0];
         NSLog(@"checker = %i", checker);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self diluting:self];
    [self innerInInstagrampart];
    return YES;
}

- (void)saveToFile:(UIButton *)sender{
    NSString *directoryLocate = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", directoryLocate);
    NSString *filePath = [directoryLocate stringByAppendingPathComponent:@"PICTURE.jpg"];
    NSLog(@"%@", filePath);
    MTVView *drawningView = (MTVView *)[[self instaCanvasView] viewWithTag:100];
    NSData *jpgdata = UIImageJPEGRepresentation([drawningView backGroundImage], 0.5);
    [jpgdata writeToFile:filePath atomically:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
